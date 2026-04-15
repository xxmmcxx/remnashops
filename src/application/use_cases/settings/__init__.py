from typing import Final

from src.application.common import Interactor

from .commands.access import ChangeAccessMode, TogglePayments, ToggleRegistration
from .commands.banner import (
    ResetGlobalBanner,
    SetGlobalBannerImagePath,
    ToggleGlobalBanner,
    UpdateGlobalBannerUrl,
)
from .commands.currency import ToggleAvailableCurrency, UpdateDefaultCurrency
from .commands.notifications import ToggleNotification
from .commands.qr_background import ToggleQrBackground, UpdateQrBackgroundUrl
from .commands.referral import (
    ToggleReferralSystem,
    UpdateReferralAccrualStrategy,
    UpdateReferralLevel,
    UpdateReferralRewardConfig,
    UpdateReferralRewardStrategy,
    UpdateReferralRewardType,
)
from .commands.requirements import (
    ToggleConditionRequirement,
    UpdateChannelRequirement,
    UpdateRulesRequirement,
)

SETTINGS_USE_CASES: Final[tuple[type[Interactor], ...]] = (
    ChangeAccessMode,
    ToggleGlobalBanner,
    ToggleConditionRequirement,
    ToggleNotification,
    ToggleQrBackground,
    TogglePayments,
    ToggleReferralSystem,
    ToggleRegistration,
    ResetGlobalBanner,
    SetGlobalBannerImagePath,
    UpdateChannelRequirement,
    UpdateGlobalBannerUrl,
    UpdateReferralAccrualStrategy,
    UpdateReferralLevel,
    UpdateReferralRewardConfig,
    UpdateReferralRewardStrategy,
    UpdateReferralRewardType,
    UpdateRulesRequirement,
    UpdateDefaultCurrency,
    UpdateQrBackgroundUrl,
    ToggleAvailableCurrency,
)
