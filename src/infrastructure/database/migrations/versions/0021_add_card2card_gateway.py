from typing import Sequence, Union

from alembic import op

revision: str = "0021"
down_revision: Union[str, None] = "0020"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.execute("ALTER TYPE payment_gateway_type ADD VALUE IF NOT EXISTS 'CARD2CARD'")


def downgrade() -> None:
    op.execute(
        "ALTER TABLE transactions ALTER COLUMN gateway_type TYPE text USING gateway_type::text"
    )
    op.execute("ALTER TABLE payment_gateways ALTER COLUMN type TYPE text USING type::text")

    op.execute("DELETE FROM transactions WHERE gateway_type = 'CARD2CARD'")
    op.execute("DELETE FROM payment_gateways WHERE type = 'CARD2CARD'")

    op.execute("""
        CREATE TYPE payment_gateway_type_new AS ENUM (
            'TELEGRAM_STARS',
            'YOOKASSA',
            'YOOMONEY',
            'CRYPTOMUS',
            'HELEKET',
            'CRYPTOPAY',
            'FREEKASSA',
            'MULENPAY',
            'PAYMASTER',
            'PLATEGA',
            'ROBOKASSA',
            'URLPAY',
            'WATA'
        )
    """)

    op.execute("""
        ALTER TABLE payment_gateways
        ALTER COLUMN type TYPE payment_gateway_type_new
        USING type::text::payment_gateway_type_new
    """)

    op.execute("""
        ALTER TABLE transactions
        ALTER COLUMN gateway_type TYPE payment_gateway_type_new
        USING gateway_type::text::payment_gateway_type_new
    """)

    op.execute("DROP TYPE payment_gateway_type")
    op.execute("ALTER TYPE payment_gateway_type_new RENAME TO payment_gateway_type")
