from collections.abc import AsyncIterable

from aiogram import Bot
from dishka import Provider, Scope, provide

from src.core.config import AppConfig
from src.infrastructure.services import BotRegistry


class BotProvider(Provider):
    scope = Scope.APP

    @provide
    async def get_bot_registry(self, config: AppConfig) -> AsyncIterable[BotRegistry]:
        registry = BotRegistry(config)
        await registry.startup()
        yield registry
        await registry.shutdown()

    @provide
    def get_bot(self, bot_registry: BotRegistry) -> Bot:
        return bot_registry.primary_bot
