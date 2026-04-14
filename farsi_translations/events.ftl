event-error =
    .general =
    #ErrorEvent

    <b>🔅 رویداد: خطایی رخ داد!</b>

    { frg-build-info }
    
    { $telegram_id -> 
    [0] { space }
    *[HAS]
    { hdr-user }
    { frg-user-info }
    }

    { hdr-error }
    <blockquote>
    { $error }
    </blockquote>

    .remnawave-version =
    #RemnawaveVersionWarningEvent

    <b>⚠️ رویداد: ناسازگاری احتمالی با Remnawave!</b>

    <blockquote>
    نسخه پنل <b>{ $panel_version }</b> از نسخه آزمایش‌شده <b>{ $max_version }</b> بالاتر است. ممکن است برخی قابلیت‌های ربات درست کار نکنند.
    </blockquote>

    { frg-build-info }
    
    .remnawave =
    #RemnawaveErrorEvent

    <b>🔅 رویداد: خطا در اتصال به Remnawave!</b>

    <blockquote>
    بدون اتصال فعال، عملکرد درست ربات ممکن نیست!
    </blockquote>

    { frg-build-info }

    { hdr-error }
    <blockquote>
    { $error }
    </blockquote>

    .webhook =
    #ErrorEvent

    <b>🔅 رویداد: خطای وبهوک ثبت شد!</b>

    { hdr-error }
    <blockquote>
    { $error }
    </blockquote>


event-bot =
    .startup =
    #BotStartupEvent

    <b>🔅 رویداد: ربات راه‌اندازی شد!</b>

    { frg-build-info }

    <b>🔓 وضعیت دسترسی:</b>
    <blockquote>
    • <b>حالت</b>: { access-mode }
    • <b>پرداخت‌ها</b>: { $payments_allowed ->
    [0] ممنوع
    *[1] مجاز
    }
    • <b>ثبت‌نام</b>: { $registration_allowed ->
    [0] ممنوع
    *[1] مجاز
    }
    </blockquote>

    .shutdown =
    #BotShutdownEvent

    <b>🔅 رویداد: ربات متوقف شد!</b>

    { frg-build-info }

    <blockquote>
    • <b>آپ‌تایم</b>: { $uptime }
    </blockquote>

    .update =
    #BotUpdateEvent

    <b>🔅 رویداد: به‌روزرسانی Remnashop شناسایی شد!</b>

    <b>📑 نسخه‌ها:</b>
    <blockquote>
    • <b>فعلی</b>: { $local_version }
    • <b>آخرین</b>: { $remote_version }
    </blockquote>


event-user =
    .registered =
    #UserRegisteredEvent

    <b>🔅 رویداد: کاربر جدید!</b>

    { hdr-user }
    { frg-user-info }

    { $referrer_telegram_id ->
    [0] { empty }
    *[HAS]
    <b>🤝 دعوت‌کننده:</b>
    <blockquote>
    • <b>ID</b>: <code>{ NUMBER($referrer_telegram_id, useGrouping: 0) }</code>
    • <b>نام</b>: { $referrer_name } { $referrer_username -> 
        [0] { empty }
        *[HAS] (<a href="tg://user?id={ $referrer_telegram_id }">@{ $referrer_username }</a>)
    }
    </blockquote>
    }

    .first-connected =
    #UserFirstConnectionEvent

    <b>🔅 رویداد: اولین اتصال کاربر!</b>

    { hdr-user }
    { frg-user-info }

    { hdr-subscription }
    { frg-subscription-details }

    .device-added =
    #UserDeviceAddedEvent

    <b>🔅 رویداد: کاربر دستگاه جدیدی اضافه کرد!</b>

    { hdr-user }
    { frg-user-info }

    { hdr-hwid }
    { frg-user-hwid }

    .device-deleted =
    #UserDeviceDeletedEvent

    <b>🔅 رویداد: کاربر دستگاهی را حذف کرد!</b>

    { hdr-user }
    { frg-user-info }

    { hdr-hwid }
    { frg-user-hwid }
    

event-subscription =
    .trial =
    #SubscriptionTrialEvent

    <b>🔅 رویداد: دریافت اشتراک آزمایشی!</b>

    { hdr-user }
    { frg-user-info }
    
    { hdr-plan }
    { frg-plan-snapshot }
    
    .new =
    #SubscriptionNewEvent

    <b>🔅 رویداد: خرید اشتراک!</b>

    { hdr-payment }
    { frg-payment-info }

    { hdr-user }
    { frg-user-info }

    { hdr-plan }
    { frg-plan-snapshot }

    .renew =
    #SubscriptionRenewEvent

    <b>🔅 رویداد: تمدید اشتراک!</b>
    
    { hdr-payment }
    { frg-payment-info }

    { hdr-user }
    { frg-user-info }

    { hdr-plan }
    { frg-plan-snapshot }

    .change =
    #SubscriptionChangeEvent

    <b>🔅 رویداد: تغییر اشتراک!</b>

    { hdr-payment }
    { frg-payment-info }

    { hdr-user }
    { frg-user-info }

    { hdr-plan }
    { frg-plan-snapshot-comparison }

    .expiring =
    { $is_trial ->
    [0]
    <b>⚠️ توجه! اشتراک شما تا { unit-day } دیگر پایان می‌یابد.</b>
    
    آن را از قبل تمدید کنید تا دسترسی به سرویس را از دست ندهید! 
    *[1]
    <b>⚠️ توجه! نسخه آزمایشی رایگان شما تا { unit-day } دیگر پایان می‌یابد.</b>

    برای حفظ دسترسی به سرویس، اشتراک تهیه کنید! 
    }

    .expired =
    <b>⛔ توجه! دسترسی متوقف شده است — VPN کار نمی‌کند.</b>

    { $is_trial ->
    [0] اشتراک شما منقضی شده است، آن را تمدید کنید تا بتوانید به استفاده از VPN ادامه دهید!
    *[1] دوره آزمایشی رایگان شما تمام شده است. برای ادامه استفاده از سرویس، اشتراک تهیه کنید!
    }

    .expired-ago =
    <b>⛔ توجه! دسترسی متوقف شده است — VPN کار نمی‌کند.</b>

    { $is_trial ->
    [0] اشتراک شما { unit-day } پیش منقضی شده است، آن را تمدید کنید تا بتوانید به استفاده از سرویس ادامه دهید!
    *[1] دوره آزمایشی رایگان شما { unit-day } پیش تمام شد. برای ادامه استفاده از سرویس، اشتراک تهیه کنید!
    }

    .limited =
    <b>⛔ توجه! دسترسی متوقف شده است — VPN کار نمی‌کند.</b>

    ترافیک شما تمام شده است. { $is_trial ->
    [0] { $traffic_strategy ->
        [NO_RESET] اشتراک را تمدید کنید تا ترافیک بازنشانی شود و به استفاده از سرویس ادامه دهید!
        *[RESET] ترافیک در { $reset_time } بازیابی خواهد شد. همچنین می‌توانید با تمدید اشتراک، ترافیک را بازنشانی کنید.
        }
    *[1] { $traffic_strategy ->
        [NO_RESET] برای ادامه استفاده از سرویس، اشتراک تهیه کنید!
        *[RESET] ترافیک در { $reset_time } بازیابی خواهد شد. همچنین می‌توانید اشتراک تهیه کنید تا بدون محدودیت از سرویس استفاده کنید.
        }
    }

    .revoked =
    #SubscriptionRevokedEvent

    <b>🔅 رویداد: کاربر اشتراک را دوباره صادر کرد!</b>

    { hdr-user }
    { frg-user-info }

    { hdr-subscription }
    { frg-subscription-details }


event-node =
    .connection-lost =
    #NodeConnectionLostEvent
    
    <b>🔅 رویداد: اتصال با نود قطع شد!</b>

    { hdr-node }
    { frg-node-info }

    .connection-restored =
    #NodeConnectionRestoredEvent

    <b>🔅 رویداد: اتصال با نود برقرار شد!</b>

    { hdr-node }
    { frg-node-info }

    .traffic-reached =
    #NodeTrafficReachedEvent

    <b>🔅 رویداد: نود به آستانه سقف ترافیک رسید!</b>

    { hdr-node }
    { frg-node-info }


event-referral =
    .attached =
    <b>🎉 شما یک دوست را دعوت کردید!</b>
    
    <blockquote>
    کاربر <b>{ $name }</b> از طریق لینک دعوت شما پیوست! برای دریافت پاداش، مطمئن شوید که او یک اشتراک خریداری می‌کند.
    </blockquote>

    .reward =
    <b>💰 پاداش برای شما ثبت شد!</b>
    
    <blockquote>
    کاربر <b>{ $name }</b> پرداخت انجام داد. شما <b>{ $value } { $reward_type ->
    [POINTS] { $value -> 
        [one] امتیاز
        [few] امتیاز
        *[more] امتیاز 
        }

    <i>برای استفاده از امتیازها، به بخش «دعوت» در ربات بروید تا پاداش‌های در دسترس و روش‌های استفاده از آن‌ها را ببینید.</i>
    [EXTRA_DAYS] { $value } روز اضافه { $value -> 
        [one] روز
        [few] روز
        *[more] روز
        } </b> به اشتراک شما!
    *[OTHER] { $reward_type }
    }
    </blockquote>

    .reward-failed =
    <b>❌ نتوانستیم پاداش را بدهیم!</b>
    
    <blockquote>
    کاربر <b>{ $name }</b> پرداخت انجام داد، اما نتوانستیم پاداش شما را ثبت کنیم چون <b>شما اشتراک خریداری‌شده ندارید</b> که بتوان {$value} { $reward_type ->
    [POINTS] { $value -> 
        [one] امتیاز
        [few] امتیاز
        *[more] امتیاز 
        }
    [EXTRA_DAYS] اضافه { $value -> 
        [one] روز
        [few] روز
        *[more] روز
        }
    *[OTHER] { $reward_type }
    }.
    
    <i>اشتراک تهیه کنید تا برای دوستان دعوت‌شده پاداش بگیرید!</i>
    </blockquote>

event-remnashop-welcome =
    <b>💎 Remnashop v{ $version }</b>

    این پروژه تنها توسط یک <strike>توسعه‌دهنده</strike> برق‌کار ساخته و نگهداری می‌شود. چون این ربات کاملاً رایگان و متن‌باز است، فقط با حمایت شما زنده مانده است.

    ⭐ <i>در <a href="{ $repository }">GitHub</a> ستاره بگذارید و به <a href="https://t.me/@remna_shop">جامعه</a> ما بپیوندید.</i>