import functools
import hashlib
from pathlib import Path
from typing import Any, Optional
from urllib.parse import urlparse

from aiogram.types import ContentType
from aiogram_dialog import DialogManager
from aiogram_dialog.api.entities import MediaAttachment
from aiogram_dialog.widgets.common import Whenable
from aiogram_dialog.widgets.media import StaticMedia
from dishka import AsyncContainer
from httpx import AsyncClient, Timeout
from loguru import logger

from src.application.common.dao import SettingsDao
from src.application.dto import UserDto
from src.core.config import AppConfig
from src.core.constants import CONFIG_KEY, CONTAINER_KEY, LOG_DIR, USER_KEY
from src.core.enums import BannerFormat, BannerName, Locale


@functools.lru_cache(maxsize=None)
def get_banner(
    banners_dir: Path,
    name: BannerName,
    locale: Locale,
    default_locale: Locale,
) -> tuple[Path, ContentType]:
    search_targets = [
        (banners_dir / locale, name),
        (banners_dir / locale, BannerName.DEFAULT),
        (banners_dir / default_locale, name),
        (banners_dir / default_locale, BannerName.DEFAULT),
        (banners_dir, BannerName.DEFAULT),
    ]

    for directory, banner_name in search_targets:
        if not directory.exists():
            continue

        for banner_format in BannerFormat:
            candidate = directory / f"{banner_name}.{banner_format}"
            if candidate.exists():
                logger.debug(f"Banner '{banner_name}' found at '{candidate}'")
                return candidate, banner_format.content_type

    logger.error(f"Banner '{name}' not found in any location including global default")
    raise FileNotFoundError(f"Banner '{name}' or global default not found")


class Banner(StaticMedia):
    def __init__(self, name: BannerName) -> None:
        self.banner_name = name
        super().__init__(path="path", url=None, type=ContentType.UNKNOWN, when=self._is_use_banners)

    def _is_use_banners(
        self,
        data: dict[str, Any],
        widget: Whenable,
        dialog_manager: DialogManager,
    ) -> bool:
        config: AppConfig = dialog_manager.middleware_data[CONFIG_KEY]
        return config.bot.use_banners

    def _content_type_from_path(self, path: Path) -> ContentType:
        suffix = path.suffix.lower().removeprefix(".")

        if suffix == BannerFormat.GIF:
            return ContentType.ANIMATION

        return ContentType.PHOTO

    def _suffix_from_content_type(self, content_type: str) -> str:
        normalized = content_type.lower().split(";")[0].strip()
        mapping = {
            "image/jpeg": ".jpg",
            "image/jpg": ".jpg",
            "image/png": ".png",
            "image/gif": ".gif",
            "image/webp": ".webp",
        }
        return mapping.get(normalized, ".jpg")

    async def _get_or_create_url_banner(self, image_url: str) -> Optional[Path]:
        cache_dir = LOG_DIR / "banner_override_cache"
        cache_dir.mkdir(parents=True, exist_ok=True)

        parsed = urlparse(image_url)
        suffix = Path(parsed.path).suffix.lower()
        if suffix not in {".jpg", ".jpeg", ".png", ".gif", ".webp"}:
            suffix = ""

        cache_key = hashlib.sha256(image_url.encode("utf-8")).hexdigest()
        if suffix:
            cached_path = cache_dir / f"{cache_key}{suffix}"
            if cached_path.exists():
                return cached_path
        else:
            existing = sorted(cache_dir.glob(f"{cache_key}.*"))
            if existing:
                return existing[0]

        timeout = Timeout(connect=5.0, read=15.0, write=5.0, pool=5.0)

        try:
            async with AsyncClient(timeout=timeout, follow_redirects=True) as client:
                response = await client.get(image_url)
                response.raise_for_status()

            if not suffix:
                suffix = self._suffix_from_content_type(response.headers.get("content-type", ""))

            cached_path = cache_dir / f"{cache_key}{suffix}"
            cached_path.write_bytes(response.content)
            return cached_path

        except Exception as e:
            logger.warning(f"Failed to fetch global banner from '{image_url}': {e}")
            return None

    async def _resolve_global_override(
        self,
        container: AsyncContainer,
    ) -> Optional[tuple[Path, ContentType]]:
        settings_dao = await container.get(SettingsDao)
        settings = await settings_dao.get()
        global_banner = settings.menu.global_banner

        if not global_banner.enabled:
            return None

        if global_banner.image_path:
            path = Path(global_banner.image_path)

            if path.exists():
                return path, self._content_type_from_path(path)

            logger.warning(f"Global banner file not found: '{path}'")

        if global_banner.image_url:
            path = await self._get_or_create_url_banner(global_banner.image_url)

            if path and path.exists():
                return path, self._content_type_from_path(path)

        return None

    async def _render_media(self, data: dict, manager: DialogManager) -> Optional[MediaAttachment]:
        user: UserDto = manager.middleware_data[USER_KEY]
        config: AppConfig = manager.middleware_data[CONFIG_KEY]

        container = manager.middleware_data.get(CONTAINER_KEY)
        if isinstance(container, AsyncContainer):
            try:
                override = await self._resolve_global_override(container)
                if override:
                    path, content_type = override
                    return MediaAttachment(
                        type=content_type,
                        path=path,
                        use_pipe=self.use_pipe,
                        **self.media_params,
                    )
            except Exception as e:
                logger.warning(f"Failed to resolve global banner override: {e}")

        try:
            banner_path, banner_content_type = get_banner(
                banners_dir=config.banners_dir,
                name=self.banner_name,
                locale=user.language,
                default_locale=config.default_locale,
            )
        except FileNotFoundError:
            logger.critical(f"Failed to render banner '{self.banner_name}' because file is missing")
            return None

        return MediaAttachment(
            type=banner_content_type,
            path=banner_path,
            use_pipe=self.use_pipe,
            **self.media_params,
        )
