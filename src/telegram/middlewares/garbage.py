from typing import Any, Awaitable, Callable, cast

from aiogram.types import Message, TelegramObject
from loguru import logger

from src.application.dto import UserDto
from src.core.constants import USER_KEY
from src.core.enums import MiddlewareEventType

from .base import EventTypedMiddleware


class GarbageMiddleware(EventTypedMiddleware):
    __event_types__ = [MiddlewareEventType.MESSAGE]

    async def middleware_logic(
        self,
        handler: Callable[[TelegramObject, dict[str, Any]], Awaitable[Any]],
        event: TelegramObject,
        data: dict[str, Any],
    ) -> Any:
        message = cast(Message, event)
        user: UserDto = data[USER_KEY]

        logger.debug(
            f"Message '{message.content_type}' kept from '{user.telegram_id}'"
        )

        return await handler(event, data)
