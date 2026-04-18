from datetime import datetime, timedelta

from aiogram import Bot
from aiogram.methods import SetWebhook
from aiogram.types import WebhookInfo
from loguru import logger

from src.application.common import Cryptographer
from src.application.common.dao import WebhookDao
from src.core.config import AppConfig
from src.core.utils.time import datetime_now


class WebhookService:
    def __init__(
        self,
        webhook_dao: WebhookDao,
        bot: Bot,
        config: AppConfig,
        cryptographer: Cryptographer,
    ) -> None:
        self.webhook_dao = webhook_dao
        self.bot = bot
        self.config = config
        self.cryptographer = cryptographer

    async def setup_webhook(self, allowed_updates: list[str]) -> WebhookInfo:
        return await self.setup_webhook_for_bot(allowed_updates=allowed_updates)

    async def setup_webhook_for_bot(
        self,
        allowed_updates: list[str],
        bot: Bot | None = None,
        webhook_path: str | None = None,
        secret_token: str | None = None,
        drop_pending_updates: bool | None = None,
        reset_webhook: bool | None = None,
    ) -> WebhookInfo:
        target_bot = bot or self.bot
        target_webhook_path = webhook_path or self.config.bot.webhook_path
        target_secret_token = secret_token or self.config.bot.secret_token.get_secret_value()
        target_drop_pending_updates = (
            self.config.bot.drop_pending_updates
            if drop_pending_updates is None
            else drop_pending_updates
        )
        target_reset_webhook = self.config.bot.reset_webhook if reset_webhook is None else reset_webhook

        safe_url = f"https://{self.config.domain}{target_webhook_path}"
        webhook_url = f"https://{self.config.domain.get_secret_value()}{target_webhook_path}"

        webhook_request = SetWebhook(
            url=webhook_url,
            allowed_updates=allowed_updates,
            drop_pending_updates=target_drop_pending_updates,
            secret_token=target_secret_token,
        )

        webhook_hash = self.cryptographer.get_hash(webhook_request.model_dump(exclude_unset=True))

        if await self.webhook_dao.is_hash_exists(target_bot.id, webhook_hash):
            if not target_reset_webhook:
                logger.info(f"Webhook setup skipped for bot '{target_bot.id}', hash matches")
                return await target_bot.get_webhook_info()

        if not await target_bot(webhook_request):
            logger.error(f"Failed to set webhook for bot '{target_bot.id}' on URL '{safe_url}'")
            raise RuntimeError(f"Could not set webhook for bot '{target_bot.id}'")

        await self.webhook_dao.clear_all_hashes(target_bot.id)
        await self.webhook_dao.save_hash(target_bot.id, webhook_hash)

        logger.info(f"Webhook set successfully for bot '{target_bot.id}' to URL '{safe_url}'")
        return await target_bot.get_webhook_info()

    async def delete_webhook(self) -> None:
        await self.delete_webhook_for_bot()

    async def delete_webhook_for_bot(
        self,
        bot: Bot | None = None,
        reset_webhook: bool | None = None,
    ) -> None:
        target_bot = bot or self.bot
        target_reset_webhook = self.config.bot.reset_webhook if reset_webhook is None else reset_webhook

        if not target_reset_webhook:
            logger.debug(f"Webhook reset disabled in config for bot '{target_bot.id}'")
            return

        if await target_bot.delete_webhook():
            await self.webhook_dao.clear_all_hashes(target_bot.id)
            logger.info(f"Webhook deleted successfully for bot '{target_bot.id}'")
        else:
            logger.error(f"Failed to delete webhook for bot '{target_bot.id}'")

    def has_error(self, webhook_info: WebhookInfo, bot: Bot | None = None) -> bool:
        target_bot = bot or self.bot

        if not webhook_info.last_error_message or webhook_info.last_error_date is None:
            return False

        is_new = self._is_new_error(error_time=webhook_info.last_error_date)
        if is_new:
            logger.warning(f"Recent webhook error detected for bot '{target_bot.id}'")

        return is_new

    def _is_new_error(self, error_time: datetime, tolerance: int = 1) -> bool:
        current_time = datetime_now()
        time_difference = current_time - error_time
        return time_difference <= timedelta(seconds=tolerance)
