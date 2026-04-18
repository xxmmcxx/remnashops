import asyncio
from contextlib import asynccontextmanager
from typing import AsyncGenerator

from aiogram import Dispatcher
from aiogram.types import WebhookInfo
from dishka import AsyncContainer, Scope
from fastapi import FastAPI
from loguru import logger
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncEngine

from src.application.common import Remnawave, TranslatorHub
from src.application.common.dao import SettingsDao
from src.application.events import (
    BotShutdownEvent,
    BotStartupEvent,
    RemnawaveErrorEvent,
    RemnawaveVersionWarningEvent,
    WebhookErrorEvent,
)
from src.application.events.system import RemnashopWelcomeEvent
from src.application.services import BotService, CommandService, WebhookService
from src.application.use_cases.gateways.commands.payment import CreateDefaultPaymentGateway
from src.core.config import AppConfig
from src.core.constants import REMNAWAVE_MAX_VERSION
from src.core.utils.i18n_helpers import i18n_format_seconds
from src.core.utils.time import get_uptime
from src.infrastructure.services import BotRegistry, EventBusImpl
from src.web.endpoints import TelegramWebhookEndpoint


async def ensure_runtime_enums(engine: AsyncEngine) -> None:
    async with engine.begin() as connection:
        await connection.execute(
            text("ALTER TYPE payment_gateway_type ADD VALUE IF NOT EXISTS 'CARD2CARD'")
        )
        await connection.execute(text("ALTER TYPE currency ADD VALUE IF NOT EXISTS 'TOMAN'"))

        await connection.execute(
            text(
                """
                UPDATE payment_gateways
                SET currency = (SELECT default_currency FROM settings LIMIT 1)
                WHERE type != 'TELEGRAM_STARS'
                  AND currency != (SELECT default_currency FROM settings LIMIT 1)
                """
            )
        )


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None, None]:
    dispatcher: Dispatcher = app.state.dispatcher
    telegram_webhook_endpoint: TelegramWebhookEndpoint = app.state.telegram_webhook_endpoint
    container: AsyncContainer = app.state.dishka_container

    event_bus = await container.get(EventBusImpl)
    event_bus.set_container_factory(lambda: container)
    event_bus.autodiscover()

    async with container(scope=Scope.REQUEST) as startup_container:
        config = await startup_container.get(AppConfig)
        bot_registry = await startup_container.get(BotRegistry)
        settings_dao = await startup_container.get(SettingsDao)
        webhook_service = await startup_container.get(WebhookService)
        translator_hub = await startup_container.get(TranslatorHub)
        remnawave_service = await startup_container.get(Remnawave)
        db_engine = await startup_container.get(AsyncEngine)
        create_default_payment_gateway = await startup_container.get(CreateDefaultPaymentGateway)

        await ensure_runtime_enums(db_engine)

        primary_states: dict[str, str] | None = None

        for bot_instance, bot in bot_registry.iter_bots():
            bot_service = BotService(bot=bot, config=config)
            states = await bot_service.get_bot_states()

            if primary_states is None:
                primary_states = states

            if not await bot_service.is_inline_enabled():
                logger.warning(
                    f"Bot '{bot_instance.key}' is not enabled for inline mode. "
                    "Please enable Inline Mode in BotFather for correct work of some features"
                )

        await create_default_payment_gateway.system()
        settings = await settings_dao.get()
        allowed_updates = dispatcher.resolve_used_update_types()

        for bot_instance, bot in bot_registry.iter_bots():
            webhook_info: WebhookInfo = await webhook_service.setup_webhook_for_bot(
                allowed_updates=allowed_updates,
                bot=bot,
                webhook_path=bot_instance.webhook_path,
                secret_token=bot_instance.secret_token.get_secret_value(),
                drop_pending_updates=bot_instance.drop_pending_updates,
                reset_webhook=bot_instance.reset_webhook,
            )

            if webhook_service.has_error(webhook_info, bot=bot):
                logger.critical(
                    f"Webhook has a last error message for bot '{bot_instance.key}': "
                    f"'{webhook_info.last_error_message}'"
                )
                webhook_error_event = WebhookErrorEvent()
                await event_bus.publish(webhook_error_event)

            command_service = CommandService(
                bot=bot,
                config=config,
                translator_hub=translator_hub,
            )
            await command_service.setup_commands(is_enabled=bot_instance.setup_commands)

        if primary_states is None:
            primary_states = {
                "groups_mode": "Unknown",
                "privacy_mode": "Unknown",
                "inline_mode": "Unknown",
            }

    await telegram_webhook_endpoint.startup()

    logger.opt(colors=True).info(
        rf"""
    <cyan> _____                                _                 </>
    <cyan>|  __ \                              | |                </>
    <cyan>| |__) |___ _ __ ___  _ __   __ _ ___| |__   ___  _ __  </>
    <cyan>|  _  // _ \ '_ ` _ \| '_ \ / _` / __| '_ \ / _ \| '_ \ </>
    <cyan>| | \ \  __/ | | | | | | | | (_| \__ \ | | | (_) | |_) |</>
    <cyan>|_|  \_\___|_| |_| |_|_| |_|\__,_|___/_| |_|\___/| .__/ </>
    <cyan>                                                 | |    </>
    <cyan>                                                 |_|    </>

        <green>Build Time: {config.build.time}</>
        <green>Branch: {config.build.branch} ({config.build.tag})</>
        <green>Commit: {config.build.commit}</>
        <green>Bots configured: {len(config.bot_instances)}</>
        <cyan>------------------------</>
        Groups Mode  - {primary_states["groups_mode"]}"
        Privacy Mode - {primary_states["privacy_mode"]}"
        Inline Mode  - {primary_states["inline_mode"]}"
        <cyan>------------------------</>
        <yellow>Bot in access mode: '{settings.access.mode}'</>
        <yellow>Payments allowed: '{settings.access.payments_allowed}'</>
        <yellow>Registration allowed: '{settings.access.registration_allowed}'</>
        """  # noqa: W605
    )

    await event_bus.publish(RemnashopWelcomeEvent())

    bot_startup_event = BotStartupEvent(
        **config.build.data,
        access_mode=settings.access.mode,
        payments_allowed=settings.access.payments_allowed,
        registration_allowed=settings.access.registration_allowed,
    )
    await event_bus.publish(bot_startup_event)

    try:
        panel_version = await remnawave_service.try_connection()
        if panel_version >= REMNAWAVE_MAX_VERSION:
            await event_bus.publish(
                RemnawaveVersionWarningEvent(
                    **config.build.data,
                    panel_version=str(panel_version),
                )
            )
    except Exception as e:
        remnawave_error_event = RemnawaveErrorEvent(**config.build.data, exception=e)
        await event_bus.publish(remnawave_error_event)

    yield

    bot_shutdown_event = BotShutdownEvent(
        **config.build.data,
        uptime=i18n_format_seconds(get_uptime()),
    )
    await event_bus.publish(bot_shutdown_event)

    await asyncio.sleep(2)

    await event_bus.shutdown()
    await telegram_webhook_endpoint.shutdown()

    async with container(scope=Scope.REQUEST) as shutdown_container:
        config = await shutdown_container.get(AppConfig)
        bot_registry = await shutdown_container.get(BotRegistry)
        webhook_service = await shutdown_container.get(WebhookService)
        translator_hub = await shutdown_container.get(TranslatorHub)

        for bot_instance, bot in bot_registry.iter_bots():
            command_service = CommandService(
                bot=bot,
                config=config,
                translator_hub=translator_hub,
            )
            await command_service.delete_commands()
            await webhook_service.delete_webhook_for_bot(
                bot=bot,
                reset_webhook=bot_instance.reset_webhook,
            )

        await bot_registry.shutdown()

    await container.close()
