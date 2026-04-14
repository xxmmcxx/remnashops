from loguru import logger

from src.application.common import Interactor
from src.application.common.dao import PaymentGatewayDao, SettingsDao
from src.application.common.policy import Permission
from src.application.common.uow import UnitOfWork
from src.application.dto import UserDto
from src.core.enums import Currency, PaymentGatewayType


def _normalize_currencies(currencies: list[Currency]) -> list[Currency]:
    unique: list[Currency] = []
    for currency in currencies:
        if currency not in unique:
            unique.append(currency)
    return [currency for currency in Currency if currency in unique]


class UpdateDefaultCurrency(Interactor[Currency, None]):
    required_permission = Permission.SETTINGS_CURRENCY

    def __init__(
        self,
        uow: UnitOfWork,
        settings_dao: SettingsDao,
        payment_gateway_dao: PaymentGatewayDao,
    ) -> None:
        self.uow = uow
        self.settings_dao = settings_dao
        self.payment_gateway_dao = payment_gateway_dao

    async def _execute(self, actor: UserDto, currency: Currency) -> None:
        async with self.uow:
            settings = await self.settings_dao.get()
            old_currency = settings.default_currency
            available_currencies = _normalize_currencies(
                settings.access.available_currencies or list(Currency)
            )

            if currency not in available_currencies:
                raise ValueError(
                    f"Currency '{currency}' is disabled in settings and can't be set as default"
                )

            settings_updated = False
            if old_currency != currency:
                settings.default_currency = currency
                await self.settings_dao.update(settings)
                settings_updated = True

            gateways = await self.payment_gateway_dao.get_all()
            gateways_updated = False

            for gateway in gateways:
                # Telegram Stars is XTR-only and should keep its native currency.
                if gateway.type == PaymentGatewayType.TELEGRAM_STARS:
                    continue

                if gateway.currency == currency:
                    continue

                gateway.currency = currency
                await self.payment_gateway_dao.update(gateway)
                gateways_updated = True

            if settings_updated or gateways_updated:
                await self.uow.commit()
            else:
                logger.debug(f"Default currency and gateways already aligned to '{currency}'")
                return

        logger.info(f"{actor.log} Updated default currency from '{old_currency}' to '{currency}'")


class ToggleAvailableCurrency(Interactor[Currency, None]):
    required_permission = Permission.SETTINGS_CURRENCY

    def __init__(self, uow: UnitOfWork, settings_dao: SettingsDao) -> None:
        self.uow = uow
        self.settings_dao = settings_dao

    async def _execute(self, actor: UserDto, currency: Currency) -> None:
        async with self.uow:
            settings = await self.settings_dao.get()
            available_currencies = _normalize_currencies(
                settings.access.available_currencies or list(Currency)
            )

            if currency in available_currencies:
                if len(available_currencies) == 1:
                    raise ValueError("At least one enabled currency must remain")

                available_currencies = [c for c in available_currencies if c != currency]

                if settings.default_currency == currency:
                    settings.default_currency = available_currencies[0]

                action = "disabled"
            else:
                available_currencies.append(currency)
                available_currencies = _normalize_currencies(available_currencies)
                action = "enabled"

            settings.access.available_currencies = available_currencies
            await self.settings_dao.update(settings)
            await self.uow.commit()

        logger.info(f"{actor.log} Currency '{currency}' {action} in settings")
