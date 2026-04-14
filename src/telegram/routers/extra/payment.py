from uuid import UUID

from aiogram import Bot, F, Router
from aiogram.types import CallbackQuery, Message, PreCheckoutQuery
from dishka import FromDishka
from loguru import logger

from src.application.common import Notifier
from src.application.common.dao import TransactionDao, UserDao
from src.application.dto import UserDto
from src.application.use_cases.gateways.commands.payment import ProcessPayment, ProcessPaymentDto
from src.core.enums import TransactionStatus
from src.telegram.keyboards import (
    MANUAL_PAYMENT_APPROVE_ACTION,
    MANUAL_PAYMENT_CALLBACK_PREFIX,
    MANUAL_PAYMENT_REJECT_ACTION,
)

router = Router(name=__name__)


def _parse_manual_payment_callback(data: str) -> tuple[str, UUID]:
    prefix, action, raw_payment_id = data.split(":", 2)

    if prefix != MANUAL_PAYMENT_CALLBACK_PREFIX:
        raise ValueError("Invalid manual payment callback prefix")

    if action not in {MANUAL_PAYMENT_APPROVE_ACTION, MANUAL_PAYMENT_REJECT_ACTION}:
        raise ValueError("Invalid manual payment callback action")

    return action, UUID(raw_payment_id)


@router.pre_checkout_query()
async def on_pre_checkout(pre_checkout_query: PreCheckoutQuery, user: UserDto) -> None:
    logger.info(f"{user.log} Initiated a pre-checkout query")
    if pre_checkout_query.invoice_payload:
        await pre_checkout_query.answer(ok=True)
    else:
        logger.warning(f"{user.log} Pre-checkout query rejected: empty payload")
        await pre_checkout_query.answer(ok=False)


@router.message(F.successful_payment)
async def on_successful_payment(
    message: Message,
    user: UserDto,
    bot: Bot,
    process_payment: FromDishka[ProcessPayment],
) -> None:
    payment = message.successful_payment

    if not payment:
        return

    if user.is_owner:
        logger.info(f"{user.log} Refunding test payment '{payment.telegram_payment_charge_id}'")
        await bot.refund_star_payment(
            user_id=user.telegram_id,
            telegram_payment_charge_id=payment.telegram_payment_charge_id,
        )
    await process_payment.system(
        ProcessPaymentDto(
            payment_id=UUID(payment.invoice_payload),
            new_transaction_status=TransactionStatus.COMPLETED,
        )
    )


@router.callback_query(F.data.startswith(f"{MANUAL_PAYMENT_CALLBACK_PREFIX}:"))
async def on_manual_payment_moderation(
    callback: CallbackQuery,
    user: UserDto,
    process_payment: FromDishka[ProcessPayment],
    transaction_dao: FromDishka[TransactionDao],
    user_dao: FromDishka[UserDao],
    notifier: FromDishka[Notifier],
) -> None:
    if not user.is_privileged:
        await callback.answer("Access denied.", show_alert=True)
        return

    if not callback.data:
        await callback.answer("Invalid callback data.", show_alert=True)
        return

    try:
        action, payment_id = _parse_manual_payment_callback(callback.data)
    except ValueError:
        await callback.answer("Invalid callback data.", show_alert=True)
        return

    transaction = await transaction_dao.get_by_payment_id(payment_id)

    if not transaction:
        await callback.answer("Payment not found.", show_alert=True)
        return

    if transaction.status != TransactionStatus.PENDING:
        await callback.answer("Payment already processed.", show_alert=True)
        return

    if action == MANUAL_PAYMENT_APPROVE_ACTION:
        await process_payment.system(
            ProcessPaymentDto(
                payment_id=payment_id,
                new_transaction_status=TransactionStatus.COMPLETED,
            )
        )
        await callback.answer("Payment approved.")

    elif action == MANUAL_PAYMENT_REJECT_ACTION:
        await process_payment.system(
            ProcessPaymentDto(
                payment_id=payment_id,
                new_transaction_status=TransactionStatus.CANCELED,
            )
        )

        target_user = await user_dao.get_by_telegram_id(transaction.user_telegram_id)
        if target_user:
            await notifier.notify_user(user=target_user, i18n_key="ntf-subscription.manual-rejected")

        await callback.answer("Payment rejected.")

    if callback.message:
        await callback.message.edit_reply_markup(reply_markup=None)
