from aiogram import F, Router
from aiogram.filters import Command as FilterCommand
from aiogram.types import Message
from aiogram_dialog import DialogManager, ShowMode, StartMode
from dishka import FromDishka
from dishka.integrations.aiogram_dialog import inject
from loguru import logger

from src.application.common import Notifier, TranslatorRunner
from src.application.common.dao import SettingsDao
from src.application.dto import MessagePayloadDto, PlanSnapshotDto, UserDto
from src.application.services import BotService
from src.application.use_cases.subscription.commands.purchase import (
    ActivateTrialSubscription,
    ActivateTrialSubscriptionDto,
)
from src.application.use_cases.user.queries.plans import GetAvailableTrial
from src.core.enums import Command
from src.telegram.keyboards import (
    PERSIAN_HELP_COMMAND_TEXT,
    PERSIAN_RULES_COMMAND_TEXT,
    PERSIAN_START_COMMAND_TEXT,
    PERSIAN_SUPPORT_COMMAND_TEXT,
    PERSIAN_TRIAL_COMMAND_TEXT,
    get_contact_support_keyboard,
    get_persian_commands_keyboard,
)
from src.telegram.states import MainMenu

router = Router(name=__name__)


async def _notify_paysupport(
    user: UserDto,
    bot_service: BotService,
    i18n: TranslatorRunner,
    notifier: Notifier,
) -> None:
    support_url = bot_service.get_support_url(text=i18n.get("message.paysupport"))

    await notifier.notify_user(
        user=user,
        payload=MessagePayloadDto(
            i18n_key="ntf-command.paysupport",
            reply_markup=get_contact_support_keyboard(support_url),
            disable_default_markup=False,
            delete_after=None,
        ),
    )


async def _notify_rules(user: UserDto, notifier: Notifier, settings_dao: SettingsDao) -> None:
    settings = await settings_dao.get()
    await notifier.notify_user(
        user=user,
        payload=MessagePayloadDto(
            i18n_key="ntf-command.rules",
            i18n_kwargs={"url": settings.requirements.rules_url},
            disable_default_markup=False,
            delete_after=None,
        ),
    )


async def _notify_help(
    user: UserDto,
    bot_service: BotService,
    i18n: TranslatorRunner,
    notifier: Notifier,
) -> None:
    support_url = bot_service.get_support_url(text=i18n.get("message.help"))

    await notifier.notify_user(
        user=user,
        payload=MessagePayloadDto(
            i18n_key="ntf-command.help",
            reply_markup=get_contact_support_keyboard(support_url),
            disable_default_markup=False,
            delete_after=None,
        ),
    )


@inject
@router.message(FilterCommand(Command.PAYSUPPORT.value.command))
async def on_paysupport_command(
    message: Message,
    user: UserDto,
    bot_service: FromDishka[BotService],
    i18n: FromDishka[TranslatorRunner],
    notifier: FromDishka[Notifier],
) -> None:
    logger.info(f"{user.log} Called '/paysupport' command")
    await _notify_paysupport(user, bot_service, i18n, notifier)


@inject
@router.message(F.text == PERSIAN_SUPPORT_COMMAND_TEXT)
async def on_paysupport_text_command(
    message: Message,
    user: UserDto,
    bot_service: FromDishka[BotService],
    i18n: FromDishka[TranslatorRunner],
    notifier: FromDishka[Notifier],
) -> None:
    del message
    logger.info(f"{user.log} Called quick paysupport command")
    await _notify_paysupport(user, bot_service, i18n, notifier)


@inject
@router.message(FilterCommand(Command.RULES.value.command))
async def on_rules_command(
    message: Message,
    user: UserDto,
    notifier: FromDishka[Notifier],
    settings_dao: FromDishka[SettingsDao],
) -> None:
    logger.info(f"{user.log} Called '/rules' command")
    await _notify_rules(user, notifier, settings_dao)


@inject
@router.message(F.text == PERSIAN_RULES_COMMAND_TEXT)
async def on_rules_text_command(
    message: Message,
    user: UserDto,
    notifier: FromDishka[Notifier],
    settings_dao: FromDishka[SettingsDao],
) -> None:
    del message
    logger.info(f"{user.log} Called quick rules command")
    await _notify_rules(user, notifier, settings_dao)


@inject
@router.message(FilterCommand(Command.HELP.value.command))
async def on_help_command(
    message: Message,
    user: UserDto,
    bot_service: FromDishka[BotService],
    i18n: FromDishka[TranslatorRunner],
    notifier: FromDishka[Notifier],
) -> None:
    logger.info(f"{user.log} Called '/help' command")
    await _notify_help(user, bot_service, i18n, notifier)


@inject
@router.message(F.text == PERSIAN_HELP_COMMAND_TEXT)
async def on_help_text_command(
    message: Message,
    user: UserDto,
    bot_service: FromDishka[BotService],
    i18n: FromDishka[TranslatorRunner],
    notifier: FromDishka[Notifier],
) -> None:
    del message
    logger.info(f"{user.log} Called quick help command")
    await _notify_help(user, bot_service, i18n, notifier)


@inject
@router.message(F.text == PERSIAN_TRIAL_COMMAND_TEXT)
async def on_trial_text_command(
    message: Message,
    user: UserDto,
    notifier: FromDishka[Notifier],
    get_available_trial: FromDishka[GetAvailableTrial],
    activate_trial_subscription: FromDishka[ActivateTrialSubscription],
) -> None:
    del message
    logger.info(f"{user.log} Called quick trial command")

    plan = await get_available_trial.system(user)

    if not plan or not plan.durations:
        await notifier.notify_user(user=user, i18n_key="ntf-common.trial-unavailable")
        return

    trial = PlanSnapshotDto.from_plan(plan, plan.durations[0].days)
    await activate_trial_subscription.system(ActivateTrialSubscriptionDto(user, trial))


@inject
@router.message(F.text == PERSIAN_START_COMMAND_TEXT)
async def on_start_text_command(
    message: Message,
    user: UserDto,
    dialog_manager: DialogManager,
) -> None:
    logger.info(f"{user.log} Called quick start command")

    await message.answer(
        text="⌨️",
        reply_markup=get_persian_commands_keyboard(),
    )

    await dialog_manager.start(
        state=MainMenu.MAIN,
        mode=StartMode.RESET_STACK,
        show_mode=ShowMode.AUTO,
    )
