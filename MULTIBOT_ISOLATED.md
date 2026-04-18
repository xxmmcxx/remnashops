# Isolated Multi-Bot Deployment (Same Source, Separate Data)

This setup runs each seller bot as a separate Docker Compose project.
Each project gets its own:
- Postgres database container + volume
- Redis container + volume
- assets directory (banners, logo, media)
- logs directory

All bots can still use the same Remnawave panel credentials.

## Prepared env files

- `.env.bot1`
- `.env.bot2`

Adjust tokens, domain, owner/support usernames, and ports as needed.

## Add bot3 (and more)

To add a new isolated seller bot, create a new env file for that bot and use a matching project name.

Example for bot3:

1. Create `.env.bot3` by copying `.env.bot2`.
2. Update at least these values:
`BOT_TOKEN`, `APP_DOMAIN`, `APP_PORT`, `DATABASE_EXPOSE_PORT`, `LOCAL_ASSETS_DIR`, `LOCAL_LOGS_DIR`.
3. Start bot3:

```bash
make up-bot BOT=3
```

4. Check status:

```bash
make ps-bot BOT=3
```

5. Inspect logs:

```bash
make logs-bot-app BOT=3
```

## Important

Do not use the plain command below for isolated mode:

```bash
docker compose -f docker-compose.local.yml up --build -d
```

That starts only the default `.env` stack.
For isolated multi-bot mode, always use bot-specific `--env-file`, `-p`, and `STACK_ENV_FILE`.

## Start bot 1

```bash
STACK_ENV_FILE=.env.bot1 docker compose -f docker-compose.local.yml --env-file .env.bot1 -p bot1 up --build -d
```

## Start bot 2

```bash
STACK_ENV_FILE=.env.bot2 docker compose -f docker-compose.local.yml --env-file .env.bot2 -p bot2 up --build -d
```

## Start both bots quickly

```bash
make up-bots
```

This uses `BUILDKIT_PROGRESS=plain` internally to reduce noisy repeated build progress lines.

## Stop bot 1

```bash
STACK_ENV_FILE=.env.bot1 docker compose -f docker-compose.local.yml --env-file .env.bot1 -p bot1 down
```

## Stop bot 2

```bash
STACK_ENV_FILE=.env.bot2 docker compose -f docker-compose.local.yml --env-file .env.bot2 -p bot2 down
```

## Stop both bots quickly

```bash
make down-bots
```

For a specific bot number:

```bash
make down-bot BOT=3
```

## Check both stacks

```bash
make ps-bots
```

For bot2 only:

```bash
make ps-bot2
```

For any bot number:

```bash
make ps-bot BOT=3
```

## Troubleshooting bot2

If `make logs-bot2` exits with `Error 130`, that means logs were interrupted with `Ctrl+C`.
It does not mean the service crashed.

Use focused logs to see real errors:

```bash
make logs-bot2-app
make logs-bot2-worker
make logs-bot2-scheduler
```

Generic commands for any bot number:

```bash
make logs-bot-app BOT=3
make logs-bot-worker BOT=3
make logs-bot-scheduler BOT=3
```

Common checks:
- Confirm logs show the expected bot id for bot2 (should be `8507833928`, not bot1 id).
- Confirm `.env.bot2` has unique values for `APP_PORT`, `APP_DOMAIN`, and `DATABASE_EXPOSE_PORT`.
- Ensure port `5001` is forwarded/publicly reachable if Telegram webhooks are used.
- Verify bot2 stack is up with `make ps-bot2` before checking bot behavior in Telegram.

## Why this satisfies separation

- Users/plans/settings/channels are isolated because each bot has its own Postgres DB instance.
- Banners/logos/media are isolated because each bot uses its own host assets directory via:
  - `LOCAL_ASSETS_DIR=./assets/bot1`
  - `LOCAL_ASSETS_DIR=./assets/bot2`
- Sources stay shared because both stacks mount the same `./src`.

## Notes

- Keep `BOT_EXTRA_TOKENS` empty in `.env` when using isolated stacks.
- Set unique `APP_PORT` and `APP_DOMAIN` per bot.
- `DATABASE_EXPOSE_PORT` should also be unique per stack if you expose DB to host.
