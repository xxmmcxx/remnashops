from typing import Sequence, Union

from alembic import op

revision: str = "0022"
down_revision: Union[str, None] = "0021"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.execute("ALTER TYPE currency ADD VALUE IF NOT EXISTS 'TOMAN'")


def downgrade() -> None:
    op.execute("UPDATE payment_gateways SET currency = 'RUB' WHERE currency = 'TOMAN'")
    op.execute("UPDATE settings SET default_currency = 'RUB' WHERE default_currency = 'TOMAN'")
    op.execute("UPDATE plan_prices SET currency = 'RUB' WHERE currency = 'TOMAN'")
    op.execute("UPDATE transactions SET currency = 'RUB' WHERE currency = 'TOMAN'")

    op.execute("ALTER TABLE payment_gateways ALTER COLUMN currency TYPE text USING currency::text")
    op.execute("ALTER TABLE settings ALTER COLUMN default_currency TYPE text USING default_currency::text")
    op.execute("ALTER TABLE plan_prices ALTER COLUMN currency TYPE text USING currency::text")
    op.execute("ALTER TABLE transactions ALTER COLUMN currency TYPE text USING currency::text")

    op.execute("CREATE TYPE currency_new AS ENUM ('USD', 'XTR', 'RUB')")

    op.execute("""
        ALTER TABLE payment_gateways
        ALTER COLUMN currency TYPE currency_new
        USING currency::text::currency_new
    """)

    op.execute("""
        ALTER TABLE settings
        ALTER COLUMN default_currency TYPE currency_new
        USING default_currency::text::currency_new
    """)

    op.execute("""
        ALTER TABLE plan_prices
        ALTER COLUMN currency TYPE currency_new
        USING currency::text::currency_new
    """)

    op.execute("""
        ALTER TABLE transactions
        ALTER COLUMN currency TYPE currency_new
        USING currency::text::currency_new
    """)

    op.execute("DROP TYPE currency")
    op.execute("ALTER TYPE currency_new RENAME TO currency")
