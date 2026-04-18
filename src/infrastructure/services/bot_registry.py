from aiogram import Bot
from aiogram.client.default import DefaultBotProperties
from aiogram.client.session.aiohttp import AiohttpSession
from aiogram.enums import ParseMode
from loguru import logger

from src.core.config import AppConfig
from src.core.config.bot import BotInstanceConfig


class BotRegistry:
    def __init__(self, config: AppConfig) -> None:
        self.config = config
        self._bots: dict[str, Bot] = {}
        self._ordered_keys: list[str] = []

    async def startup(self) -> None:
        if self._bots:
            return

        for instance in self.config.bot_instances:
            session = None
            if instance.proxy_url:
                logger.info(f"Using SOCKS5 proxy for bot '{instance.key}'")
                session = AiohttpSession(proxy=instance.proxy_url.get_secret_value())

            bot = Bot(
                token=instance.token.get_secret_value(),
                default=DefaultBotProperties(parse_mode=ParseMode.HTML),
                session=session,
            )

            self._bots[instance.key] = bot
            self._ordered_keys.append(instance.key)

        logger.info(f"Initialized '{len(self._bots)}' bot instance(s)")

    async def shutdown(self) -> None:
        if not self._bots:
            return

        for key in self._ordered_keys:
            bot = self._bots[key]
            await bot.session.close()
            logger.debug(f"Closed Bot session for '{key}'")

        self._bots.clear()
        self._ordered_keys.clear()

    def get(self, key: str) -> Bot:
        if key not in self._bots:
            raise KeyError(f"Bot with key '{key}' is not registered")
        return self._bots[key]

    @property
    def primary_bot(self) -> Bot:
        if not self._ordered_keys:
            raise RuntimeError("BotRegistry is not initialized")
        return self._bots[self._ordered_keys[0]]

    def iter_bots(self) -> list[tuple[BotInstanceConfig, Bot]]:
        if not self._bots:
            raise RuntimeError("BotRegistry is not initialized")

        result: list[tuple[BotInstanceConfig, Bot]] = []
        for instance in self.config.bot_instances:
            result.append((instance, self._bots[instance.key]))

        return result
