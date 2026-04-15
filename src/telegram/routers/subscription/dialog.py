from aiogram.enums import ButtonStyle
from aiogram_dialog import Dialog, Window
from aiogram_dialog.widgets.input import MessageInput
from aiogram_dialog.widgets.kbd import Button, Column, Group, Row, Select, SwitchTo, Url
from aiogram_dialog.widgets.style import Style
from aiogram_dialog.widgets.text import Format
from magic_filter import F

from src.core.constants import PAYMENT_PREFIX
from src.core.enums import BannerName, PaymentGatewayType, PurchaseType
from src.telegram.keyboards import back_main_menu_button, connect_buttons
from src.telegram.states import Subscription
from src.telegram.widgets import Banner, I18nFormat, IgnoreUpdate
from src.telegram.widgets.subscription_qr_banner import SubscriptionQrBanner

from .getters import (
    confirm_getter,
    duration_getter,
    getter_connect,
    payment_method_getter,
    plan_getter,
    plans_getter,
    subscription_getter,
    success_payment_getter,
)
from .handlers import (
    on_duration_select,
    on_get_subscription,
    on_manual_receipt_input,
    on_manual_receipt_start,
    on_payment_method_select,
    on_plan_select,
    on_send_raw_configs,
    on_subscription_plans,
)

subscription = Window(
    Banner(BannerName.SUBSCRIPTION),
    I18nFormat("msg-subscription-main"),
    Row(
        Button(
            text=I18nFormat("btn-subscription.new"),
            id=f"{PAYMENT_PREFIX}{PurchaseType.NEW}",
            on_click=on_subscription_plans,
        ),
        Button(
            text=I18nFormat("btn-subscription.renew"),
            id=f"{PAYMENT_PREFIX}{PurchaseType.RENEW}",
            on_click=on_subscription_plans,
            when=F["has_active_subscription"] & F["is_not_unlimited"],
        ),
        Button(
            text=I18nFormat("btn-subscription.change"),
            id=f"{PAYMENT_PREFIX}{PurchaseType.CHANGE}",
            on_click=on_subscription_plans,
            when=F["has_active_subscription"],
        ),
    ),
    # Row(
    #     Button(
    #         text=I18nFormat("btn-subscription.promocode"),
    #         id=f"{PAYMENT_PREFIX}promocode",
    #         on_click=show_dev_popup,
    #         # state=Subscription.PROMOCODE,
    #     ),
    # ),
    *back_main_menu_button,
    IgnoreUpdate(),
    state=Subscription.MAIN,
    getter=subscription_getter,
)

plan = Window(
    Banner(BannerName.SUBSCRIPTION),
    I18nFormat("msg-subscription-plan"),
    Column(
        Select(
            text=I18nFormat("btn-subscription.plan"),
            id=f"{PAYMENT_PREFIX}select_plan",
            item_id_getter=lambda item: item,
            items="plan_id",
            type_factory=int,
            on_click=on_plan_select,
        ),
    ),
    *back_main_menu_button,
    IgnoreUpdate(),
    state=Subscription.PLAN,
    getter=plan_getter,
)


plans = Window(
    Banner(BannerName.SUBSCRIPTION),
    I18nFormat("msg-subscription-plans"),
    Column(
        Select(
            text=Format("{item[name]}"),
            id=f"{PAYMENT_PREFIX}select_plan",
            item_id_getter=lambda item: item["id"],
            items="plans",
            type_factory=int,
            on_click=on_plan_select,
        ),
    ),
    Row(
        SwitchTo(
            text=I18nFormat("btn-back.general"),
            id=f"{PAYMENT_PREFIX}back",
            state=Subscription.MAIN,
        ),
    ),
    *back_main_menu_button,
    IgnoreUpdate(),
    state=Subscription.PLANS,
    getter=plans_getter,
)

duration = Window(
    Banner(BannerName.SUBSCRIPTION),
    I18nFormat("msg-subscription-duration"),
    Group(
        Select(
            text=I18nFormat(
                "btn-subscription.duration",
                period=F["item"]["period"],
                final_amount=F["item"]["final_amount"],
                discount_percent=F["item"]["discount_percent"],
                original_amount=F["item"]["original_amount"],
                currency=F["item"]["currency"],
            ),
            id=f"{PAYMENT_PREFIX}select_duration",
            item_id_getter=lambda item: item["days"],
            items="durations",
            type_factory=int,
            on_click=on_duration_select,
        ),
        width=2,
    ),
    Row(
        SwitchTo(
            text=I18nFormat("btn-subscription.back-plans"),
            id=f"{PAYMENT_PREFIX}back_plans",
            state=Subscription.PLANS,
            when=~F["only_single_plan"],
        ),
    ),
    *back_main_menu_button,
    IgnoreUpdate(),
    state=Subscription.DURATION,
    getter=duration_getter,
)

payment_method = Window(
    Banner(BannerName.SUBSCRIPTION),
    I18nFormat("msg-subscription-payment-method"),
    Column(
        Select(
            text=I18nFormat(
                "btn-subscription.payment-method",
                gateway_type=F["item"]["gateway_type"],
                final_amount=F["item"]["final_amount"],
                original_amount=F["item"]["original_amount"],
                discount_percent=F["item"]["discount_percent"],
                currency=F["item"]["currency"],
            ),
            id=f"{PAYMENT_PREFIX}select_payment_method",
            item_id_getter=lambda item: item["gateway_type"],
            items="payment_methods",
            type_factory=PaymentGatewayType,
            on_click=on_payment_method_select,
        ),
    ),
    Row(
        SwitchTo(
            text=I18nFormat("btn-subscription.back-duration"),
            id=f"{PAYMENT_PREFIX}back",
            state=Subscription.DURATION,
            when=~F["only_single_duration"],
        ),
    ),
    Row(
        SwitchTo(
            text=I18nFormat("btn-subscription.back-plans"),
            id=f"{PAYMENT_PREFIX}back_plans",
            state=Subscription.PLANS,
            when=~F["only_single_plan"],
        ),
    ),
    *back_main_menu_button,
    IgnoreUpdate(),
    state=Subscription.PAYMENT_METHOD,
    getter=payment_method_getter,
)

confirm = Window(
    Banner(BannerName.SUBSCRIPTION),
    I18nFormat("msg-subscription-confirm"),
    I18nFormat(
        "msg-subscription-manual-payment",
        manual_payment_description=F["manual_payment_description"],
        when=F["is_manual_payment"],
    ),
    Row(
        Url(
            text=I18nFormat("btn-subscription.pay"),
            url=Format("{url}"),
            when=F["url"],
            style=Style(ButtonStyle.SUCCESS),
        ),
        Button(
            text=I18nFormat("btn-subscription.get"),
            id=f"{PAYMENT_PREFIX}get",
            on_click=on_get_subscription,
            when=F["is_free"],
            style=Style(ButtonStyle.SUCCESS),
        ),
        Button(
            text=I18nFormat("btn-subscription.send-receipt"),
            id=f"{PAYMENT_PREFIX}manual_receipt",
            on_click=on_manual_receipt_start,
            when=F["is_manual_payment"] & ~F["is_free"],
            style=Style(ButtonStyle.SUCCESS),
        ),
    ),
    Row(
        SwitchTo(
            text=I18nFormat("btn-subscription.back-payment-method"),
            id=f"{PAYMENT_PREFIX}back_payment_method",
            state=Subscription.PAYMENT_METHOD,
            when=~F["only_single_gateway"] & ~F["is_free"],
        ),
        SwitchTo(
            text=I18nFormat("btn-subscription.back-duration"),
            id=f"{PAYMENT_PREFIX}back_duration",
            state=Subscription.DURATION,
            when=F["only_single_gateway"] & ~F["only_single_duration"] | F["is_free"],
        ),
    ),
    Row(
        SwitchTo(
            text=I18nFormat("btn-subscription.back-plans"),
            id=f"{PAYMENT_PREFIX}back_plans",
            state=Subscription.PLANS,
            when=~F["only_single_plan"],
        ),
    ),
    *back_main_menu_button,
    IgnoreUpdate(),
    state=Subscription.CONFIRM,
    getter=confirm_getter,
)

manual_receipt = Window(
    Banner(BannerName.SUBSCRIPTION),
    I18nFormat(
        "msg-subscription-manual-receipt",
        manual_payment_description=F["manual_payment_description"],
    ),
    Row(
        SwitchTo(
            text=I18nFormat("btn-back.general"),
            id=f"{PAYMENT_PREFIX}back_confirm",
            state=Subscription.CONFIRM,
        ),
    ),
    MessageInput(func=on_manual_receipt_input),
    IgnoreUpdate(),
    state=Subscription.MANUAL_RECEIPT,
    getter=confirm_getter,
)

success_payment = Window(
    SubscriptionQrBanner(),
    I18nFormat("msg-subscription-success"),
    I18nFormat(
        "msg-subscription-connection-url",
        subscription_url=F["subscription_url"],
    ),
    Row(
        *connect_buttons,
    ),
    Row(
        Button(
            text=I18nFormat("btn-subscription.raw-configs"),
            id="raw_configs",
            on_click=on_send_raw_configs,
            style=Style(ButtonStyle.PRIMARY),
        ),
    ),
    *back_main_menu_button,
    IgnoreUpdate(),
    state=Subscription.SUCCESS,
    getter=success_payment_getter,
)

success_trial = Window(
    SubscriptionQrBanner(),
    I18nFormat("msg-subscription-trial"),
    I18nFormat(
        "msg-subscription-connection-url",
        subscription_url=F["subscription_url"],
    ),
    Row(
        *connect_buttons,
    ),
    Row(
        Button(
            text=I18nFormat("btn-subscription.raw-configs"),
            id="raw_configs",
            on_click=on_send_raw_configs,
            style=Style(ButtonStyle.PRIMARY),
        ),
    ),
    *back_main_menu_button,
    IgnoreUpdate(),
    state=Subscription.TRIAL,
    getter=getter_connect,
)

failed = Window(
    Banner(BannerName.SUBSCRIPTION),
    I18nFormat("msg-subscription-failed"),
    *back_main_menu_button,
    IgnoreUpdate(),
    state=Subscription.FAILED,
)

router = Dialog(
    subscription,
    plan,
    plans,
    duration,
    payment_method,
    confirm,
    manual_receipt,
    success_payment,
    success_trial,
    failed,
)
