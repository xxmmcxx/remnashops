# Menu
msg-main-menu =
    { hdr-user-profile }
    { frg-user }

    { hdr-subscription }
    { $status ->
    [ACTIVE]
    { frg-subscription }
    [EXPIRED]
    <blockquote>
    • مدت اعتبار تمام شده است.
    
    <i>{ $is_trial ->
    [0] اشتراک شما منقضی شده است. آن را تمدید کنید تا بتوانید به استفاده از سرویس ادامه دهید!
    *[1] دوره آزمایشی رایگان شما تمام شده است. برای ادامه استفاده از سرویس، اشتراک تهیه کنید!
    }</i>
    </blockquote>
    [LIMITED]
    <blockquote>
    • ترافیک شما تمام شده است.

    <i>{ $is_trial ->
    [0] { $traffic_strategy ->
        [NO_RESET] اشتراک را تمدید کنید تا ترافیک بازنشانی شود و به استفاده از سرویس ادامه دهید!
        *[RESET] ترافیک در { $reset_time } بازیابی خواهد شد. همچنین می‌توانید اشتراک را تمدید کنید تا ترافیک بازنشانی شود.
        }
    *[1] { $traffic_strategy ->
        [NO_RESET] برای ادامه استفاده از سرویس، اشتراک تهیه کنید!
        *[RESET] ترافیک در { $reset_time } بازیابی خواهد شد. همچنین می‌توانید اشتراک تهیه کنید تا بدون محدودیت از سرویس استفاده کنید.
        }
    }</i>
    </blockquote>
    [DISABLED]
    <blockquote>
    • اشتراک شما غیرفعال شده است.

    <i>برای بررسی علت، با پشتیبانی تماس بگیرید!</i>
    </blockquote>
    *[NONE]
    <blockquote>
    • شما هیچ اشتراکی ندارید.

    <i>{ $trial_available ->
    [1] 🎁 نسخه آزمایشی رایگان برای شما در دسترس است — برای دریافت آن دکمه زیر را بزنید.
    *[0] ↘️ برای خرید دسترسی به منوی «اشتراک» بروید.
    }</i>
    </blockquote>
    }

msg-menu-devices =
    <b>📱 مدیریت دستگاه‌ها</b>

    متصل‌شده: <b>{ $current_count } / { $max_count }</b>

    { $has_devices ->
    [0] { empty }
    *[HAS] برای حذف، روی دستگاه بزنید.
    اگر دستگاه کم دارید، اشتراک را تغییر دهید.
    }

msg-menu-devices-confirm-reissue =
    🔄 <b>صدور دوباره اشتراک</b>

    ⚠️ پس از بازنشانی، لینک قدیمی <b>از کار می‌افتد</b>.

    لازم است:
    • اشتراک قدیمی را از برنامه حذف کنید
    • لینک جدید را از بخش «اتصال» اضافه کنید

    مطمئنید که می‌خواهید لینک را بازنشانی کنید؟

msg-menu-devices-confirm-delete =
    🗑 دستگاه <b>{ $selected_device_label }</b> حذف شود؟

msg-menu-devices-confirm-delete-all =
    🗑 <b>همه دستگاه‌ها</b> حذف شوند؟

msg-menu-my-subs =
    <b>📦 اشتراک های من</b>

    یکی از اشتراک های زیر را انتخاب کنید تا اطلاعات و لینک اتصال آن باز شود.

msg-menu-my-subs-empty =
    هنوز هیچ اشتراکی برای شما ذخیره نشده است.

msg-menu-my-subs-item =
    <b>📦 اشتراک: { $plan_name }</b>

    <blockquote>
    • <b>وضعیت</b>: { subscription-status }
    • <b>اعتبار تا</b>: { $expire_time }
    • <b>ترافیک</b>: { $traffic_limit }
    • <b>دستگاه ها</b>: { $device_limit }
    • <b>لینک</b>: <code>{ $subscription_url }</code>
    </blockquote>

    { $is_current ->
        [1] 🔹 این اشتراک فعال فعلی شماست
        *[0] { empty }
    }

msg-menu-my-subs-item-empty =
    اشتراک پیدا نشد. به لیست برگردید و یک مورد دیگر را انتخاب کنید.

msg-menu-invite =
    <b>👥 دعوت از دوستان</b>
    
    لینک اختصاصی خود را به اشتراک بگذارید و پاداش بگیرید به شکل { $reward_type ->
        [POINTS] <b>امتیازهایی که می‌توان آن‌ها را به اشتراک یا پول واقعی تبدیل کرد</b>
        [EXTRA_DAYS] <b>روزهای رایگان به اشتراک شما</b>
        *[OTHER] { $reward_type }
    }!

    <b>📊 آمار:</b>
    <blockquote>
    👥 مجموع دعوت‌شدگان: { $referrals }
    💳 پرداخت‌ها از طریق لینک شما: { $payments }
    { $reward_type -> 
    [POINTS] 💎 امتیازهای شما: { $points }
    *[EXTRA_DAYS] { empty }
    }
    </blockquote>

msg-menu-invite-about =
    <b>🎁 جزئیات پاداش</b>

    <b>✨ چگونه پاداش می‌گیرید:</b>
    <blockquote>
    { $accrual_strategy ->
    [ON_FIRST_PAYMENT] پاداش برای اولین خرید اشتراک توسط کاربر دعوت‌شده ثبت می‌شود.
    [ON_EACH_PAYMENT] پاداش برای هر خرید یا تمدید اشتراک توسط کاربر دعوت‌شده ثبت می‌شود.
    *[OTHER] { $accrual_strategy }
    }
    </blockquote>

    <b>💎 چه چیزی دریافت می‌کنید:</b>
    <blockquote>
    { $max_level -> 
    [1] برای دوستان دعوت‌شده: { $reward_level_1 }
    *[MORE]
    { $identical_reward ->
    [0]
    1️⃣ برای دوستان شما: { $reward_level_1 }
    2️⃣ برای کسانی که توسط دوستان شما دعوت شده‌اند: { $reward_level_2 }
    *[1]
    برای دوستان شما و دعوت‌شدگان توسط دوستان شما: { $reward_level_1 }
    }
    }
    
    { $reward_strategy_type ->
    [AMOUNT] { $reward_type ->
        [POINTS] { space }
        [EXTRA_DAYS] <i>(همه روزهای اضافی به اشتراک فعلی شما افزوده می‌شوند)</i>
        *[OTHER] { $reward_type }
    }
    [PERCENT] { $reward_type ->
        [POINTS] <i>(درصد امتیاز از قیمت اشتراک خریداری‌شده آن‌ها)</i>
        [EXTRA_DAYS] <i>(درصد روزهای اضافه از اشتراک خریداری‌شده آن‌ها)</i>
        *[OTHER] { $reward_type }
    }
    *[OTHER] { $reward_strategy_type }
    }
    </blockquote>

msg-invite-reward = { $value }{ $reward_strategy_type ->
    [AMOUNT] { $reward_type ->
        [POINTS] { space }{ $value -> 
            [one] امتیاز
            [few] امتیاز
            *[more] امتیاز 
            }
        [EXTRA_DAYS] { space }اضافه { $value -> 
            [one] روز
            [few] روز
            *[more] روز
            }
        *[OTHER] { $reward_type }
    }
    [PERCENT] % { $reward_type ->
        [POINTS] امتیاز
        [EXTRA_DAYS] روز اضافه
        *[OTHER] { $reward_type }
    }
    *[OTHER] { $reward_strategy_type }
    }


# Dashboard
msg-dashboard-main = <b>🛠 پنل مدیریت</b>
msg-users-main = <b>👥 کاربران</b>
msg-broadcast-main = <b>📢 ارسال همگانی</b>
msg-statistics-main = <b>📊 آمار</b>
    
msg-statistics-users =
    <b>👥 آمار کاربران</b>

    <blockquote>
    • <b>مجموع</b>: { $total_users }
    • <b>جدید در روز</b>: { $new_users_daily }
    • <b>جدید در هفته</b>: { $new_users_weekly }
    • <b>جدید در ماه</b>: { $new_users_monthly }

    • <b>دارای اشتراک</b>: { $users_with_subscription }
    • <b>بدون اشتراک</b>: { $users_without_subscription }
    • <b>دارای دوره آزمایشی</b>: { $users_with_trial }
    </blockquote>

    <blockquote>
    • <b>مسدودشده‌ها</b>: { $blocked_users }
    • <b>ربات را مسدود کرده‌اند</b>: { $bot_blocked_users }

    • <b>نرخ تبدیل کاربر → خرید</b>: { $user_conversion }%
    • <b>نرخ تبدیل آزمایشی → اشتراک</b>: { $trial_conversion }%
    </blockquote>

msg-statistics-subscriptions =
    { $plan_name ->
    [0] <b>💳 آمار اشتراک‌ها</b>
    *[HAS] <b>📦 آمار طرح «{ $plan_name }»</b>
    }

    <blockquote>
    • <b>مجموع</b>: { $total }
    • <b>فعال</b>: { $total_active }
    • <b>غیرفعال</b>: { $total_disabled }
    • <b>محدود</b>: { $total_limited }
    • <b>منقضی‌شده</b>: { $total_expired }
    • <b>در حال انقضا (۷ روز)</b>: { $expiring_soon }
    { $plan_name ->
    [0] • <b>آزمایشی</b>: { $active_trial }
    *[HAS] • <b>مدت محبوب</b>: { $popular_duration }
    }
    </blockquote>

    { $plan_name ->
    [0] <blockquote>
    • <b>نامحدود</b>: { $total_unlimited }
    • <b>دارای سقف ترافیک</b>: { $total_traffic }  
    • <b>دارای سقف دستگاه</b>: { $total_devices }
    </blockquote>
    *[HAS] <b>درآمد کل</b>:
    <blockquote>
    { $all_income }
    </blockquote>
    }
    
msg-statistics-subscriptions-plan-income = { $income }{ $currency }
    
msg-statistics-transactions =
    { $gateway_type ->
    [0] <b>🧾 آمار کلی تراکنش‌ها</b>
    *[HAS] <b>🧾 آمار { gateway-type }</b>
    }

    <blockquote>
    • <b>مجموع تراکنش‌ها</b>: { $total_transactions }
    • <b>تراکنش‌های تکمیل‌شده</b>: { $completed_transactions }
    • <b>تراکنش‌های رایگان</b>: { $free_transactions }
    { $gateway_type ->
    [0] { $popular_gateway ->
        [0] { empty }
        *[HAS] • <b>درگاه پرداخت محبوب</b>: { $popular_gateway }
        }
    *[HAS] { empty }
    }
    </blockquote>

    { $gateway_type ->
    [0] { empty }
    *[HAS] <blockquote>
    • <b>درآمد کل</b>: { $total_income }{ $currency }
    • <b>درآمد روزانه</b>: { $daily_income }{ $currency }
    • <b>درآمد هفتگی</b>: { $weekly_income }{ $currency }
    • <b>درآمد ماهانه</b>: { $monthly_income }{ $currency }
    • <b>میانگین پرداخت</b>: { $average_check }{ $currency }
    • <b>مجموع تخفیف‌ها</b>: { $total_discounts }{ $currency }
    </blockquote>
    }

msg-statistics-promocodes =
    <b>🎁 آمار کدهای تخفیف</b>

    <blockquote>
    • <b>تعداد کل فعال‌سازی‌ها</b>: { $total_promo_activations }
    • <b>محبوب‌ترین کد تخفیف</b>: { $most_popular_promo ->
    [0] { unknown }
    *[HAS] { $most_popular_promo }
    }
    • <b>روزهای اعطا‌شده</b>: { $total_promo_days }
    • <b>ترافیک اعطا‌شده</b>: { $total_promo_days }
    • <b>اشتراک‌های اعطا‌شده</b>: { $total_promo_subscriptions }
    • <b>تخفیف‌های شخصی اعطا‌شده</b>: { $total_promo_personal_discounts }
    • <b>تخفیف‌های یک‌باره اعطا‌شده</b>: { $total_promo_purchase_discounts }
    </blockquote>

msg-statistics-referrals =
    <b>👪 آمار ارجاعات</b>

    <blockquote>
    • <b>مجموع ارجاعات</b>: { $total_referrals }
    • <b>سطح ۱</b>: { $level_1_count }
    • <b>سطح ۲</b>: { $level_2_count }
    • <b>معرف‌کنندگان یکتا</b>: { $unique_referrers }
    { $top_referrer_telegram_id ->
        [0] { empty }
        *[HAS] • <b>معرف برتر</b>: { $top_referrer_username ->
            [0] { NUMBER($top_referrer_telegram_id, useGrouping: 0) }
            *[HAS] <a href="tg://user?id={ $top_referrer_telegram_id }">@{ $top_referrer_username }</a> 
                } ({ $top_referrer_referrals_count } دعوت‌شده)
    }
    </blockquote>

    <blockquote>
    • <b>پاداش‌های اعطا شده</b>: { $total_rewards_issued }
    • <b>امتیازهای اعطا شده</b>: { $total_points_issued }
    • <b>روزهای اعطا شده</b>: { $total_days_issued }
    </blockquote>


# Access
msg-access-main =
    <b>🔓 حالت دسترسی</b>
    
    <blockquote>
    • <b>حالت</b>: { access-mode }
    • <b>پرداخت‌ها</b>: { $payments_allowed ->
    [0] ممنوع
    *[1] مجاز
    }.
    • <b>ثبت‌نام</b>: { $registration_allowed ->
    [0] ممنوع
    *[1] مجاز
    }.
    </blockquote>

msg-access-conditions =
    <b>⚙️ شرایط دسترسی</b>

msg-access-rules =
    <b>✳️ تغییر لینک قوانین</b>

    { $rules_url ->
    [0] { space }
    *[HAS]
    <blockquote>
    { $rules_url }
    </blockquote>
    }

    لینک را وارد کنید (به‌صورت https://telegram.org/tos).

msg-access-channel =
    <b>❇️ تغییر لینک کانال/گروه</b>

    { $channel_url ->
    [0] { space }
    *[HAS]
    <blockquote>
    { $channel_url } { $channel_id -> 
        [0] { empty } 
        *[HAS] (ID: { $channel_id }) 
        }
    </blockquote>
    }
    
    اگر گروه شما @username ندارد، شناسه گروه و لینک دعوت را جداگانه بفرستید.
    
    اگر کانال/گروه شما عمومی است، فقط @username را وارد کنید.


# Broadcast
msg-broadcast-list = <b>📄 فهرست ارسال‌ها</b>
msg-broadcast-plan-select = <b>📦 طرح را برای ارسال انتخاب کنید</b>
msg-broadcast-send = <b>📢 ارسال همگانی ({ audience-type })</b>

    { $audience_count } { $audience_count ->
    [one] کاربر
    [few] کاربر
    *[more] کاربر
    } ارسال خواهد شد

msg-broadcast-content =
    <b>✉️ محتوای ارسال همگانی</b>

    هر پیامی را بفرستید: متن، تصویر یا هر دو با هم (HTML پشتیبانی می‌شود).

msg-broadcast-buttons = <b>✳️ دکمه‌های ارسال همگانی</b>

msg-broadcast-view =
    <b>📢 ارسال همگانی</b>

    <blockquote>
    • <b>ID</b>: <code>{ $broadcast_id }</code>
    • <b>وضعیت</b>: { broadcast-status }
    • <b>مخاطب</b>: { audience-type }
    • <b>ایجاد شده</b>: { $created_at }
    </blockquote>

    <blockquote>
    • <b>مجموع پیام‌ها</b>: { $total_count }
    • <b>موفق</b>: { $success_count }
    • <b>ناموفق</b>: { $failed_count }
    </blockquote>


# Users
msg-users-recent-registered = <b>🆕 آخرین ثبت‌نام‌شده‌ها</b>
msg-users-recent-activity = <b>📝 آخرین تعامل‌کنندگان</b>
msg-user-transactions = <b>🧾 تراکنش‌های کاربر</b>
msg-user-devices = <b>📱 دستگاه‌های کاربر ({ $current_count } / { $max_count })</b>
msg-user-give-access = <b>🔑 اعطای دسترسی به طرح</b>

msg-users-search =
    <b>🔍 جستجوی کاربر</b>

    شناسه کاربر، بخشی از نام او را وارد کنید یا یکی از پیام‌هایش را فوروارد کنید.

msg-users-search-results =
    <b>🔍 جستجوی کاربر</b>

    <b>{ $count }</b> { $count ->
    [one] کاربر
    [few] کاربر
    *[more] کاربر
    } پیدا شد، { $count ->
    [one] مطابق
    *[more] مطابق
    } با جستجو

msg-user-main = 
    <b>📝 اطلاعات کاربر</b>

    { hdr-user-profile }
    { frg-user-details }

    <b>💸 تخفیف:</b>
    <blockquote>
    • <b>شخصی</b>: { $personal_discount }%
    • <b>برای خرید بعدی</b>: { $purchase_discount }%
    </blockquote>
    
    { hdr-subscription }
    { $status ->
    [ACTIVE]
    { frg-subscription }
    [EXPIRED]
    <blockquote>
    • مدت اعتبار تمام شده است.
    </blockquote>
    [LIMITED]
    <blockquote>
    • سقف ترافیک رد شده است.
    </blockquote>
    [DISABLED]
    <blockquote>
    • اشتراک غیرفعال است.
    </blockquote>
    *[NONE]
    <blockquote>
    • هیچ اشتراک فعلی‌ای وجود ندارد.
    </blockquote>
    }

msg-user-statistics =
    <b>📊 آمار کاربر</b>

    <blockquote>
    • <b>تاریخ ثبت‌نام</b>: { $registered_at }
    • <b>آخرین پرداخت</b>: { $last_payment_at ->
        [0] { unknown }
        *[HAS] { $last_payment_at }
    }
    </blockquote>

    { $payment_amounts ->
    [0] { space }
    *[HAS] <blockquote>
    { $payment_amounts }
    </blockquote>
    }

    <blockquote>
    • <b>دعوت‌شده توسط</b>: { $referrer_telegram_id ->
        [0] { unknown }
        *[HAS] { $referrer_username -> 
            [0] { NUMBER($referrer_telegram_id, useGrouping: 0) }
            *[HAS] <a href="tg://user?id={ $referrer_telegram_id }">@{ $referrer_username }</a>
            }
    }
    • <b>دعوت‌شدگان (سطح ۱)</b>: { $referrals_level_1 }
    • <b>دعوت‌شدگان (سطح ۲)</b>: { $referrals_level_2 }
    • <b>امتیازهای دریافتی</b>: { $reward_points }
    • <b>روزهای دریافتی</b>: { $reward_days }
    </blockquote>

msg-user-statistics-payment-amount = • <b>پرداخت‌شده ({ $currency })</b>: { $amount }

msg-user-referrals = <b>👪 ارجاعات کاربر</b>

msg-user-sync = 
    <b>🌀 همگام‌سازی کاربر</b>

    <b>🛍 Remnashop:</b> { $bot_version }
    <blockquote>
    { $has_bot_subscription -> 
    [0] داده‌ای وجود ندارد
    *[HAS]{ $bot_subscription }
    }
    </blockquote>

    <b>🌊 Remnawave:</b> { $remna_version }
    <blockquote>
    { $has_remna_subscription -> 
    [0] داده‌ای وجود ندارد
    *[HAS] { $remna_subscription }
    }
    </blockquote>

    داده‌های معتبر را برای همگام‌سازی انتخاب کنید.

msg-user-sync-version = { $version ->
    [NEWER] (جدیدتر)
    [OLDER] (قدیمی‌تر)
    *[UNKNOWN] { empty }
    }

msg-user-sync-subscription =
    • <b>ID</b>: <code>{ $id }</code>
    • وضعیت: { $status -> 
    [ACTIVE] فعال
    [DISABLED] غیرفعال
    [LIMITED] ترافیک تمام شده
    [EXPIRED] منقضی شده
    [DELETED] حذف شده
    *[OTHER] { $status }
    }
    • لینک: <a href="{ $url }">*********</a>

    • سقف ترافیک: { $traffic_limit }
    • سقف دستگاه: { $device_limit }
    • مانده: { $expire_time }

    • اسکوادهای داخلی: { $internal_squads ->
    [0] { unknown }
    *[HAS] { $internal_squads }
    }
    • اسکواد خارجی: { $external_squad ->
    [0] { unknown }
    *[HAS] { $external_squad }
    }
    • بازنشانی ترافیک: { $traffic_limit_strategy -> 
    [NO_RESET] هنگام پرداخت
    [DAY] هر روز
    [WEEK] هر هفته
    [MONTH] هر ماه
    [MONTH_ROLLING] هر ماه (بر اساس تاریخ ایجاد)
    *[OTHER] { $traffic_limit_strategy }
    }
    • برچسب: { $tag -> 
    [0] { unknown }
    *[HAS] { $tag }
    }

msg-user-sync-waiting =
    <b>🌀 همگام‌سازی کاربر</b>

    لطفاً صبر کنید... فرایند همگام‌سازی داده‌های کاربر در حال انجام است. پس از پایان، به‌طور خودکار به ویرایشگر کاربر برمی‌گردید.

msg-user-give-subscription =
    <b>🎁 اعطای اشتراک</b>

    طرحی را که می‌خواهید به کاربر بدهید انتخاب کنید.

msg-user-give-subscription-duration =
    <b>⏳ مدت را انتخاب کنید</b>

    مدت اشتراکی را که می‌خواهید بدهید انتخاب کنید.

msg-user-discount =
    <b>💸 تغییر تخفیف</b>

    نوع تخفیفی را که می‌خواهید تغییر دهید انتخاب کنید.

msg-user-discount-personal =
    <b>👤 تخفیف شخصی</b>

    با دکمه انتخاب کنید یا مقدار دلخواه خود را وارد کنید.

msg-user-discount-purchase =
    <b>🎟 تخفیف برای خرید بعدی</b>

    با دکمه انتخاب کنید یا مقدار دلخواه خود را وارد کنید.
    این تخفیف فقط یک‌بار اعمال می‌شود و پس از هر پرداختی بازنشانی می‌شود.

msg-user-points =
    <b>💎 تغییر امتیازهای سیستم ارجاع</b>

    <b>تعداد فعلی امتیازها: { $current_points }</b>

    با دکمه انتخاب کنید یا مقدار دلخواه خود را وارد کنید تا اضافه یا کم شود.

msg-user-subscription-traffic-limit =
    <b>🌐 تغییر سقف ترافیک</b>

    با دکمه انتخاب کنید یا مقدار دلخواه خود را (به گیگابایت) وارد کنید تا سقف ترافیک تغییر کند.

msg-user-subscription-device-limit =
    <b>📱 تغییر سقف دستگاه</b>

    با دکمه انتخاب کنید یا مقدار دلخواه خود را وارد کنید تا سقف دستگاه تغییر کند.

msg-user-subscription-expire-time =
    <b>⏳ تغییر مدت اعتبار</b>

    <b>پایان می‌یابد تا: { $expire_time }</b>

    با دکمه انتخاب کنید یا مقدار دلخواه خود را (به روز) وارد کنید تا اضافه یا کم شود.

msg-user-subscription-squads =
    <b>🔗 تغییر فهرست اسکوادها</b>

    { $internal_squads ->
    [0] { empty }
    *[HAS] <b>⏺️ داخلی:</b> { $internal_squads }
    }

    { $external_squad ->
    [0] { empty }
    *[HAS] <b>⏹️ خارجی:</b> { $external_squad }
    }

msg-user-subscription-internal-squads =
    <b>⏺️ تغییر فهرست اسکوادهای داخلی</b>

    انتخاب کنید کدام گروه‌های داخلی به این کاربر اختصاص داده شوند.

msg-user-subscription-external-squads =
    <b>⏹️ تغییر اسکواد خارجی</b>

    انتخاب کنید کدام گروه خارجی به این کاربر اختصاص داده شود.

msg-user-subscription-info =
    <b>💳 اطلاعات اشتراک فعلی</b>
    
    { hdr-subscription }
    { frg-subscription-details }

    <blockquote>
    • <b>اسکوادهای داخلی</b>: { $internal_squads ->
    [0] { unknown }
    *[HAS] { $internal_squads }
    }
    • <b>اسکواد خارجی</b>: { $external_squad ->
    [0] { unknown }
    *[HAS] { $external_squad }
    }
    • <b>اولین اتصال</b>: { $first_connected_at -> 
    [0] { unknown }
    *[HAS] { $first_connected_at }
    }
    • <b>آخرین اتصال</b>: { $last_connected_at ->
    [0] { unknown }
    *[HAS] { $last_connected_at } ({ $node_name })
    } 
    </blockquote>

    { hdr-plan }
    { frg-plan-snapshot }

msg-user-transaction-info =
    <b>🧾 اطلاعات تراکنش</b>

    { hdr-payment }
    <blockquote>
    • <b>ID</b>: <code>{ $payment_id }</code>
    • <b>نوع</b>: { purchase-type }
    • <b>وضعیت</b>: { transaction-status }
    • <b>روش پرداخت</b>: { gateway-type }
    • <b>مبلغ</b>: { frg-payment-amount }
    • <b>ایجاد شده</b>: { $created_at }
    </blockquote>

    { $is_test -> 
    [1] ⚠️ تراکنش آزمایشی
    *[0]
    { hdr-plan }
    { frg-plan-snapshot }
    }
    
msg-user-role = 
    <b>👮‍♂️ تغییر نقش</b>
    
    نقش جدیدی را برای کاربر انتخاب کنید.

msg-users-blacklist =
    <b>🚫 فهرست سیاه</b>

    مسدودشده: <b>{ $count_blocked }</b> / <b>{ $count_users }</b> ({ $percent }%).

msg-user-message =
    <b>📩 ارسال پیام به کاربر</b>

    هر پیامی را بفرستید: متن، تصویر یا هر دو با هم (HTML پشتیبانی می‌شود).
    

# RemnaWave
msg-remnawave-main =
    <b>🌊 RemnaWave v{ $version }</b>
    
    <b>🖥️ سیستم:</b>
    <blockquote>
    • <b>پردازنده</b>: { $cpu_cores } { $cpu_cores ->
    [one] هسته
    [few] هسته
    *[more] هسته
    }
    • <b>رم</b>: { $ram_used } / { $ram_total } ({ $ram_used_percent }%)
    • <b>آپ‌تایم</b>: { $uptime }
    </blockquote>

msg-remnawave-users =
    <b>👥 کاربران</b>

    <b>📊 آمار:</b>
    <blockquote>
    • <b>مجموع</b>: { $users_total }
    • <b>فعال</b>: { $users_active }
    • <b>غیرفعال</b>: { $users_disabled }
    • <b>محدود</b>: { $users_limited }
    • <b>منقضی‌شده</b>: { $users_expired }
    </blockquote>

    <b>🟢 آنلاین:</b>
    <blockquote>
    • <b>در روز</b>: { $online_last_day }
    • <b>در هفته</b>: { $online_last_week }
    • <b>هرگز وارد نشده‌اند</b>: { $online_never }
    • <b>هم‌اکنون آنلاین</b>: { $online_now }
    </blockquote>

msg-remnawave-host-details =
    <b>{ $remark } ({ $is_disabled ->
    [1] خاموش
    *[0] روشن
    }):</b>
    <blockquote>
    • <b>آدرس</b>: <code>{ $address }:{ $port }</code>
    { $inbound_uuid ->
    [0] { empty }
    *[HAS] • <b>این‌باند</b>: <code>{ $inbound_uuid }</code>
    }
    </blockquote>

msg-remnawave-node-details =
    <b>{ $country } { $name } ({ $is_connected ->
    [1] متصل
    *[0] قطع
    }):</b>
    <blockquote>
    • <b>آدرس</b>: <code>{ $address }{ $port -> 
    [0] { empty }
    *[HAS]:{ $port }
    }</code>
    • <b>آپ‌تایم (xray)</b>: { $xray_uptime }
    • <b>کاربران آنلاین</b>: { $users_online }
    • <b>ترافیک</b>: { $traffic_used } / { $traffic_limit }
    </blockquote>

msg-remnawave-inbound-details =
    <b>🔗 { $tag }</b>
    <blockquote>
    • <b>ID</b>: <code>{ $inbound_id }</code>
    • <b>پروتکل</b>: { $type } { $network -> 
    [0] { space }
    *[HAS] ({ $network })
    }
    { $port ->
    [0] { empty }
    *[HAS] • <b>پورت</b>: { $port }
    }
    { $security ->
    [0] { empty }
    *[HAS] • <b>امنیت</b>: { $security } 
    }
    </blockquote>

msg-remnawave-hosts =
    <b>🌐 هاست‌ها</b>
    
    { $host }

msg-remnawave-nodes = 
    <b>🖥️ نودها</b>

    { $node }

msg-remnawave-inbounds =
    <b>🔌 این‌باندها</b>

    { $inbound }


# RemnaShop
msg-remnashop-main = <b>🛍 RemnaShop { $version ->
[0] { space }
*[HAS] { $version }
}</b>

msg-admins-main =
    <b>👮‍♂️ مدیران</b>

    شناسه تلگرام کاربر را ارسال کنید تا نقش ادمین به او داده شود.

msg-remnashop-global-banner =
    <b>🖼️ بنر سراسری</b>

    <blockquote>
    • <b>وضعیت</b>: { $enabled ->
        [1] 🟢 روشن
        *[0] 🔴 خاموش
    }
    • <b>URL</b>: <code>{ $image_url }</code>
    • <b>فایل آپلود شده</b>: <code>{ $image_path }</code>
    </blockquote>

    یک لینک مستقیم تصویر (https) ارسال کنید یا تصویر را مستقیم در چت آپلود کنید.

msg-remnashop-qr-background =
    <b>🖼️ پس‌زمینه QR اشتراک</b>

    <blockquote>
    • <b>وضعیت</b>: { $enabled ->
        [1] 🟢 روشن
        *[0] 🔴 خاموش
    }
    • <b>URL تصویر</b>: <code>{ $image_url }</code>
    </blockquote>

    یک لینک مستقیم تصویر (https) برای پس‌زمینه ارسال کنید.
    برای حذف پس‌زمینه، <code>/clear</code> را ارسال کنید.


# Menu editor
msg-menu-editor-main =
    <b>🎛 ویرایشگر دکمه‌های منوی اصلی</b>

    دکمه‌ای را برای ویرایش انتخاب کنید.

msg-menu-editor-button =
    <b>🎛 پیکربندی دکمه</b>

    <blockquote>
    • <b>وضعیت</b>: { $is_active -> 
        [1] 🟢 فعال
        *[0] 🔴 غیرفعال
        }
    • <b>متن</b>: { $text }
    • <b>دسترسی</b>: { role }
    • <b>نوع</b>: { button-type }
    • <b>داده‌ها</b>: { $payload }
    
    </blockquote>

    گزینه موردنظر را برای تغییر انتخاب کنید.

msg-menu-editor-button-text =
    <b>🏷️ تغییر متن دکمه</b>

    متن دکمه (حداکثر ۳۲ نویسه) یا کلید ترجمه را وارد کنید.

msg-menu-editor-button-availability =
    <b>✴️ تغییر دسترسی دکمه</b>

    نقشِ دسترسی به دکمه را انتخاب کنید.

msg-menu-editor-button-type =
    <b>🔖 تغییر نوع دکمه</b>

    نوع دکمه را انتخاب کنید.

msg-menu-editor-button-payload =
    <b>📄 تغییر داده‌های دکمه</b>

    داده‌های دکمه را وارد کنید (برای لینک‌ها از https استفاده کنید).



# Gateways
msg-gateways-main = <b>🌐 درگاه‌های پرداخت</b>
msg-gateways-settings = <b>🌐 پیکربندی { gateway-type }</b>
msg-gateways-default-currency = <b>💸 ارز پیش‌فرض</b>
msg-gateways-currencies = <b>💱 مدیریت ارزها</b>
msg-gateways-placement = <b>🔢 تغییر جایگاه</b>

msg-gateways-field =
    <b>🌐 پیکربندی { gateway-type }</b>

    مقدار جدید { $field } را وارد کنید.


# Referral
msg-referral-main =
    <b>👥 سیستم ارجاع</b>

    <blockquote>
    • <b>وضعیت</b>: { $is_enable -> 
        [1] 🟢 فعال
        *[0] 🔴 غیرفعال
        }
    • <b>نوع پاداش</b>: { reward-type }
    • <b>تعداد سطوح</b>: { $referral_level }
    • <b>شرط محاسبه</b>: { accrual-strategy }
    • <b>شیوه محاسبه</b>: { reward-strategy }
    </blockquote>

    گزینه موردنظر را برای تغییر انتخاب کنید.

msg-referral-level =
    <b>🔢 تغییر سطح</b>

    حداکثر سطح ارجاع را انتخاب کنید.

msg-referral-reward-type =
    <b>🎀 تغییر نوع پاداش</b>

    نوع پاداش جدید را انتخاب کنید.
    
msg-referral-accrual-strategy =
    <b>📍 تغییر شرط محاسبه</b>

    انتخاب کنید پاداش در چه حالتی محاسبه شود.


msg-referral-reward-strategy =
    <b>⚖️ تغییر شیوه محاسبه</b>

    روش محاسبه پاداش را انتخاب کنید.


msg-referral-reward-level = سطح { $level }: { $value }{ $reward_strategy_type ->
    [AMOUNT] { $reward_type ->
        [POINTS] { space }{ $value -> 
            [one] امتیاز
            [few] امتیاز
            *[more] امتیاز
            }
        [EXTRA_DAYS] { space }اضافه { $value -> 
            [one] روز
            [few] روز
            *[more] روز
            }
        *[OTHER] { $reward_type }
    }
    [PERCENT] % { $reward_type ->
        [POINTS] امتیاز
        [EXTRA_DAYS] روز اضافه
        *[OTHER] { $reward_type }
    }
    *[OTHER] { $reward_strategy_type }
    }
    
msg-referral-reward =
    <b>🎁 تغییر پاداش</b>

    <blockquote>
    { $reward }
    </blockquote>

    { $reward_strategy_type ->
        [AMOUNT] مقدار { $reward_type ->
            [POINTS] امتیاز
            [EXTRA_DAYS] روز
            *[OTHER] { $reward_type }
        }
        [PERCENT] درصد را وارد کنید از { $reward_type ->
            [POINTS] <u>قیمت اشتراک</u>
            [EXTRA_DAYS] <u>مدت اشتراک</u>
            *[OTHER] { $reward_type }
        }
        *[OTHER] { $reward_strategy_type }
    } (با قالب: level=value)

# Plans
msg-plans-main = <b>📦 طرح‌ها</b>

msg-plans-import = 
    <b>📦 وارد کردن طرح‌ها</b>

    فایل json را برای وارد کردن بفرستید.

msg-plans-export = 
    <b>📦 خروجی گرفتن از طرح‌ها</b>

    طرح‌هایی را برای خروجی انتخاب کنید.

msg-plan-configurator =
    <b>📦 پیکربندی طرح</b>

    <blockquote>
    • <b>نام</b>: { $name }
    • <b>پیشوند</b>: <code>{ $public_code_display }</code>
    • <b>نوع</b>: { plan-type } { $is_trial ->
    [1] (نسخه آزمایشی)
    *[0] { space }
    }
    • <b>دسترسی</b>: { availability-type }
    • <b>وضعیت</b>: { $is_active -> 
        [1] 🟢 روشن
        *[0] 🔴 خاموش
        }
    </blockquote>
    
    <blockquote>
    • <b>سقف ترافیک</b>: { $is_unlimited_traffic -> 
        [1] { unlimited }
        *[0] { $traffic_limit }
        }
    • <b>سقف دستگاه</b>: { $is_unlimited_devices -> 
        [1] { unlimited }
        *[0] { $device_limit }
        }
    </blockquote>

    گزینه موردنظر را برای تغییر انتخاب کنید.

msg-plan-name =
    <b>🏷️ تغییر نام</b>

    { $name ->
    [0] { space }
    *[HAS]
    <blockquote>
    { $name }
    </blockquote>
    }

    نام یکتای طرح یا کلید ترجمه را وارد کنید (حداکثر ۳۲ نویسه).

msg-plan-prefix =
    <b>🧬 تغییر پیشوند اتصال</b>

    { $prefix ->
    [0] { space }
    *[HAS]
    <blockquote>
    پیشوند فعلی: <code>{ $prefix }</code>
    </blockquote>
    }

    پیشوند یکتای جدید این طرح را وارد کنید.
    فقط حروف کوچک لاتین، عدد و <code>_</code> مجاز است (بین ۳ تا ۲۴ نویسه).

msg-plan-description =
    <b>💬 تغییر توضیحات</b>

    { $description ->
    [0] { space }
    *[HAS]
    <blockquote>
    { $description }
    </blockquote>
    }

    توضیحات جدید طرح یا کلید ترجمه را وارد کنید.

msg-plan-tag =
    <b>📌 تغییر برچسب</b>

    { $tag ->
    [0] { space }
    *[HAS]
    <blockquote>
    { $tag }
    </blockquote>
    }

    برچسب جدید طرح را وارد کنید (فقط حروف بزرگ لاتین، اعداد و خط زیر).

msg-plan-type =
    <b>🔖 تغییر نوع</b>

    نوع جدید طرح را انتخاب کنید. برای ارائه این طرح به‌صورت آزمایشی، دکمه «نسخه آزمایشی» را بزنید.

msg-plan-availability =
    <b>✴️ تغییر دسترس‌پذیری</b>

    سطح دسترسی طرح را انتخاب کنید.

msg-plan-traffic =
    <b>🌐 تغییر سقف و شیوه بازنشانی ترافیک</b>

    سقف جدید ترافیک طرح (به گیگابایت) را وارد کنید و شیوه بازنشانی آن را انتخاب کنید.

msg-plan-devices =
    <b>📱 تغییر سقف دستگاه</b>

    سقف جدید دستگاه‌های طرح را وارد کنید.

msg-plan-durations =
    <b>⏳ مدت‌های طرح</b>

    مدت موردنظر را برای تغییر قیمت انتخاب کنید.

msg-plan-duration =
    <b>⏳ افزودن مدت طرح</b>

    مدت جدید را وارد کنید (به روز).

msg-plan-prices =
    <b>💰 تغییر قیمت‌های مدت ({ $value ->
            [0] { unlimited }
            *[other] { unit-day }
        })</b>

    ارز دارای قیمتِ موردنظر برای تغییر را انتخاب کنید.

msg-plan-price =
    <b>💰 تغییر قیمت برای مدت ({ $value ->
            [0] { unlimited }
            *[other] { unit-day }
        })</b>

    قیمت جدید را برای ارز { $currency } وارد کنید.

msg-plan-allowed-users = 
    <b>👥 تغییر فهرست کاربران مجاز</b>

    شناسه کاربر را برای افزودن به فهرست وارد کنید.

msg-plan-squads =
    <b>🔗 اسکوادها</b>

    { $internal_squads ->
    [0] { space }
    *[HAS] <b>⏺️ داخلی:</b> { $internal_squads }
    }

    { $external_squad ->
    [0] { space }
    *[HAS] <b>⏹️ خارجی:</b> { $external_squad }
    }

msg-plan-internal-squads =
    <b>⏺️ تغییر فهرست اسکوادهای داخلی</b>

    انتخاب کنید کدام گروه‌های داخلی به این طرح اختصاص داده شوند.

msg-plan-external-squads =
    <b>⏹️ تغییر اسکواد خارجی</b>

    انتخاب کنید کدام گروه خارجی به این طرح اختصاص داده شود.


# Notifications
msg-notifications-main = <b>🔔 تنظیم اعلان‌ها</b>
msg-notifications-user = <b>👥 اعلان‌های کاربری</b>
msg-notifications-system = <b>⚙️ اعلان‌های سیستمی</b>


# Subscription
msg-subscription-main = <b>💳 اشتراک</b>
msg-subscription-plans = <b>📦 طرح را انتخاب کنید</b>
msg-subscription-new-success = برای شروع استفاده از سرویس ما، دکمه <code>`{ btn-subscription.connect }`</code> را بزنید و دستورالعمل‌ها را دنبال کنید!
msg-subscription-renew-success = اشتراک شما به مدت { $added_duration } تمدید شد.

msg-subscription-plan = 
    <b>📦 طرح در دسترس از طریق لینک</b>
    
    طرح <b>{ $name }</b> از طریق لینک برای شما در دسترس است. دکمه زیر را بزنید تا به انتخاب مدت و روش پرداخت بروید.

    { $description ->
    [0] { space }
    *[HAS]
    <blockquote>
    { $description }
    </blockquote>
    }

    { $purchase_type ->
    [RENEW] <i>⚠️ اشتراک فعلی برای مدت انتخاب‌شده <u>تمدید</u> می‌شود.</i>
    [CHANGE] <i>⚠️ اشتراک فعلی با این طرح <u>جایگزین</u> می‌شود، بدون محاسبه دوباره مدت باقی‌مانده.</i>
    *[OTHER] { empty }
    }
    
msg-subscription-details =
    <b>{ $plan }:</b>
    <blockquote>
    { $description ->
    [0] { empty }
    *[HAS]
    { $description }
    }

    • <b>سقف ترافیک</b>: { $traffic }
    • <b>سقف دستگاه</b>: { $devices }
    { $period ->
    [0] { empty }
    *[HAS] • <b>مدت</b>: { $period }
    }
    { $final_amount ->
    [0] { empty }
    *[HAS] • <b>هزینه</b>: { frg-payment-amount }
    }
    </blockquote>
    
    <blockquote>
    { $discount_percent ->
    [0] { empty }
    *[HAS] <i>قیمت‌ها با احتساب { $is_personal_discount ->
        [1] تخفیف شخصی شما { $discount_percent }%
        *[0] تخفیف یک‌باره { $discount_percent }%
        }
        </i>
    }
    </blockquote>

msg-subscription-duration = 
    <b>⏳ مدت را انتخاب کنید</b>

    { msg-subscription-details }

msg-subscription-payment-method =
    <b>💳 روش پرداخت را انتخاب کنید</b>

    { msg-subscription-details }

msg-subscription-confirm =
    <b>🛒 تأیید { $purchase_type ->
    [RENEW] تمدید
    [CHANGE] تغییر
    *[OTHER] خرید
    } اشتراک</b>

    { msg-subscription-details }

    { $purchase_type ->
    [RENEW] <i>⚠️ اشتراک فعلی برای مدت انتخاب‌شده <u>تمدید</u> می‌شود.</i>
    [CHANGE] <i>⚠️ اشتراک فعلی با گزینه انتخاب‌شده <u>جایگزین</u> می‌شود، بدون محاسبه دوباره مدت باقی‌مانده.</i>
    *[OTHER] { empty }
    }

msg-subscription-manual-payment =
    <blockquote>
    <b>💳 پرداخت کارت‌به‌کارت</b>
    { $manual_payment_description }
    </blockquote>

msg-subscription-manual-receipt =
    <b>🧾 رسید پرداخت را ارسال کنید</b>

    { msg-subscription-manual-payment }

    رسید را در یک پیام ارسال کنید: متن یا تصویر.

msg-subscription-trial =
    <b>✅ اشتراک آزمایشی با موفقیت دریافت شد!</b>

    { msg-subscription-new-success }

msg-subscription-connection-url =
    <b>🔗 لینک اشتراک شما:</b>
    <blockquote><code>{ $subscription_url }</code></blockquote>

msg-subscription-raw-configs-title =
    <b>🧩 کانفیگ های خام ({ $current }/{ $total })</b>

msg-subscription-raw-configs-sent = ✅ کانفیگ های خام ارسال شد
msg-subscription-raw-configs-empty = ⚠️ هیچ کانفیگ خامی از لینک اشتراک شما پیدا نشد.
msg-subscription-raw-configs-unavailable = ❌ دریافت کانفیگ های خام انجام نشد. بعدا دوباره تلاش کنید.
msg-subscription-raw-configs-missing = ⚠️ اشتراک فعال پیدا نشد.

msg-subscription-success =
    <b>✅ پرداخت با موفقیت انجام شد!</b>

    { $purchase_type ->
    [NEW] { msg-subscription-new-success }
    [RENEW] { msg-subscription-renew-success }
    [CHANGE] { msg-subscription-change-success }
    *[OTHER] { $purchase_type }
    }

msg-subscription-change-success = 
    اشتراک شما تغییر کرد.

    <b>{ $plan_name }</b>
    { frg-subscription }

msg-subscription-failed = 
    <b>❌ خطایی رخ داد!</b>

    نگران نباشید، پشتیبانی از قبل مطلع شده و به‌زودی با شما تماس می‌گیرد. بابت ناراحتی پیش‌آمده عذرخواهی می‌کنیم.


# Importer
msg-importer-main =
    <b>📥 وارد کردن کاربران</b>

    آغاز همگام‌سازی: همه کاربران در RemnaWave بررسی می‌شوند. اگر کاربر در پایگاه داده ربات وجود نداشته باشد، ساخته می‌شود و یک اشتراک موقت دریافت می‌کند. اگر داده‌های کاربر متفاوت باشد، به‌طور خودکار به‌روزرسانی می‌شود (اولویت با داده‌های پنل است).

msg-importer-from-xui =
    <b>📥 وارد کردن کاربران (3X-UI)</b>
    
    { $has_exported -> 
    [1]
    <b>🔍 پیدا شد:</b>
    <blockquote>
    مجموع کاربران: { $total }
    با اشتراک فعال: { $active }
    با اشتراک منقضی‌شده: { $expired }
    </blockquote>
    *[0]
    همه کاربران <b>فعال</b> با ایمیل <b>عددی</b> وارد می‌شوند.

    پیشنهاد می‌شود از قبل کاربرانی را که در فیلد ایمیل‌شان Telegram ID ندارند غیرفعال کنید. این عملیات بسته به تعداد کاربران ممکن است زمان زیادی بگیرد.

    فایل پایگاه داده را (با فرمت .db) ارسال کنید.
    }

msg-importer-squads =
    <b>🔗 فهرست اسکوادهای داخلی</b>

    انتخاب کنید کدام گروه‌های داخلی برای کاربران واردشده در دسترس باشند.

msg-importer-import-completed =
    <b>📥 وارد کردن کاربران کامل شد</b>
    
    <b>📃 اطلاعات:</b>
    <blockquote>
    • <b>مجموع کاربران</b>: { $total_count }
    • <b>با موفقیت وارد شدند</b>: { $success_count }
    • <b>وارد کردن ناموفق</b>: { $failed_count }
    </blockquote>

msg-importer-sync-completed =
    <b>📥 همگام‌سازی کاربران کامل شد</b>

    <b>📃 اطلاعات:</b>
    <blockquote>
    مجموع کاربران در پنل: { $total_panel_users }
    مجموع کاربران در ربات: { $total_bot_users }

    کاربران جدید: { $added_users }
    اشتراک‌های اضافه‌شده: { $added_subscription }
    اشتراک‌های به‌روزرسانی‌شده: { $updated}
    
    کاربران بدون Telegram ID: { $missing_telegram }
    خطاهای همگام‌سازی: { $errors }
    </blockquote>


# Promocodes
msg-promocodes-main = <b>🎟 کدهای تخفیف</b>
msg-promocode-configurator =
    <b>🎟 پیکربندی کد تخفیف</b>

    <blockquote>
    • <b>کد</b>: { $code }
    • <b>نوع</b>: { promocode-type }
    • <b>دسترسی</b>: { availability-type }
    • <b>وضعیت</b>: { $is_active -> 
        [1] 🟢 روشن
        *[0] 🔴 خاموش
        }
    </blockquote>

    <blockquote>
    { $promocode_type ->
    [DURATION] • <b>مدت</b>: { $reward }
    [TRAFFIC] • <b>ترافیک</b>: { $reward }
    [DEVICES] • <b>دستگاه‌ها</b>: { $reward }
    [SUBSCRIPTION] • <b>اشتراک</b>: { frg-plan-snapshot }
    [PERSONAL_DISCOUNT] • <b>تخفیف شخصی</b>: { $reward }%
    [PURCHASE_DISCOUNT] • <b>تخفیف خرید</b>: { $reward }%
    *[OTHER] { $promocode_type }
    }
    • <b>مدت اعتبار</b>: { $lifetime }
    • <b>سقف فعال‌سازی</b>: { $max_activations }
    </blockquote>

    گزینه موردنظر را برای تغییر انتخاب کنید.