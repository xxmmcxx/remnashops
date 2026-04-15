btn-back = 
    .general = ⬅️ بازگشت
    .menu = ↩️ منوی اصلی
    .menu-return = ↩️ بازگشت به منوی اصلی
    .dashboard = ↩️ بازگشت به پنل مدیریت

btn-common =
    .notification-close = ❌ بستن
    .devices-empty = ⚠️ شما هیچ دستگاه متصل‌شده‌ای ندارید
    .cancel = انصراف

    .squad-choice = { $selected -> 
    [1] 🔘
    *[0] ⚪
    } { $name }

    .duration = ⌛ { $value ->
    [0] { unlimited }
    *[other] { unit-day }
    }

btn-devices =
    .delete-all = 🗑 حذف همه دستگاه‌ها
    .reissue = 🔄 صدور دوباره اشتراک
    .confirm-delete = ✅ بله، حذف کن
    .confirm-reissue = ✅ بله، بازنشانی کن
    .cancel-reissue = ❌ نه

btn-remnashop-info =
    .release-latest = 👀 مشاهده
    .how-upgrade = ❓ چگونه به‌روزرسانی کنیم
    .github = ⭐ GitHub
    .telegram = 👪 Telegram
    .donate = 💰 حمایت از توسعه‌دهنده
    .guide = ❓ راهنما

btn-requirement =
    .rules-accept = ✅ پذیرش قوانین
    .channel-join = ❤️ رفتن به کانال
    .channel-confirm = ✅ تأیید

btn-menu =
    .trial = 🎁 رایگان امتحان کن
    .connect = 🚀 اتصال
    .devices = 📱 دستگاه‌ها
    .subscription = 💳 اشتراک
    .my-subs = 📦 اشتراک های من
    .my-subs-copy-url = 📋 کپی لینک
    .invite = 👥 دعوت
    .support = 🆘 پشتیبانی
    .dashboard = 🛠 پنل مدیریت

    .connect-not-available =
    ⚠️ { $status -> 
    [LIMITED] سقف ترافیک رد شده است
    [EXPIRED] مدت اعتبار تمام شده است
    *[OTHER] اشتراک شما کار نمی‌کند
    } ⚠️

btn-invite =
    .about = ❓ جزئیات پاداش
    .copy = 📋 کپی لینک
    .send = 📩 دعوت
    .qr = 🧾 کد QR
    .withdraw-points = 💎 تبدیل امتیازها

btn-dashboard =
    .statistics = 📊 آمار
    .users = 👥 کاربران
    .broadcast = 📢 ارسال همگانی
    .promocodes = 🎟 کدهای تخفیف
    .access = 🔓 حالت دسترسی
    .remnawave = 🌊 RemnaWave
    .remnashop = 🛍 RemnaShop
    .importer = 📥 وارد کردن کاربران

btn-statistics =
    .users = 👥 کاربران
    .subscriptions = 💳 اشتراک‌ها
    .transactions = 🧾 تراکنش‌ها
    .promocodes = 🎁 کدهای تخفیف
    .referrals = 👪 معرفی‌شدگان

    .subscription-page =
    { $page ->
        [0] { $is_current ->
            [1] [ آمار کلی ]
            *[0] آمار کلی
        }
        *[other] { $is_current ->
            [1] [ { $plan_name } ]
            *[0] { $plan_name }
        }
    }

    .transaction-page =
    { $page ->
        [0] { $is_current ->
            [1] [ آمار کلی ]
            *[0] آمار کلی
        }
        *[other] { $is_current ->
            [1] [ { gateway-type } ]
            *[0] { gateway-type }
        }
    }

btn-users =
    .search = 🔍 جستجوی کاربر
    .recent-registered = 🆕 آخرین ثبت‌نام‌شده‌ها
    .recent-activity = 📝 آخرین تعامل‌کنندگان
    .blacklist = 🚫 فهرست سیاه
    .unblock-all = 🔓 رفع مسدودیت از همه

btn-user =
    .discount = 💸 تخفیف
    .discount-personal = 👤 تخفیف شخصی
    .discount-purchase = 🎟 برای خرید بعدی
    .points = 💎 امتیازها
    .statistics = 📊 آمار
    .referrals = 👪 معرفی‌شدگان
    .message = 📩 پیام
    .role = 👮‍♂️ نقش
    .transactions = 🧾 تراکنش‌ها
    .give-access = 🔑 دسترسی به طرح‌ها
    .current-subscription = 💳 اشتراک فعلی
    .subscription-traffic-limit = 🌐 سقف ترافیک
    .subscription-device-limit = 📱 سقف دستگاه
    .subscription-expire-time = ⏳ زمان انقضا
    .subscription-squads = 🔗 اسکوادها
    .subscription-traffic-reset = 🔄 بازنشانی ترافیک
    .subscription-devices = 🧾 فهرست دستگاه‌ها
    .subscription-url = 📋 کپی لینک
    .subscription-set = ✅ تنظیم اشتراک
    .subscription-delete = ❌ حذف
    .message-preview = 👀 پیش‌نمایش
    .message-confirm = ✅ ارسال
    .sync = 🌀 همگام‌سازی
    .sync-remnawave = 🌊 استفاده از داده‌های Remnawave
    .sync-remnashop = 🛍 استفاده از داده‌های Remnashop
    .give-subscription = 🎁 اعطای اشتراک
    .subscription-internal-squads = ⏺️ اسکوادهای داخلی
    .subscription-external-squads = ⏹️ اسکواد خارجی

    .allowed-plan-choice = { $selected ->
    [1] 🔘
    *[0] ⚪
    } { $plan_name }

    .subscription-active-toggle = { $is_active ->
    [1] 🔴 خاموش کردن
    *[0] 🟢 روشن کردن
    }

    .transaction = { $status ->
    [PENDING] 🕓
    [COMPLETED] ✅
    [CANCELED] ❌
    [REFUNDED] 💸
    [FAILED] ⚠️
    *[OTHER] { $status }
    } { $created_at }
    
    .trial-toggle = { $is_trial_available ->
    [1] 🧪 نسخه آزمایشی: فعال
    *[0] 🧪 نسخه آزمایشی: غیرفعال
    }

    .block = { $is_blocked ->
    [1] 🔓 باز کردن
    *[0] 🔒 مسدود کردن
    }

btn-broadcast =
    .list = 📄 فهرست همه ارسال‌ها
    .all = 👥 همه
    .plan = 📦 بر اساس طرح
    .subscribed = ✅ دارای اشتراک
    .unsubscribed = ❌ بدون اشتراک
    .expired = ⌛ منقضی‌شده‌ها
    .trial = ✳️ با نسخه آزمایشی
    .content = ✉️ ویرایش محتوا
    .buttons = ✳️ ویرایش دکمه‌ها
    .preview = 👀 پیش‌نمایش
    .confirm = ✅ آغاز ارسال
    .refresh = 🔄 به‌روزرسانی داده‌ها
    .viewing = 👀 مشاهده
    .cancel = ⛔ توقف ارسال
    .delete = ❌ حذف ارسال‌شده

    .plan-title = { $is_active ->
    [1] 🟢
    *[0] 🔴 
    } { $name }
    
    .button-choice = { $selected ->
    [1] 🔘
    *[0] ⚪
    }
    
    .title = { $status ->
    [PROCESSING] ⏳
    [COMPLETED] ✅
    [CANCELED] ⛔
    [DELETED] ❌
    [ERROR] ⚠️
    *[OTHER] { $status }
    } { $created_at }
    
btn-goto =
    .subscription = 💳 خرید اشتراک
    .promocode = 🎟 فعال‌سازی کد تخفیف
    .invite = 👥 دعوت
    .subscription-renew = 🔄 تمدید اشتراک
    .user-profile = 👤 رفتن به کاربر
    .referrer-profile = 🤝 رفتن به دعوت‌کننده
    .contact-support = 📩 رفتن به پشتیبانی

btn-promocodes =
    .list = 📃 فهرست کدهای تخفیف
    .search = 🔍 جستجوی کد تخفیف
    .create = 🆕 ایجاد
    .delete = 🗑️ حذف
    .edit = ✏️ ویرایش

btn-access =
    .mode = { access-mode }
    .conditions = ⚙️ شرایط دسترسی
    .rules = ✳️ پذیرش قوانین
    .channel = ❇️ عضویت در کانال

    .payments-toggle = { $enabled ->
    [1] 🔘
    *[0] ⚪
    } پرداخت‌ها

    .registration-toggle = { $enabled ->
    [1] 🔘
    *[0] ⚪
    } ثبت‌نام

    .condition-toggle = { $enabled ->
    [1] 🔘 روشن
    *[0] ⚪ خاموش
    }

btn-remnashop =
    .admins = 👮‍♂️ مدیران
    .gateways = 🌐 درگاه‌های پرداخت
    .referral = 👥 سیستم ارجاع
    .advertising = 🎯 تبلیغات
    .plans = 📦 طرح‌ها
    .notifications = 🔔 اعلان‌ها
    .logs = 📄 گزارش‌ها
    .menu-editor = 🎛 دکمه‌های اضافی
    .banner = 🖼️ بنر سراسری
    .qr-background = 🖼️ پس‌زمینه QR

btn-global-banner =
    .toggle = { $enabled ->
    [1] 🟢 بنر روشن
    *[0] 🔴 بنر خاموش
    }
    .reset = ♻️ بازنشانی بنر

btn-qr-background =
    .toggle = { $enabled ->
    [1] 🟢 پس‌زمینه روشن
    *[0] 🔴 پس‌زمینه خاموش
    }
    .reset = ♻️ بازنشانی پس‌زمینه

btn-menu-editor =
    .text = 🏷️ متن
    .availability = ✴️ دسترسی
    .type = 🔖 نوع
    .payload = 📄 داده‌ها
    .confirm = ✅ ذخیره

    .button = { $is_active -> 
        [1] 🟢 
        *[0] 🔴 
    } { $text }
    
    .active = { $is_active -> 
        [1] 🟢 فعال
        *[0] 🔴 غیرفعال
    }
    
btn-gateway =
    .title = { gateway-type }
    .setting = { $field }
    .webhook-copy = 📋 کپی وبهوک
    .test = 🐞 تست
    .default-currency = 💸 ارز پیش‌فرض
    .manage-currencies = 💱 مدیریت ارزها
    .placement = 🔢 تغییر جایگاه

    .active = { $is_active ->
    [1] 🟢 روشن
    *[0] 🔴 خاموش
    }

    .default-currency-choice = { $enabled -> 
    [1] 🔘
    *[0] ⚪
    } { $symbol } { $currency }

btn-referral =
    .level = 🔢 سطح
    .reward-type = 🎀 نوع پاداش
    .accrual-strategy = 📍 شرط محاسبه
    .reward-strategy = ⚖️ شیوه محاسبه
    .reward = 🎁 پاداش
    
    .enable = { $is_enable -> 
        [1] 🟢 فعال
        *[0] 🔴 غیرفعال
    }

    .level-choice = { $type -> 
    [1] 1️⃣
    [2] 2️⃣
    [3] 3️⃣
    *[OTHER] { $type }
    }

    .reward-choice = { $type -> 
    [POINTS] 💎 امتیاز
    [EXTRA_DAYS] ⏳ روز
    *[OTHER] { $type }
    }

    .accrual-strategy-choice = { $type -> 
    [ON_FIRST_PAYMENT] 💳 اولین پرداخت
    [ON_EACH_PAYMENT] 💸 هر پرداخت
    *[OTHER] { $type }
    }

    .reward-strategy-choice = { $type -> 
    [AMOUNT] 🔸 مبلغ ثابت
    [PERCENT] 🔹 درصدی
    *[OTHER] { $type }
    }

btn-notifications =
    .user = 👥 کاربران
    .system = ⚙️ سیستمی
    
    .user-choice = { $enabled ->
    [1] 🔘
    *[0] ⚪
    } { $type ->
    [EXPIRES_IN_3_DAYS] اشتراک تا ۳ روز دیگر منقضی می‌شود
    [EXPIRES_IN_2_DAYS] اشتراک تا ۲ روز دیگر منقضی می‌شود
    [EXPIRES_IN_1_DAY] اشتراک تا ۱ روز دیگر منقضی می‌شود
    [EXPIRED] اشتراک منقضی شده است
    [EXPIRED_1_DAY_AGO] اشتراک ۱ روز پیش منقضی شد
    [LIMITED] ترافیک تمام شده است
    [REFERRAL_ATTACHED] ارجاع ثبت شد
    [REFERRAL_REWARD_RECEIVED] پاداش ارجاع دریافت شد
    *[OTHER] { $type }
    }

    .system-choice = { $enabled -> 
    [1] 🔘
    *[0] ⚪
    } { $type ->
    [BOT_LIFECYCLE] چرخه عمر ربات
    [BOT_UPDATE] به‌روزرسانی‌های ربات
    [USER_REGISTERED] ثبت‌نام کاربر
    [SUBSCRIPTION] ثبت اشتراک
    [PROMOCODE_ACTIVATED] فعال‌سازی کد تخفیف
    [TRIAL_ACTIVATED] فعال‌سازی نسخه آزمایشی
    [NODE_STATUS_CHANGED] وضعیت نود
    [NODE_TRAFFIC_REACHED] رسیدن ترافیک نود
    [USER_FIRST_CONNECTION] اولین اتصال کاربر
    [USER_DEVICES_UPDATED] به‌روزرسانی دستگاه‌های کاربر
    [USER_REVOKED_SUBSCRIPTION] بازنشانی اشتراک کاربر
    *[OTHER] { $type }
    }

btn-plans =
    .statistics = 📊 آمار
    .create = 🆕 ایجاد
    .save = ✅ ذخیره
    .create = ✅ ایجاد طرح
    .delete = ❌ حذف
    .name = 🏷️ نام
    .prefix = 🧬 پیشوند
    .description = 💬 توضیحات
    .description-remove = ❌ حذف توضیحات فعلی
    .tag = 📌 برچسب
    .tag-remove = ❌ حذف برچسب فعلی
    .type = 🔖 نوع
    .availability = ✴️ دسترسی
    .durations-prices = ⏳ مدت‌ها و 💰 قیمت‌ها
    .traffic = 🌐 ترافیک
    .devices = 📱 دستگاه‌ها
    .allowed = 👥 کاربران مجاز
    .squads = 🔗 اسکوادها
    .internal-squads = ⏺️ اسکوادهای داخلی
    .external-squads = ⏹️ اسکواد خارجی
    .allowed-user = { $id }
    .duration-add = 🆕 افزودن مدت
    .price-choice = 💸 { $price } { $currency }
    .export = 📤 خروجی
    .import = 📥 وارد کردن
    .exporting = 📤 در حال خروجی گرفتن
    .importing = 📥 در حال وارد کردن
    .url = 📋 کپی لینک طرح

    .trial = { $is_trial ->
    [1] 🔘
    *[0] ⚪
    } نسخه آزمایشی 

    .export-choice = { $selected ->
    [1] 🔘
    *[0] ⚪
    } { $name }

    .title = { $is_active ->
    [1] 🟢
    *[0] 🔴 
    } { $name }

    .active = { $is_active -> 
    [1] 🟢 روشن
    *[0] 🔴 خاموش
    }
    
    .type-choice = { $type -> 
    [TRAFFIC] 🌐 ترافیک
    [DEVICES] 📱 دستگاه‌ها
    [BOTH] 🔗 ترافیک + دستگاه
    [UNLIMITED] ♾️ نامحدود
    *[OTHER] { $type }
    }

    .availability-choice = { $type -> 
    [ALL] 🌍 برای همه
    [NEW] 🌱 برای کاربران جدید
    [EXISTING] 👥 برای مشتریان
    [INVITED] ✉️ برای دعوت‌شده‌ها
    [ALLOWED] 🔐 برای مجازها
    [LINK] 🔗 از طریق لینک
    *[OTHER] { $type }
    }

    .traffic-strategy-choice = { $selected ->
    [1] 🔘 { traffic-strategy }
    *[0] ⚪ { traffic-strategy }
    }

    
btn-remnawave =
    .users = 👥 کاربران
    .hosts = 🌐 هاست‌ها
    .nodes = 🖥️ نودها
    .inbounds = 🔌 این‌باندها

btn-importer =
    .from-xui = 💩 وارد کردن از پنل 3X-UI
    .from-xui-shop = 🛒 ربات 3xui-shop
    .sync = 🌀 آغاز همگام‌سازی
    .squads = 🔗 اسکوادهای داخلی
    .import-all = ✅ وارد کردن همه
    .import-active = ❇️ وارد کردن فعال‌ها

btn-subscription =
    .plan = 💳 رفتن به ثبت اشتراک
    .new = 💸 خرید اشتراک
    .renew = 🔄 تمدید
    .change = 🔃 تغییر
    .promocode = 🎟 فعال‌سازی کد تخفیف
    .payment-method = { gateway-type } | { $final_amount ->
    [0] 🎁
    *[HAS] { $final_amount }{ $currency }
    }
    .pay = 💳 پرداخت
    .get = 🎁 دریافت رایگان
    .send-receipt = 🧾 ارسال رسید
    .back-plans = ⬅️ بازگشت به انتخاب طرح
    .back-duration = ⬅️ تغییر مدت
    .back-payment-method = ⬅️ تغییر روش پرداخت
    .connect = 🚀 اتصال
    .raw-configs = 📄 نمایش کانفیگ های خام

    .duration = { $period } | { $final_amount -> 
    [0] 🎁
    *[HAS] { $final_amount }{ $currency }
    }

btn-promocode =
    .code = 🏷️ کد
    .type = 🔖 نوع پاداش
    .availability = ✴️ دسترسی
    .reward = 🎁 پاداش
    .lifetime = ⌛ مدت اعتبار
    .allowed = 👥 کاربران مجاز
    .confirm = ✅ تأیید
    
    .active = { $is_active -> 
    [1] 🟢
    *[0] 🔴
    } وضعیت

btn-manual-payment =
    .approve = ✅ تایید
    .reject = ❌ رد