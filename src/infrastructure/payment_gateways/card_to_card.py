import uuid
from decimal import Decimal
from uuid import UUID

from fastapi import Request

from src.application.dto import PaymentResultDto
from src.core.enums import TransactionStatus

from .base import BasePaymentGateway


class CardToCardGateway(BasePaymentGateway):
    async def handle_create_payment(self, amount: Decimal, details: str) -> PaymentResultDto:
        del amount, details
        return PaymentResultDto(id=uuid.uuid4(), url=None)

    async def handle_webhook(self, request: Request) -> tuple[UUID, TransactionStatus]:
        del request
        raise NotImplementedError()
