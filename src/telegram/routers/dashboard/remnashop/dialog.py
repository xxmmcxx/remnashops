from aiogram_dialog import Dialog, StartMode, Window
from aiogram_dialog.widgets.input import MessageInput
from aiogram_dialog.widgets.kbd import Button, ListGroup, Row, Start, SwitchTo
from aiogram_dialog.widgets.text import Format
from magic_filter import F

from src.application.common.policy import Permission
from src.core.enums import BannerName
from src.telegram.keyboards import main_menu_button
from src.telegram.routers.extra.test import show_dev_popup
from src.telegram.states import (
    Dashboard,
    DashboardRemnashop,
    RemnashopGateways,
    RemnashopMenuEditor,
    RemnashopNotifications,
    RemnashopPlans,
    RemnashopReferral,
)
from src.telegram.utils import require_permission
from src.telegram.widgets import Banner, I18nFormat, IgnoreUpdate

from .getters import admins_getter, global_banner_getter, qr_background_getter, remnashop_getter
from .handlers import (
    on_admin_add_input,
    on_global_banner_input,
    on_global_banner_reset,
    on_global_banner_toggle,
    on_logs_request,
    on_qr_background_input,
    on_qr_background_reset,
    on_qr_background_toggle,
    on_role_revoke,
    on_user_select,
)

remnashop = Window(
    Banner(BannerName.DASHBOARD),
    I18nFormat("msg-remnashop-main"),
    Row(
        SwitchTo(
            text=I18nFormat("btn-remnashop.admins"),
            id="admins",
            state=DashboardRemnashop.ADMINS,
            when=require_permission(Permission.VIEW_ADMINS),
        ),
    ),
    Row(
        Start(
            text=I18nFormat("btn-remnashop.gateways"),
            id="gateways",
            state=RemnashopGateways.MAIN,
            when=require_permission(Permission.VIEW_GATEWAYS),
        ),
    ),
    Row(
        Start(
            text=I18nFormat("btn-remnashop.referral"),
            id="referral",
            state=RemnashopReferral.MAIN,
            when=require_permission(Permission.VIEW_REFERRAL),
        ),
        Button(
            text=I18nFormat("btn-remnashop.advertising"),
            id="advertising",
            # state=DashboardRemnashop.ADVERTISING,
            on_click=show_dev_popup,
            when=require_permission(Permission.VIEW_ADVERTISING),
        ),
    ),
    Row(
        Start(
            text=I18nFormat("btn-remnashop.plans"),
            id="plans",
            state=RemnashopPlans.MAIN,
            mode=StartMode.RESET_STACK,
            when=require_permission(Permission.VIEW_PLANS),
        ),
        Start(
            text=I18nFormat("btn-remnashop.notifications"),
            id="notifications",
            state=RemnashopNotifications.MAIN,
            when=require_permission(Permission.VIEW_NOTIFICATIONS),
        ),
    ),
    Row(
        Button(
            text=I18nFormat("btn-remnashop.logs"),
            id="logs",
            on_click=on_logs_request,
            when=require_permission(Permission.VIEW_LOGS),
        ),
        Start(
            text=I18nFormat("btn-remnashop.menu-editor"),
            id="menu_editor",
            state=RemnashopMenuEditor.MAIN,
            when=require_permission(Permission.VIEW_MENU_EDITOR),
        ),
    ),
    Row(
        SwitchTo(
            text=I18nFormat("btn-remnashop.banner"),
            id="banner",
            state=DashboardRemnashop.BANNER,
            when=require_permission(Permission.SETTINGS_MENU),
        ),
        SwitchTo(
            text=I18nFormat("btn-remnashop.qr-background"),
            id="qr_background",
            state=DashboardRemnashop.QR_BACKGROUND,
            when=require_permission(Permission.SETTINGS_MENU),
        ),
    ),
    Row(
        Start(
            text=I18nFormat("btn-back.general"),
            id="back",
            state=Dashboard.MAIN,
            mode=StartMode.RESET_STACK,
        ),
        *main_menu_button,
    ),
    IgnoreUpdate(),
    state=DashboardRemnashop.MAIN,
    getter=remnashop_getter,
)

admins = Window(
    Banner(BannerName.DASHBOARD),
    I18nFormat("msg-admins-main"),
    ListGroup(
        Row(
            Button(
                text=Format("{item[telegram_id]} ({item[name]})"),
                id="user_select",
                on_click=on_user_select,
            ),
            Button(
                text=Format("❌"),
                id="role_revoke",
                on_click=on_role_revoke,
                when=F["item"]["is_deletable"],
            ),
        ),
        id="admins_list",
        item_id_getter=lambda item: item["telegram_id"],
        items="admins",
    ),
    Row(
        Start(
            text=I18nFormat("btn-back.general"),
            id="back",
            state=DashboardRemnashop.MAIN,
            mode=StartMode.RESET_STACK,
        ),
    ),
    MessageInput(func=on_admin_add_input),
    IgnoreUpdate(),
    state=DashboardRemnashop.ADMINS,
    getter=admins_getter,
)

global_banner = Window(
    Banner(BannerName.DASHBOARD),
    I18nFormat(
        "msg-remnashop-global-banner",
        enabled=F["enabled"],
        image_url=F["image_url"],
        image_path=F["image_path"],
    ),
    Row(
        Button(
            text=I18nFormat("btn-global-banner.toggle", enabled=F["enabled"]),
            id="toggle",
            on_click=on_global_banner_toggle,
        ),
        Button(
            text=I18nFormat("btn-global-banner.reset"),
            id="reset",
            on_click=on_global_banner_reset,
            when=F["has_source"],
        ),
    ),
    Row(
        SwitchTo(
            text=I18nFormat("btn-back.general"),
            id="back",
            state=DashboardRemnashop.MAIN,
        ),
    ),
    MessageInput(func=on_global_banner_input),
    IgnoreUpdate(),
    state=DashboardRemnashop.BANNER,
    getter=global_banner_getter,
)

qr_background = Window(
    Banner(BannerName.DASHBOARD),
    I18nFormat(
        "msg-remnashop-qr-background",
        enabled=F["enabled"],
        image_url=F["image_url"],
    ),
    Row(
        Button(
            text=I18nFormat("btn-qr-background.toggle", enabled=F["enabled"]),
            id="toggle",
            on_click=on_qr_background_toggle,
        ),
        Button(
            text=I18nFormat("btn-qr-background.reset"),
            id="reset",
            on_click=on_qr_background_reset,
            when=F["has_url"],
        ),
    ),
    Row(
        SwitchTo(
            text=I18nFormat("btn-back.general"),
            id="back",
            state=DashboardRemnashop.MAIN,
        ),
    ),
    MessageInput(func=on_qr_background_input),
    IgnoreUpdate(),
    state=DashboardRemnashop.QR_BACKGROUND,
    getter=qr_background_getter,
)

router = Dialog(
    remnashop,
    admins,
    global_banner,
    qr_background,
)
