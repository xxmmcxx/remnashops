ALEMBIC_INI=src/infrastructure/database/alembic.ini
DATABASE_HOST ?= 0.0.0.0
DATABASE_PORT ?= 6767

LOCAL_DB_ENV := DATABASE_HOST=$(DATABASE_HOST) DATABASE_PORT=$(DATABASE_PORT)

RESET := $(filter reset,$(MAKECMDGOALS))

.PHONY: setup-env
setup-env:
	@sed -i '' "s|^APP_CRYPT_KEY=.*|APP_CRYPT_KEY=$(shell openssl rand -base64 32 | tr -d '\n')|" .env
	@sed -i '' "s|^BOT_SECRET_TOKEN=.*|BOT_SECRET_TOKEN=$(shell openssl rand -hex 64 | tr -d '\n')|" .env
	@sed -i '' "s|^DATABASE_PASSWORD=.*|DATABASE_PASSWORD=$(shell openssl rand -hex 24 | tr -d '\n')|" .env
	@sed -i '' "s|^REDIS_PASSWORD=.*|REDIS_PASSWORD=$(shell openssl rand -hex 24 | tr -d '\n')|" .env
	@echo "Secrets updated. Check your .env file"

# ── Run ────────────────────────────────────────────────────────────────────────

.PHONY: run
run: _run_local

.PHONY: run-local
run-local: _run_local

.PHONY: run-prod
run-prod: _run_prod

# ── Isolated Multi-Bot ───────────────────────────────────────────────────────

.PHONY: up-bot1
up-bot1:
	@STACK_ENV_FILE=.env.bot1 BUILDKIT_PROGRESS=plain docker compose -f docker-compose.local.yml --env-file .env.bot1 -p bot1 up --build -d

.PHONY: up-bot2
up-bot2:
	@STACK_ENV_FILE=.env.bot2 BUILDKIT_PROGRESS=plain docker compose -f docker-compose.local.yml --env-file .env.bot2 -p bot2 up --build -d

.PHONY: up-bots
up-bots: up-bot1 up-bot2

.PHONY: up-bot
up-bot:
	@test -n "$(BOT)" || (echo "Usage: make up-bot BOT=3" && exit 1)
	@STACK_ENV_FILE=.env.bot$(BOT) BUILDKIT_PROGRESS=plain docker compose -f docker-compose.local.yml --env-file .env.bot$(BOT) -p bot$(BOT) up --build -d

.PHONY: down-bot1
down-bot1:
	@STACK_ENV_FILE=.env.bot1 docker compose -f docker-compose.local.yml --env-file .env.bot1 -p bot1 down

.PHONY: down-bot2
down-bot2:
	@STACK_ENV_FILE=.env.bot2 docker compose -f docker-compose.local.yml --env-file .env.bot2 -p bot2 down

.PHONY: down-bots
down-bots: down-bot1 down-bot2

.PHONY: down-bot
down-bot:
	@test -n "$(BOT)" || (echo "Usage: make down-bot BOT=3" && exit 1)
	@STACK_ENV_FILE=.env.bot$(BOT) docker compose -f docker-compose.local.yml --env-file .env.bot$(BOT) -p bot$(BOT) down

.PHONY: logs-bot1
logs-bot1:
	@STACK_ENV_FILE=.env.bot1 docker compose -f docker-compose.local.yml --env-file .env.bot1 -p bot1 logs -f

.PHONY: logs-bot1-app
logs-bot1-app:
	@STACK_ENV_FILE=.env.bot1 docker compose -f docker-compose.local.yml --env-file .env.bot1 -p bot1 logs --tail=200 -f remnashop

.PHONY: logs-bot1-worker
logs-bot1-worker:
	@STACK_ENV_FILE=.env.bot1 docker compose -f docker-compose.local.yml --env-file .env.bot1 -p bot1 logs --tail=200 -f remnashop-taskiq-worker

.PHONY: logs-bot2
logs-bot2:
	@STACK_ENV_FILE=.env.bot2 docker compose -f docker-compose.local.yml --env-file .env.bot2 -p bot2 logs -f

.PHONY: logs-bot2-app
logs-bot2-app:
	@STACK_ENV_FILE=.env.bot2 docker compose -f docker-compose.local.yml --env-file .env.bot2 -p bot2 logs --tail=200 -f remnashop

.PHONY: logs-bot2-worker
logs-bot2-worker:
	@STACK_ENV_FILE=.env.bot2 docker compose -f docker-compose.local.yml --env-file .env.bot2 -p bot2 logs --tail=200 -f remnashop-taskiq-worker

.PHONY: logs-bot2-scheduler
logs-bot2-scheduler:
	@STACK_ENV_FILE=.env.bot2 docker compose -f docker-compose.local.yml --env-file .env.bot2 -p bot2 logs --tail=200 -f remnashop-taskiq-scheduler

.PHONY: logs-bot-app
logs-bot-app:
	@test -n "$(BOT)" || (echo "Usage: make logs-bot-app BOT=3" && exit 1)
	@STACK_ENV_FILE=.env.bot$(BOT) docker compose -f docker-compose.local.yml --env-file .env.bot$(BOT) -p bot$(BOT) logs --tail=200 -f remnashop

.PHONY: logs-bot-worker
logs-bot-worker:
	@test -n "$(BOT)" || (echo "Usage: make logs-bot-worker BOT=3" && exit 1)
	@STACK_ENV_FILE=.env.bot$(BOT) docker compose -f docker-compose.local.yml --env-file .env.bot$(BOT) -p bot$(BOT) logs --tail=200 -f remnashop-taskiq-worker

.PHONY: logs-bot-scheduler
logs-bot-scheduler:
	@test -n "$(BOT)" || (echo "Usage: make logs-bot-scheduler BOT=3" && exit 1)
	@STACK_ENV_FILE=.env.bot$(BOT) docker compose -f docker-compose.local.yml --env-file .env.bot$(BOT) -p bot$(BOT) logs --tail=200 -f remnashop-taskiq-scheduler

.PHONY: ps-bots
ps-bots:
	@STACK_ENV_FILE=.env.bot1 docker compose -f docker-compose.local.yml --env-file .env.bot1 -p bot1 ps
	@STACK_ENV_FILE=.env.bot2 docker compose -f docker-compose.local.yml --env-file .env.bot2 -p bot2 ps

.PHONY: ps-bot2
ps-bot2:
	@STACK_ENV_FILE=.env.bot2 docker compose -f docker-compose.local.yml --env-file .env.bot2 -p bot2 ps

.PHONY: ps-bot
ps-bot:
	@test -n "$(BOT)" || (echo "Usage: make ps-bot BOT=3" && exit 1)
	@STACK_ENV_FILE=.env.bot$(BOT) docker compose -f docker-compose.local.yml --env-file .env.bot$(BOT) -p bot$(BOT) ps

.PHONY: _run_local
_run_local:
ifneq ($(RESET),)
	@docker compose -f docker-compose.local.yml down -v
endif
	@echo "Running default .env stack only. For isolated sellers use: make up-bots"
	@docker compose -f docker-compose.local.yml up --build
	@docker compose logs -f

.PHONY: _run_prod
_run_prod:
ifneq ($(RESET),)
	@docker compose -f docker-compose.prod.external.yml down -v
endif
	@docker compose -f docker-compose.prod.external.yml up --build
	@docker compose logs -f

# ── Migrations ─────────────────────────────────────────────────────────────────

.PHONY: migration
migration:
	alembic -c $(ALEMBIC_INI) revision --autogenerate

.PHONY: migration-local
migration-local:
	$(LOCAL_DB_ENV) alembic -c $(ALEMBIC_INI) revision --autogenerate

.PHONY: migrate
migrate:
	alembic -c $(ALEMBIC_INI) upgrade head

.PHONY: migrate-local
migrate-local:
	$(LOCAL_DB_ENV) alembic -c $(ALEMBIC_INI) upgrade head

.PHONY: downgrade
downgrade:
	@if [ -z "$(rev)" ]; then \
		echo "No revision specified. Downgrading by 1 step."; \
		alembic -c $(ALEMBIC_INI) downgrade -1; \
	else \
		alembic -c $(ALEMBIC_INI) downgrade $(rev); \
	fi

.PHONY: downgrade-local
downgrade-local:
	@if [ -z "$(rev)" ]; then \
		echo "No revision specified. Downgrading by 1 step."; \
		$(LOCAL_DB_ENV) alembic -c $(ALEMBIC_INI) downgrade -1; \
	else \
		$(LOCAL_DB_ENV) alembic -c $(ALEMBIC_INI) downgrade $(rev); \
	fi

# ── Misc ───────────────────────────────────────────────────────────────────────

.PHONY: reset
reset:
	@: