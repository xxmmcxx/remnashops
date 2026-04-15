import hashlib
from io import BytesIO
from pathlib import Path
from typing import Any, Optional, cast

from aiogram.types import ContentType
from aiogram_dialog import DialogManager
from aiogram_dialog.api.entities import MediaAttachment
from dishka import AsyncContainer
from httpx import AsyncClient, Timeout
from loguru import logger
from PIL import Image, ImageDraw
from qrcode import ERROR_CORRECT_H, QRCode  # type: ignore[attr-defined]

from src.application.common.dao import SettingsDao, SubscriptionDao
from src.application.dto import UserDto
from src.core.constants import ASSETS_DIR, CONTAINER_KEY, LOG_DIR, USER_KEY
from src.core.enums import BannerName

from .banner import Banner


def _generate_subscription_qr_png(url: str, background_path: Optional[Path] = None) -> bytes:
    qr: Any = QRCode(
        version=1,
        error_correction=ERROR_CORRECT_H,
        box_size=10,
        border=4,
    )

    qr.add_data(url)
    qr.make(fit=True)

    qr_img_raw = qr.make_image(fill_color="black", back_color="white")

    if hasattr(qr_img_raw, "get_image"):
        qr_img = cast(Image.Image, qr_img_raw.get_image())
    else:
        qr_img = cast(Image.Image, qr_img_raw)

    qr_img = qr_img.convert("RGB")

    logo_path = ASSETS_DIR / "logo.png"
    if logo_path.exists():
        with Image.open(logo_path) as logo_src:
            logo = logo_src.convert("RGBA")
            qr_width, qr_height = qr_img.size
            logo_size = int(qr_width * 0.2)
            logo = logo.resize((logo_size, logo_size), resample=Image.Resampling.LANCZOS)

            pos = ((qr_width - logo_size) // 2, (qr_height - logo_size) // 2)
            qr_img.paste(logo, pos, mask=logo)

    if background_path and background_path.exists():
        with Image.open(background_path) as bg_src:
            bg_img = bg_src.convert("RGB")

        crop_size = min(bg_img.width, bg_img.height)
        left = (bg_img.width - crop_size) // 2
        top = (bg_img.height - crop_size) // 2
        bg_img = bg_img.crop((left, top, left + crop_size, top + crop_size))
        bg_img = bg_img.resize((1200, 1200), resample=Image.Resampling.LANCZOS)

        panel_size = int(bg_img.width * 0.72)
        panel_radius = int(panel_size * 0.08)
        panel = Image.new("RGBA", (panel_size, panel_size), (255, 255, 255, 0))
        mask = Image.new("L", (panel_size, panel_size), 0)
        draw = ImageDraw.Draw(mask)
        draw.rounded_rectangle(
            [0, 0, panel_size - 1, panel_size - 1],
            radius=panel_radius,
            fill=245,
        )
        panel.putalpha(mask)

        composed = bg_img.convert("RGBA")
        panel_pos = ((bg_img.width - panel_size) // 2, (bg_img.height - panel_size) // 2)
        composed.alpha_composite(panel, panel_pos)

        qr_size = int(panel_size * 0.88)
        qr_img = qr_img.resize((qr_size, qr_size), resample=Image.Resampling.LANCZOS)
        qr_pos = ((bg_img.width - qr_size) // 2, (bg_img.height - qr_size) // 2)
        composed.alpha_composite(qr_img.convert("RGBA"), qr_pos)
        qr_img = composed.convert("RGB")

    buffer = BytesIO()
    qr_img.save(buffer, format="PNG")
    return buffer.getvalue()


class SubscriptionQrBanner(Banner):
    def __init__(self, fallback_name: BannerName = BannerName.SUBSCRIPTION) -> None:
        super().__init__(name=fallback_name)

    async def _render_media(
        self,
        data: dict[str, Any],
        manager: DialogManager,
    ) -> Optional[MediaAttachment]:
        user: UserDto = manager.middleware_data[USER_KEY]
        container: AsyncContainer = manager.middleware_data[CONTAINER_KEY]

        try:
            subscription_dao = await container.get(SubscriptionDao)
            settings_dao = await container.get(SettingsDao)
            subscription = await subscription_dao.get_current(user.telegram_id)
            settings = await settings_dao.get()

            if not subscription:
                logger.debug(
                    f"{user.log} No active subscription found for QR banner, using fallback banner"
                )
                return await super()._render_media(data, manager)

            qr_background = settings.menu.qr_background
            background_url = (
                qr_background.image_url
                if qr_background.enabled and qr_background.image_url
                else None
            )

            qr_path = await self._get_or_create_qr_path(
                container=container,
                subscription_url=subscription.url,
                background_url=background_url,
                user=user,
            )

            if qr_path is None:
                return await super()._render_media(data, manager)

            return MediaAttachment(
                type=ContentType.PHOTO,
                path=qr_path,
                use_pipe=self.use_pipe,
                **self.media_params,
            )

        except Exception as e:
            logger.warning(f"{user.log} Failed to render QR banner: {e}")
            return await super()._render_media(data, manager)

    async def _get_or_create_qr_path(
        self,
        container: AsyncContainer,
        subscription_url: str,
        background_url: Optional[str],
        user: UserDto,
    ) -> Optional[Path]:
        try:
            cache_dir = LOG_DIR / "qr_cache"
            cache_dir.mkdir(parents=True, exist_ok=True)

            cache_key = hashlib.sha256(
                f"{user.telegram_id}:{subscription_url}:{background_url or ''}".encode("utf-8")
            ).hexdigest()
            qr_path = cache_dir / f"{cache_key}.png"

            if qr_path.exists():
                return qr_path

            background_path = await self._get_or_create_background_path(background_url)

            qr_path.write_bytes(
                _generate_subscription_qr_png(subscription_url, background_path=background_path)
            )

            logger.info(f"{user.log} Generated subscription QR banner at '{qr_path}'")
            return qr_path

        except Exception as e:
            logger.warning(f"{user.log} Failed to build QR path: {e}")
            return None

    async def _get_or_create_background_path(self, background_url: Optional[str]) -> Optional[Path]:
        if not background_url:
            return None

        cache_dir = LOG_DIR / "qr_background_cache"
        cache_dir.mkdir(parents=True, exist_ok=True)

        cache_key = hashlib.sha256(background_url.encode("utf-8")).hexdigest()
        bg_path = cache_dir / f"{cache_key}.img"

        if bg_path.exists():
            return bg_path

        timeout = Timeout(connect=5.0, read=15.0, write=5.0, pool=5.0)

        try:
            async with AsyncClient(timeout=timeout, follow_redirects=True) as client:
                response = await client.get(background_url)
                response.raise_for_status()

            bg_path.write_bytes(response.content)
            return bg_path
        except Exception as e:
            logger.warning(f"Failed to load QR background image from '{background_url}': {e}")
            return None
