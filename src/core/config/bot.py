from dataclasses import dataclass
from typing import Optional, Union

from pydantic import SecretStr, field_validator
from pydantic_core.core_schema import FieldValidationInfo

from src.core.constants import API_V1, BOT_WEBHOOK_PATH, URL_PATTERN

from .base import BaseConfig
from .validators import validate_not_change_me, validate_username


@dataclass(frozen=True, slots=True)
class BotInstanceConfig:
    key: str
    token: SecretStr
    secret_token: SecretStr
    owner_id: int
    support_username: SecretStr
    mini_app: Union[bool, SecretStr]
    proxy_url: Optional[SecretStr]
    reset_webhook: bool
    drop_pending_updates: bool
    setup_commands: bool
    use_banners: bool
    webhook_path: str

    def webhook_url(self, domain: SecretStr) -> SecretStr:
        url = f"https://{domain.get_secret_value()}{self.webhook_path}"
        return SecretStr(url)

    def safe_webhook_url(self, domain: SecretStr) -> str:
        return f"https://{domain}{self.webhook_path}"


class BotConfig(BaseConfig, env_prefix="BOT_"):
    token: SecretStr
    secret_token: SecretStr
    owner_id: int
    support_username: SecretStr
    mini_app: Union[bool, SecretStr] = False
    proxy_url: Optional[SecretStr] = None

    reset_webhook: bool = False
    drop_pending_updates: bool = False
    setup_commands: bool = True
    use_banners: bool = True

    @property
    def webhook_path(self) -> str:
        return f"{API_V1}{BOT_WEBHOOK_PATH}"

    @property
    def webhook_multi_path(self) -> str:
        return f"{self.webhook_path}/{{bot_key}}"

    @property
    def is_mini_app(self) -> bool:
        if isinstance(self.mini_app, bool):
            return self.mini_app
        return bool(self.mini_app_url)

    @property
    def mini_app_url(self) -> Union[bool, str]:
        if isinstance(self.mini_app, SecretStr):
            value = self.mini_app.get_secret_value().strip()
            if value and URL_PATTERN.match(value):
                return value
        return False

    def webhook_url(self, domain: SecretStr) -> SecretStr:
        url = f"https://{domain.get_secret_value()}{self.webhook_path}"
        return SecretStr(url)

    def safe_webhook_url(self, domain: SecretStr) -> str:
        return f"https://{domain}{self.webhook_path}"

    def build_instances(self, extra_tokens: list[str]) -> list[BotInstanceConfig]:
        all_tokens = [self.token.get_secret_value(), *extra_tokens]

        unique_tokens: list[str] = []
        for token in all_tokens:
            clean = token.strip()
            if clean and clean not in unique_tokens:
                unique_tokens.append(clean)

        instances: list[BotInstanceConfig] = []
        for index, token in enumerate(unique_tokens):
            bot_key = self._extract_bot_key(token)
            webhook_path = self.webhook_path if index == 0 else f"{self.webhook_path}/{bot_key}"

            instances.append(
                BotInstanceConfig(
                    key=bot_key,
                    token=SecretStr(token),
                    secret_token=self.secret_token,
                    owner_id=self.owner_id,
                    support_username=self.support_username,
                    mini_app=self.mini_app,
                    proxy_url=self.proxy_url,
                    reset_webhook=self.reset_webhook,
                    drop_pending_updates=self.drop_pending_updates,
                    setup_commands=self.setup_commands,
                    use_banners=self.use_banners,
                    webhook_path=webhook_path,
                )
            )

        return instances

    def _extract_bot_key(self, token: str) -> str:
        key = token.split(":", maxsplit=1)[0].strip()
        if not key.isdigit():
            raise ValueError("BOT token must start with numeric bot id")
        return key

    @field_validator("token", "secret_token", "support_username")
    @classmethod
    def validate_bot_fields(cls, field: object, info: FieldValidationInfo) -> object:
        validate_not_change_me(field, info)
        return field

    @field_validator("support_username")
    @classmethod
    def validate_bot_support_username(cls, field: object, info: FieldValidationInfo) -> object:
        validate_username(field, info)
        return field

    @field_validator("mini_app")
    @classmethod
    def validate_mini_app(
        cls,
        field: Union[bool, SecretStr],
        info: FieldValidationInfo,
    ) -> Union[bool, SecretStr]:
        if isinstance(field, SecretStr):
            value = field.get_secret_value().strip().lower()
            if value.lower() == "true":
                return True
            if value.lower() == "false" or not value:
                return False
            if URL_PATTERN.match(value):
                return SecretStr(value)
            raise ValueError("BOT_MINI_APP must be empty, True, False or a valid URL")
        return field
