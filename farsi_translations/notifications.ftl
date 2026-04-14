ntf-error =
    .unknown = ⚠️ <i>خطایی رخ داد.</i>
    .permission-denied = ⚠️ <i>شما دسترسی کافی ندارید.</i>
    .log-not-found = ⚠️ <i>فایل لاگ پیدا نشد.</i>
    .logs-disabled = ⚠️ <i>ثبت لاگ در فایل غیرفعال است.</i>
    
    .lost-context = ⚠️ <i>خطایی رخ داد. گفت‌وگو را با دستور /start دوباره آغاز کنید.</i>
    .lost-context-restart = ⚠️ <i>خطایی رخ داد. گفت‌وگو دوباره آغاز شد.</i>

ntf-common =
    .trial-unavailable = ⚠️ <i>اشتراک آزمایشی موقتاً در دسترس نیست.</i>
    .throttling = ⚠️ <i>درخواست‌های زیادی ارسال کرده‌اید. لطفاً صبر کنید.</i>
    .double-click-confirm = ⚠️ <i>برای تأیید این کار، دوباره بزنید.</i>
    .squads-empty = ⚠️ <i>اسکوادی پیدا نشد. وجود آن‌ها را در پنل بررسی کنید.</i>

    .withdraw-points = ❌ <i>امتیاز کافی برای انجام تبدیل ندارید.</i>
    .internal-squads-empty = ❌ <i>حداقل یک اسکواد داخلی انتخاب کنید.</i>

    .invalid-value = ❌ <i>مقدار نامعتبر است.</i>
    .value-updated = ✅ <i>پارامتر با موفقیت به‌روزرسانی شد.</i>

    .plan-not-found = ❌ <i>طرح پیدا نشد یا در دسترس نیست.</i>

    .connect-not-available =
    ⚠️ { $status ->
    [LIMITED]
    شما همه حجم ترافیکِ در دسترس را مصرف کرده‌اید. { $is_trial ->
    [0] { $traffic_strategy ->
        [NO_RESET] اشتراک را تمدید کنید تا ترافیک بازنشانی شود و به استفاده از سرویس ادامه دهید!
        *[RESET] ترافیک در { $reset_time } بازیابی خواهد شد. همچنین می‌توانید اشتراک را تمدید کنید تا ترافیک بازنشانی شود.
        }
    *[1] { $traffic_strategy ->
        [NO_RESET] برای ادامه استفاده از سرویس، اشتراک تهیه کنید!
        *[RESET] ترافیک در { $reset_time } بازیابی خواهد شد. همچنین می‌توانید اشتراک تهیه کنید تا بدون محدودیت از سرویس استفاده کنید.
        }
    }
    [EXPIRED]  
    { $is_trial ->
    [0] مدت اعتبار اشتراک شما تمام شده است. اشتراک را تمدید کنید یا یکی جدید تهیه کنید.
    *[1] دوره آزمایشی رایگان تمام شده است. برای ادامه استفاده از سرویس، اشتراک تهیه کنید.
    }
    *[OTHER] هنگام بررسی وضعیت خطایی رخ داد یا اشتراک غیرفعال شده است. با پشتیبانی تماس بگیرید.
    }
    
ntf-command =
    .paysupport = 💸 <b>برای درخواست بازپرداخت، با پشتیبانی تماس بگیرید.</b>
    .rules = ⚠️ <b>لطفاً پیش از استفاده از سرویس، <a href="{ $url }">شرایط استفاده</a> را بخوانید.</b>
    .help = 🆘 <b>برای ارتباط با پشتیبانی، دکمه زیر را بزنید.</b>

ntf-requirement =
    .channel-join-required = ❇️ در کانال ما عضو شوید و <b>روزهای رایگان، پیشنهادها و خبرها</b> را دریافت کنید. پس از عضویت، روی «تأیید» بزنید.
    .channel-join-required-left = ⚠️ شما از کانال خارج شدید. برای ادامه استفاده از ربات، عضو شوید.
    .rules-accept-required = ⚠️ <b>پیش از استفاده از سرویس، <a href="{ $url }">شرایط استفاده</a> را بخوانید و بپذیرید.</b>
    .channel-join-error = ⚠️ ما عضویت شما در کانال را نمی‌بینیم. عضویت را بررسی کنید و دوباره تلاش کنید.
    
ntf-user =
    .not-found = <i>❌ کاربر پیدا نشد.</i>
    .transactions-empty = ❌ <i>فهرست تراکنش‌ها خالی است.</i>
    .subscription-empty = ❌ <i>اشتراک فعال پیدا نشد.</i>
    .subscription-deleted = ✅ <i>اشتراک با موفقیت حذف شد.</i>
    .plans-empty = ❌ <i>هیچ طرحی در دسترس نیست.</i>
    .devices-empty = ❌ <i>فهرست دستگاه‌ها خالی است.</i>
    .allowed-plans-empty = ❌ <i>هیچ طرحی برای اعطای دسترسی وجود ندارد.</i>
    .message-success = ✅ <i>پیام با موفقیت ارسال شد.</i>
    .message-failed = ❌ <i>ارسال پیام ناموفق بود.</i>

    .sync-already = ✅ <i>داده‌های اشتراک یکسان هستند.</i>
    .sync-missing-data = ⚠️ <i>همگام‌سازی ممکن نیست. داده‌های اشتراک در پنل و ربات موجود نیست.</i>
    .sync-success = ✅ <i>همگام‌سازی اشتراک انجام شد.</i>

    .invalid-expire-time = ❌ <i>امکان‌پذیر نیست { $operation ->
    [ADD] تمدید
    *[SUB] کوتاه کردن
    } مدت اشتراک به تعداد روزهای مشخص‌شده ممکن نیست.</i>

    .invalid-points = ❌ <i>امکان‌پذیر نیست { $operation ->
    [ADD] افزودن
    *[SUB] کم کردن
    } تعداد امتیاز مشخص‌شده ممکن نیست.</i>

ntf-access =
    .maintenance = 🚧 <i>ربات در حال نگهداری است. بعداً دوباره امتحان کنید.</i>
    .registration-disabled = ❌ <i>ثبت‌نام کاربران جدید غیرفعال است.</i>
    .registration-invite-only = ❌ <i>ثبت‌نام فقط با دعوت ممکن است.</i>
    .payments-disabled = 🚧 <i>پرداخت‌ها موقتاً در دسترس نیستند! پس از برقراری دوباره، اعلان دریافت می‌کنید.</i>
    .payments-restored = ❇️ <i>پرداخت‌ها دوباره برقرار شدند! حالا می‌توانید اشتراک بخرید یا تمدید کنید. ممنون از صبرتان.</i>

ntf-plan =
    .not-file = ⚠️ <i>طرح‌ها را به صورت فایل json ارسال کنید.</i>
    .import-failed = ❌ <i>وارد کردن ناموفق بود.</i>
    .import-success = ✅ <i>با موفقیت وارد شد.</i>
    .export-plans_not_selected =  ❌ <i>حداقل یک طرح را برای خروجی انتخاب کنید.</i>
    .export-failed = ❌ <i>خروجی گرفتن ناموفق بود.</i>
    .export-success = ✅ <i>طرح‌های انتخاب‌شده خروجی گرفته شدند.</i>
    .trial-single-duration = ❌ <i>طرح آزمایشی فقط می‌تواند یک مدت داشته باشد.</i>
    .duration-already-exists = ❌ <i>چنین مدتی از قبل وجود دارد.</i>
    .name-already-exists = ❌ <i>طرحی با این نام از قبل وجود دارد.</i>
    .user-already-allowed = ❌ <i>شناسه کاربر از قبل اضافه شده است.</i>

    .updated = ✅ <i>طرح با موفقیت به‌روزرسانی شد.</i>
    .created = ✅ <i>طرح با موفقیت ایجاد شد.</i>
    .deleted = ✅ <i>طرح با موفقیت حذف شد.</i>

ntf-gateway =
    .not-configured = ❌ <i>درگاه پرداخت تنظیم نشده است.</i>
    .not-configurable = ❌ <i>درگاه پرداخت هیچ تنظیماتی ندارد.</i>

    .test-payment-created = ✅ <i><a href="{ $url }">پرداخت آزمایشی</a> با موفقیت ایجاد شد.</i>
    .test-payment-created-no-url = ✅ <i>تراکنش آزمایشی ایجاد شد. شناسه پرداخت: <code>{ $payment_id }</code></i>
    .test-payment-error = ❌ <i>در ایجاد پرداخت آزمایشی خطا رخ داد.</i>
    .test-payment-confirmed = ✅ <i>پرداخت آزمایشی با موفقیت پردازش شد.</i>

ntf-subscription =
    .plans-unavailable = ❌ <i>در حال حاضر هیچ طرحی در دسترس نیست.</i>
    .gateways-unavailable = ❌ <i>در حال حاضر هیچ درگاه پرداختی در دسترس نیست.</i>
    .renew-plan-unavailable = ❌ <i>طرح فعلی قدیمی شده و برای تمدید در دسترس نیست.</i>
    .payment-creation-failed = ❌ <i>در ساخت پرداخت خطا رخ داد. بعداً دوباره امتحان کنید.</i>

    .manual-invalid-method = ❌ <i>روش پرداخت نامعتبر است. لطفاً خرید را از ابتدا شروع کنید.</i>
    .manual-not-required = ❌ <i>برای این روش پرداخت نیازی به ارسال رسید نیست.</i>
    .manual-invalid-payment-id = ❌ <i>شناسه پرداخت معتبر نیست. دوباره تلاش کنید.</i>
    .manual-pending-not-found = ❌ <i>پرداخت در انتظار برای شما پیدا نشد.</i>
    .manual-already-processed = ⚠️ <i>این پرداخت قبلاً پردازش شده است.</i>
    .manual-receipt-format = ❌ <i>رسید را به صورت متن یا تصویر ارسال کنید.</i>
    .manual-receipt-sent = ✅ <i>رسید ارسال شد و در انتظار بررسی است.</i>
    .manual-rejected = ❌ <i>پرداخت رد شد. رسید را دوباره ارسال کنید یا با پشتیبانی تماس بگیرید.</i>
    .manual-admin-review =
        🧾 <b>درخواست جدید کارت‌به‌کارت</b>

        <b>کاربر:</b> { $user_name }
        <b>Username:</b> { $username }
        <b>Telegram ID:</b> <code>{ $telegram_id }</code>
        <b>Payment ID:</b> <code>{ $payment_id }</code>

        <b>رسید:</b>
        { $receipt }

ntf-broadcast =
    .message = { $content }
    .text-too-long = ❌ حداکثر تعداد نویسه‌ها ({ $max_limit }) رد شد.
    .list-empty = ❌ <i>فهرست ارسال‌ها خالی است.</i>
    .plans-unavailable = ❌ <i>هیچ طرحی در دسترس نیست.</i>
    .audience-unavailable = ❌ <i>برای مخاطب انتخاب‌شده کاربری وجود ندارد.</i>
    .content-empty = ❌ <i>محتوا خالی است.</i>
    .content-saved = ✅ <i>محتوا با موفقیت ذخیره شد.</i>

    .not-cancelable = ❌ <i>لغو این ارسال ممکن نیست.</i>
    .canceled = ✅ <i>ارسال با موفقیت لغو شد.</i>
    .deleting = ⚠️ <i>حذف پیام‌های ارسال‌شده در حال انجام است.</i>
    .already-deleted = ❌ <i>ارسال از قبل حذف شده یا در حال حذف است.</i>

    .deleted-success =
        ✅ ارسال <code>{ $task_id }</code> با موفقیت حذف شد.

        <blockquote>
        • <b>کل پیام‌ها</b>: { $total_count }
        • <b>حذف‌شده</b>: { $deleted_count }
        • <b>ناموفق در حذف</b>: { $failed_count }
        </blockquote>

ntf-importer =
    .not-file = ⚠️ <i>پایگاه داده را به صورت فایل ارسال کنید.</i>
    .db-failed = ❌ <i>در خروجی گرفتن کاربران از پایگاه داده خطا رخ داد.</i>
    .users-empty = ❌ <i>فهرست کاربران در پایگاه داده خالی است.</i>

    .started = ✅ <i>وارد کردن آغاز شد. لطفاً تا پایان صبر کنید...</i>
    .already-running = ⚠️ <i>وارد کردن از قبل در حال اجراست. لطفاً صبر کنید.</i>

ntf-sync =
    .started = ✅ <i>همگام‌سازی آغاز شد. لطفاً تا پایان صبر کنید...</i>
    .users-not-found = ❌ <i>کاربری برای همگام‌سازی پیدا نشد.</i>
    .already-running = ⚠️ <i>همگام‌سازی از قبل در حال اجراست. لطفاً صبر کنید.</i>

ntf-menu-editor =
    .button-saved = ✅ <i>دکمه با موفقیت ذخیره شد.</i>
    .invalid-payload = ❌ <i>فرمت URL برای payload نامعتبر است.</i>

ntf-devices =
    .deleted = ✅ <i>دستگاه حذف شد.</i>
    .all-deleted = ✅ <i>همه دستگاه‌ها حذف شدند.</i>
    .reissued = ✅ <i>اشتراک با موفقیت دوباره صادر شد.</i>
