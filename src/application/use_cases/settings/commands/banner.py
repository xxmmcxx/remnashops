from loguru import logger

from src.application.common import Interactor, Notifier
from src.application.common.dao import SettingsDao
from src.application.common.policy import Permission
from src.application.common.uow import UnitOfWork
from src.application.dto import UserDto
from src.core.utils.validators import is_valid_url


class ToggleGlobalBanner(Interactor[None, bool]):
    required_permission = Permission.SETTINGS_MENU

    def __init__(self, uow: UnitOfWork, settings_dao: SettingsDao) -> None:
        self.uow = uow
        self.settings_dao = settings_dao

    async def _execute(self, actor: UserDto, data: None) -> bool:
        async with self.uow:
            settings = await self.settings_dao.get()
            old_state = settings.menu.global_banner.enabled
            settings.menu.global_banner.enabled = not old_state
            await self.settings_dao.update(settings)
            await self.uow.commit()

        logger.info(
            f"{actor.log} Toggled global banner from '{old_state}' "
            f"to '{settings.menu.global_banner.enabled}'"
        )
        return settings.menu.global_banner.enabled


class UpdateGlobalBannerUrl(Interactor[str, bool]):
    required_permission = Permission.SETTINGS_MENU

    def __init__(self, uow: UnitOfWork, settings_dao: SettingsDao, notifier: Notifier) -> None:
        self.uow = uow
        self.settings_dao = settings_dao
        self.notifier = notifier

    async def _execute(self, actor: UserDto, input_text: str) -> bool:
        value = input_text.strip()
        settings = await self.settings_dao.get()

        if not is_valid_url(value):
            logger.warning(f"{actor.log} Provided invalid global banner URL: '{value}'")
            await self.notifier.notify_user(actor, i18n_key="ntf-common.invalid-value")
            return False

        settings.menu.global_banner.image_url = value
        settings.menu.global_banner.image_path = None

        async with self.uow:
            await self.settings_dao.update(settings)
            await self.uow.commit()

        logger.info(f"{actor.log} Updated global banner URL")
        await self.notifier.notify_user(actor, i18n_key="ntf-common.value-updated")
        return True


class SetGlobalBannerImagePath(Interactor[str, None]):
    required_permission = Permission.SETTINGS_MENU

    def __init__(self, uow: UnitOfWork, settings_dao: SettingsDao) -> None:
        self.uow = uow
        self.settings_dao = settings_dao

    async def _execute(self, actor: UserDto, image_path: str) -> None:
        async with self.uow:
            settings = await self.settings_dao.get()
            settings.menu.global_banner.image_path = image_path
            settings.menu.global_banner.image_url = None
            await self.settings_dao.update(settings)
            await self.uow.commit()

        logger.info(f"{actor.log} Updated global banner image path to '{image_path}'")


class ResetGlobalBanner(Interactor[None, None]):
    required_permission = Permission.SETTINGS_MENU

    def __init__(self, uow: UnitOfWork, settings_dao: SettingsDao) -> None:
        self.uow = uow
        self.settings_dao = settings_dao

    async def _execute(self, actor: UserDto, data: None) -> None:
        async with self.uow:
            settings = await self.settings_dao.get()
            settings.menu.global_banner.enabled = False
            settings.menu.global_banner.image_url = None
            settings.menu.global_banner.image_path = None
            await self.settings_dao.update(settings)
            await self.uow.commit()

        logger.info(f"{actor.log} Reset global banner settings")
