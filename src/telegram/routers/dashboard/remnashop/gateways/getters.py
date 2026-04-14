from typing import Any

from aiogram_dialog import DialogManager
from dishka import FromDishka
from dishka.integrations.aiogram_dialog import inject

from src.application.common.dao import PaymentGatewayDao, SettingsDao
from src.application.dto import PaymentGatewayDto
from src.core.config import AppConfig
from src.core.enums import Currency


def _get_enabled_currencies(currencies: list[Currency]) -> list[Currency]:
    unique: list[Currency] = []
    for currency in currencies:
        if currency not in unique:
            unique.append(currency)

    ordered = [currency for currency in Currency if currency in unique]
    return ordered or [Currency.XTR]


@inject
async def gateways_getter(
    dialog_manager: DialogManager,
    payment_gateway_dao: FromDishka[PaymentGatewayDao],
    **kwargs: Any,
) -> dict[str, Any]:
    gateways: list[PaymentGatewayDto] = await payment_gateway_dao.get_all(sorted=False)

    formatted_gateways = [
        {
            "id": gateway.id,
            "gateway_type": gateway.type,
            "is_active": gateway.is_active,
        }
        for gateway in gateways
    ]

    return {
        "gateways": formatted_gateways,
    }


@inject
async def gateway_getter(
    dialog_manager: DialogManager,
    config: AppConfig,
    payment_gateway_dao: FromDishka[PaymentGatewayDao],
    **kwargs: Any,
) -> dict[str, Any]:
    gateway_id = dialog_manager.dialog_data["gateway_id"]
    gateway = await payment_gateway_dao.get_by_id(gateway_id)

    if not gateway:
        raise ValueError(f"Gateway '{gateway_id}' not found")

    if not gateway.settings:
        raise ValueError(f"Gateway '{gateway_id}' has not settings")

    return {
        "id": gateway.id,
        "gateway_type": gateway.type,
        "is_active": gateway.is_active,
        "settings": gateway.settings.as_list,
        "webhook": config.get_webhook(gateway.type),
        "requires_webhook": gateway.requires_webhook,
    }


@inject
async def field_getter(
    dialog_manager: DialogManager,
    payment_gateway_dao: FromDishka[PaymentGatewayDao],
    **kwargs: Any,
) -> dict[str, Any]:
    gateway_id = dialog_manager.dialog_data["gateway_id"]
    selected_field = dialog_manager.dialog_data["selected_field"]

    gateway = await payment_gateway_dao.get_by_id(gateway_id)

    if not gateway:
        raise ValueError(f"Gateway '{gateway_id}' not found")

    if not gateway.settings:
        raise ValueError(f"Gateway '{gateway_id}' has not settings")

    return {
        "gateway_type": gateway.type,
        "field": selected_field,
    }


@inject
async def currency_getter(
    dialog_manager: DialogManager,
    settings_dao: FromDishka[SettingsDao],
    **kwargs: Any,
) -> dict[str, Any]:
    settings = await settings_dao.get()
    enabled_currencies = _get_enabled_currencies(settings.access.available_currencies)

    if settings.default_currency not in enabled_currencies:
        enabled_currencies = [settings.default_currency, *enabled_currencies]
        enabled_currencies = _get_enabled_currencies(enabled_currencies)

    return {
        "currency_list": [
            {
                "symbol": currency.symbol,
                "currency": currency.value,
                "enabled": currency == settings.default_currency,
            }
            for currency in enabled_currencies
        ]
    }


@inject
async def currency_manage_getter(
    dialog_manager: DialogManager,
    settings_dao: FromDishka[SettingsDao],
    **kwargs: Any,
) -> dict[str, Any]:
    settings = await settings_dao.get()
    enabled_currencies = _get_enabled_currencies(settings.access.available_currencies)

    return {
        "currency_list": [
            {
                "symbol": currency.symbol,
                "currency": currency.value,
                "enabled": currency in enabled_currencies,
            }
            for currency in Currency
        ]
    }


@inject
async def placement_getter(
    dialog_manager: DialogManager,
    payment_gateway_dao: FromDishka[PaymentGatewayDao],
    **kwargs: Any,
) -> dict[str, Any]:
    gateways: list[PaymentGatewayDto] = await payment_gateway_dao.get_all()

    formatted_gateways = [
        {
            "id": gateway.id,
            "gateway_type": gateway.type,
            "is_active": gateway.is_active,
        }
        for gateway in gateways
    ]

    return {
        "gateways": formatted_gateways,
    }
