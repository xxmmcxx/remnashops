import asyncio
import secrets
from typing import Annotated, Any

from aiogram import Bot, Dispatcher
from aiogram.methods import TelegramMethod
from aiogram.types import Update
from dishka.integrations.fastapi import FromDishka, inject
from fastapi import Body, FastAPI, Header, HTTPException, Response, status
from loguru import logger

from src.core.config import AppConfig
from src.infrastructure.services import BotRegistry


class TelegramWebhookEndpoint:
    dispatcher: Dispatcher
    _feed_update_tasks: set[asyncio.Task[Any]]

    def __init__(self, dispatcher: Dispatcher) -> None:
        self.dispatcher = dispatcher
        self._feed_update_tasks = set()

    async def startup(self) -> None:
        await self.dispatcher.emit_startup(**self.dispatcher.workflow_data)
        logger.info("Dispatcher startup events emitted")

    async def shutdown(self) -> None:
        await self.dispatcher.emit_shutdown(**self.dispatcher.workflow_data)

        if self._feed_update_tasks:
            for task in self._feed_update_tasks:
                task.cancel()
            await asyncio.gather(*self._feed_update_tasks, return_exceptions=True)

        logger.info(
            f"Dispatcher shutdown complete and '{len(self._feed_update_tasks)}' tasks cleaned up"
        )

    def register(self, app: FastAPI, path: str, keyed_path: str | None = None) -> None:
        app.add_api_route(path, endpoint=self._handle_primary_request, methods=["POST"])

        if keyed_path:
            app.add_api_route(keyed_path, endpoint=self._handle_keyed_request, methods=["POST"])

    def _verify_secret(self, provided_secret_token: str, expected_secret_token: str) -> bool:
        return secrets.compare_digest(provided_secret_token, expected_secret_token)

    async def _feed_update(self, bot: Bot, update: Update) -> None:
        try:
            result = await self.dispatcher.feed_update(bot, update)
            if isinstance(result, TelegramMethod):
                await result.as_(bot)
        except Exception as e:
            logger.exception(f"Failed to process update '{update.update_id}' due to error '{e}'")

    async def _process_request(
        self,
        update: Update,
        bot: Bot,
        expected_secret_token: str,
        request_secret_token: str,
    ) -> Response:
        if not request_secret_token:
            logger.warning(f"Missing secret token header for update '{update.update_id}'")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED, detail="Token header is missing"
            )

        if not self._verify_secret(request_secret_token, expected_secret_token):
            logger.warning(f"Invalid secret token provided for update '{update.update_id}'")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid secret token"
            )

        task = asyncio.create_task(self._feed_update(bot, update))
        self._feed_update_tasks.add(task)
        task.add_done_callback(self._feed_update_tasks.discard)

        logger.debug(f"Update '{update.update_id}' scheduled for processing")
        return Response(status_code=status.HTTP_200_OK)

    @inject
    async def _handle_primary_request(
        self,
        update: Annotated[Update, Body()],
        config: FromDishka[AppConfig],
        bot_registry: FromDishka[BotRegistry],
        x_telegram_bot_api_secret_token: Annotated[str, Header()] = "",
    ) -> Response:
        bot_instance = config.primary_bot_instance
        bot = bot_registry.get(bot_instance.key)

        return await self._process_request(
            update=update,
            bot=bot,
            expected_secret_token=bot_instance.secret_token.get_secret_value(),
            request_secret_token=x_telegram_bot_api_secret_token,
        )

    @inject
    async def _handle_keyed_request(
        self,
        bot_key: str,
        update: Annotated[Update, Body()],
        config: FromDishka[AppConfig],
        bot_registry: FromDishka[BotRegistry],
        x_telegram_bot_api_secret_token: Annotated[str, Header()] = "",
    ) -> Response:
        bot_instance = config.get_bot_instance(bot_key)
        if bot_instance is None:
            logger.warning(f"Webhook received for unknown bot key '{bot_key}'")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Bot not found",
            )

        bot = bot_registry.get(bot_instance.key)

        return await self._process_request(
            update=update,
            bot=bot,
            expected_secret_token=bot_instance.secret_token.get_secret_value(),
            request_secret_token=x_telegram_bot_api_secret_token,
        )
