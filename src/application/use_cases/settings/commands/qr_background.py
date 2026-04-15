from loguru import logger

from src.application.common import Interactor, Notifier
from src.application.common.dao import SettingsDao
from src.application.common.policy import Permission
from src.application.common.uow import UnitOfWork
from src.application.dto import UserDto
from src.core.utils.validators import is_valid_url


class ToggleQrBackground(Interactor[None, bool]):
    required_permission = Permission.SETTINGS_MENU

    def __init__(self, uow: UnitOfWork, settings_dao: SettingsDao) -> None:
        self.uow = uow
        self.settings_dao = settings_dao

    async def _execute(self, actor: UserDto, data: None) -> bool:
        async with self.uow:
            settings = await self.settings_dao.get()
            old_state = settings.menu.qr_background.enabled
            settings.menu.qr_background.enabled = not old_state
            await self.settings_dao.update(settings)
            await self.uow.commit()

        logger.info(
            f"{actor.log} Toggled QR background from '{old_state}' "
            f"to '{settings.menu.qr_background.enabled}'"
        )
        return settings.menu.qr_background.enabled


class UpdateQrBackgroundUrl(Interactor[str, bool]):
    required_permission = Permission.SETTINGS_MENU

    def __init__(self, uow: UnitOfWork, settings_dao: SettingsDao, notifier: Notifier) -> None:
        self.uow = uow
        self.settings_dao = settings_dao
        self.notifier = notifier

    async def _execute(self, actor: UserDto, input_text: str) -> bool:
        value = input_text.strip()
        settings = await self.settings_dao.get()

        if value.lower() in {"/clear", "clear", "none", "-"}:
            settings.menu.qr_background.image_url = None
            settings.menu.qr_background.enabled = False

            async with self.uow:
                await self.settings_dao.update(settings)
                await self.uow.commit()

            logger.info(f"{actor.log} Cleared QR background URL")
            await self.notifier.notify_user(actor, i18n_key="ntf-common.value-updated")
            return True

        if not is_valid_url(value):
            logger.warning(f"{actor.log} Provided invalid QR background URL: '{value}'")
            await self.notifier.notify_user(actor, i18n_key="ntf-common.invalid-value")
            return False

        settings.menu.qr_background.image_url = value

        async with self.uow:
            await self.settings_dao.update(settings)
            await self.uow.commit()

        logger.info(f"{actor.log} Updated QR background URL")
        await self.notifier.notify_user(actor, i18n_key="ntf-common.value-updated")
        return True
