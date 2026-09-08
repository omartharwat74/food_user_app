// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق توصيل الطعام';

  @override
  String get settingsUpdatedSuccess => 'تم تحديث الإعدادات بنجاح';

  @override
  String get deleteAccountSuccess => 'تم حذف الحساب بنجاح';

  @override
  String get changeAppLanguageTitle => 'تغيير لغة التطبيق';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get generalSettingsTitle => 'الإعدادات العامة';

  @override
  String get changeAppLanguage => 'تغيير لغة التطبيق';

  @override
  String get notificationsControl => 'التحكم في الاشعارات';

  @override
  String get notificationsTitle => 'الاشعارات';

  @override
  String get notificationsEmptyTitle => 'لا يوجد اشعارات حتى الآن';

  @override
  String get notificationsEmptyMessage => 'ستظهر هنا تحديثات الطلبات والعروض.';

  @override
  String get notificationOrderTitle => 'تحديث الطلب';

  @override
  String get notificationOrderMessage => 'طلبك قيد التحضير وسيصل إليك قريباً.';

  @override
  String get notificationOfferTitle => 'عرض جديد';

  @override
  String get notificationOfferMessage => 'وفر في طلبك القادم مع عرض اليوم.';

  @override
  String get notificationSystemTitle => 'إشعار الحساب';

  @override
  String get notificationSystemMessage => 'تم تحديث إعدادات حسابك بنجاح.';

  @override
  String get notificationToday => 'اليوم';

  @override
  String get notificationYesterday => 'أمس';

  @override
  String get notificationTimeNow => 'الآن';

  @override
  String get notificationSampleTime => '٢:٣٠ م';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get arabicLanguage => 'عربي';

  @override
  String get englishLanguage => 'English';

  @override
  String get deleteAccountComingSoon => 'تدفق حذف الحساب قادم قريباً.';

  @override
  String get deleteAccountConfirmationTitle => 'حذف الحساب';

  @override
  String get deleteAccountConfirmationMessage =>
      'سيتم ربط تدفق حذف الحساب لاحقاً.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get loginTitle => 'تسجيل دخول !';

  @override
  String get loginSubtitle => 'مرحبا بعودتك مره اخرى سجل دخول الان !';

  @override
  String get loginEmailLabel => 'البريد الالكتروني';

  @override
  String get loginEmailHint => 'البريد الالكتروني';

  @override
  String get loginPasswordLabel => 'كلمة المرور';

  @override
  String get loginPasswordHint => 'كلمة المرور';

  @override
  String get loginForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginSubmit => 'تسجيل دخول';

  @override
  String get loginSubmitting => '…';

  @override
  String get loginNoAccount => 'ليس لديك حساب من قبل ؟ ';

  @override
  String get loginCreateAccount => 'إنشاء حساب';

  @override
  String get registerWelcomeTitle => 'مرحباً بك !';

  @override
  String get registerWelcomeSubtitle =>
      'انضم إلينا اليوم واستمتع بتجربة توصيل أسرع';

  @override
  String get registerUsernameLabel => 'اسم المستخدم';

  @override
  String get registerUsernameHint => 'اسم المستخدم';

  @override
  String get registerPhoneLabel => 'رقم الجوال';

  @override
  String get registerPhoneHint => 'رقم الجوال';

  @override
  String get registerEmailLabel => 'البريد الالكتروني';

  @override
  String get registerEmailHint => 'البريد الالكتروني';

  @override
  String get registerPasswordLabel => 'كلمة المرور';

  @override
  String get registerPasswordHint => 'كلمة المرور';

  @override
  String get registerConfirmPasswordLabel => 'تأكيد كلمه المرور';

  @override
  String get registerConfirmPasswordHint => 'تأكيد كلمه المرور';

  @override
  String get registerTermsPrefix => 'الموافقة على ';

  @override
  String get registerTermsLink => 'الشروط والاحكام';

  @override
  String get registerTermsError => 'يجب الموافقة على الشروط والاحكام';

  @override
  String get registerSubmit => 'إنشاء حساب';

  @override
  String get registerHasAccount => 'هل لديك حساب من قبل ؟ ';

  @override
  String get registerSignIn => 'تسجيل دخول';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور !';

  @override
  String get forgotPasswordSubtitle =>
      'قم بادخال البريد الالكتروني الخاص بك للتأكد من حسابك';

  @override
  String get forgotPasswordSubmit => 'تأكيد';

  @override
  String get resetPasswordTitle => 'إعادة تعيين كلمة المرور !';

  @override
  String get resetPasswordSubtitle =>
      'ادخل كلمة مرور جديدة لحماية جميع بياناتك';

  @override
  String get resetPasswordSubmit => 'تأكيد';

  @override
  String get otpTitle => 'كود التحقق';

  @override
  String get otpSubtitle =>
      'أدخل الكود المرسل إليك لتأكيد رقم الجوال والمتابعة.';

  @override
  String get otpVerify => 'تحقق';

  @override
  String otpTimerSeconds(int seconds) {
    return '$seconds ثانية';
  }

  @override
  String get otpResend => 'إعادة إرسال الكود ؟';

  @override
  String get otpResentSnackbar => 'تم إرسال الكود مرة أخرى';

  @override
  String get termsTitle => 'الشروط والاحكام';

  @override
  String get termsBody =>
      'هذه صفحة الشروط والاحكام الخاصة بالتطبيق. باستخدامك لهذا التطبيق، فإنك توافق على الالتزام بسياسات الاستخدام، واحترام قواعد المنصة، والحفاظ على سرية بيانات حسابك. سيتم تحديث هذه الصفحة لاحقاً بالمحتوى القانوني النهائي.';

  @override
  String get onboardingTitleLine1 => 'أكل أكتر، انتظار أقل …';

  @override
  String get onboardingTitleAccent => ' اطلب الآن';

  @override
  String get onboardingDescription =>
      'توصيل أسرع، خيارات أكتر، وتجربة استخدام مصممة\nعلشان راحتك في كل طلب';

  @override
  String get onboardingCta => 'أبدء الان';

  @override
  String get authEntryTitleAccent => 'طلب';

  @override
  String get authEntryTitleRest => ' اسرع ... خدمة افضل !';

  @override
  String get authEntrySubtitle =>
      'اختر طريقة التسجيل التي ترغب فيها واستمتع بأسرع خدمة توصيل';

  @override
  String get authContinueWithPhone => 'دخول عبر رقم الجوال';

  @override
  String get authContinueWithApple => 'دخول عن طريق Apple';

  @override
  String get authContinueWithGoogle => 'دخول عن طريق Google';

  @override
  String get authContinueWithFacebook => 'دخول عن طريق Facebook';

  @override
  String get authPhoneTitle => 'رقم الجوال';

  @override
  String get authPhoneSubtitle =>
      'أدخل رقم الجوال الخاص بك لإتمام عملية التسجيل';

  @override
  String get authOtpSubtitle => 'أدخل الكود المرسل إليك للتأكد من رقم جوالك .';

  @override
  String get completeProfileTitle => 'استكمال بياناتك !';

  @override
  String get completeProfileSubtitle =>
      'انضم إلينا اليوم واستمتع بأسرع تجربة توصيل .';

  @override
  String get firstNameLabel => 'الاسم الاول';

  @override
  String get firstNameHint => 'الاسم الاول';

  @override
  String get lastNameLabel => 'الاسم الاخير';

  @override
  String get lastNameHint => 'الاسم الاخير';

  @override
  String get completeProfileSubmit => 'تسجيل الان';

  @override
  String get completeProfileTermsPrefix => 'بتسجيلك في التطبيق أنت توافق على ';

  @override
  String get authAppLogoSemanticLabel => 'شعار التطبيق';

  @override
  String get mainTabHome => 'الرئيسية';

  @override
  String get mainTabCart => 'السلة';

  @override
  String get mainTabOrders => 'الطلبات';

  @override
  String get mainTabAccount => 'حسابي';

  @override
  String get homeCategoryRestaurants => 'المطاعم';

  @override
  String get homeCategoryGrocery => 'البقالة';

  @override
  String get homeCategoryStores => 'المتاجر';

  @override
  String get homeCategoryPickup => 'استلم بنفسك';

  @override
  String get serviceSearchHint => 'إبحث عن ما تحب';

  @override
  String get serviceAvailable => 'متاح';

  @override
  String get serviceClosed => 'مغلق';

  @override
  String get serviceListingRestaurantsTitle => 'المطاعم';

  @override
  String get serviceListingGroceryTitle => 'البقالة';

  @override
  String get serviceListingStoresTitle => 'المتاجر';

  @override
  String get serviceListingPickupTitle => 'استلم بنفسك';

  @override
  String get serviceCategoryDesserts => 'الحلويات';

  @override
  String get serviceCategoryGrills => 'المشويات';

  @override
  String get serviceCategoryPizza => 'البيتزا';

  @override
  String get serviceCategoryFastFood => 'وجبات سريعة';

  @override
  String get serviceCategoryBurger => 'برجر';

  @override
  String get serviceCategoryShawarma => 'شاورما';

  @override
  String get serviceCategoryRoasters => 'محمصات';

  @override
  String get serviceCategoryFruitsVegetables => 'فاكهة وخضار';

  @override
  String get serviceCategoryDairy => 'الألبان';

  @override
  String get serviceCategorySnacks => 'تسالي';

  @override
  String get serviceCategorySupermarket => 'سوبر ماركت';

  @override
  String get serviceCategoryFlowers => 'الورود';

  @override
  String get serviceCategoryPerfumeBeauty => 'عطور و تجميل';

  @override
  String get serviceLargeStores => 'المتاجر الكبرى';

  @override
  String get serviceAllPlaces => 'كل الاماكن';

  @override
  String get serviceFilterTopRated => 'الأعلى تقييماً';

  @override
  String get serviceFilterOffers => 'العروض';

  @override
  String get serviceFilterFastDelivery => 'توصيل سريع';

  @override
  String get serviceDeliveryTimeRange => '45-30 دقيقة';

  @override
  String get serviceRestaurantKira => 'مطعم الكيرة';

  @override
  String get serviceRestaurantAzAlSham => 'مطعم عز الشام';

  @override
  String get serviceRestaurantDescription => 'شاورما، بيتزا، وجبات شرقي';

  @override
  String get serviceStoreFathallah => 'فتح الله';

  @override
  String get serviceStoreCaptain => 'الكابتن';

  @override
  String get serviceStoreRimasLand => 'ريماس لاند';

  @override
  String get serviceStoreTaheraFry => 'مقلة الطاهرة';

  @override
  String get serviceStoreFamilyMarket => 'ماركت فاميلي';

  @override
  String get serviceCaptainMarket => 'ماركت الكابتن';

  @override
  String get serviceEmptyTitle => 'لا توجد أماكن حالياً';

  @override
  String get serviceEmptyMessage => 'ستظهر هنا الأماكن المطابقة قريباً.';

  @override
  String get serviceNoResultsAvailable => 'لا يوجد نتائج متاحه';

  @override
  String get cartTitle => 'سلة المشتريات';

  @override
  String get cartRestaurantSubtitle => 'طلبك من مطعم عز الشام';

  @override
  String get cartProductBurgerCombo => 'عرض البرجر مع الفرايز';

  @override
  String get cartNotesHint => 'ملاحظاتك هنا...';

  @override
  String get cartDiscountCode => 'كود الخصم';

  @override
  String get cartEmptyTitle => 'سلة المشتريات فارغة';

  @override
  String get cartEmptyMessage => 'تم تفريغ السلة مؤقتاً بعد إتمام الدفع.';

  @override
  String get cartCheckout => 'تابع الدفع';

  @override
  String get cartAddMore => 'نزود شيئ';

  @override
  String get checkoutTitle => 'تابع الدفع';

  @override
  String get checkoutDeliveryAddress => 'عنوان التوصيل';

  @override
  String get checkoutChangeAddress => 'تغيير العنوان';

  @override
  String get checkoutPaymentMethod => 'اختر طريقة الدفع :';

  @override
  String get checkoutCashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get checkoutCashOnDeliverySubtitle => 'ادفع عند وصول طلبك';

  @override
  String get checkoutCardPayment => 'دفع عن طريق الفيزا';

  @override
  String get checkoutConfirmOrder => 'تنفيذ الطلب';

  @override
  String get confirmPayment => 'تأكيد الدفع';

  @override
  String get checkoutOrderDesignOnly => 'تم إرسال الطلب بنجاح';

  @override
  String get checkoutAddressUpdated => 'تم تحديث العنوان بنجاح';

  @override
  String cartPrice(int amount) {
    return '$amount ج.م';
  }

  @override
  String get productDetailsTitle => 'تفاصيل المنتج';

  @override
  String get productBurgerDescription =>
      'ساندوتش برجر طازج مُحضر من لحم بقري مشوي صوص البرجر الخاص، يُقدم مع بطاطس مقلية';

  @override
  String get productAddNotes => 'اضف ملاحظاتك';

  @override
  String get productEditNotes => 'تعديل ملاحظاتك';

  @override
  String get productYourNotes => 'ملاحظاتك';

  @override
  String get productNotesTitle => 'ملاحظات';

  @override
  String get productNotesHint => 'اكتب ملاحظات هنا ...';

  @override
  String get productNotesSubmit => 'إرسال';

  @override
  String get productTypeTitle => 'النوع';

  @override
  String get productTypeChicken => 'فراخ';

  @override
  String get productTypeMeat => 'لحمة';

  @override
  String get productFlavorTitle => 'النكهة';

  @override
  String get productFlavorNormal => 'عادي';

  @override
  String get productFlavorHot => 'حار';

  @override
  String get productAddSomethingTitle => 'إضافة شئ اخر ؟';

  @override
  String get productAddSomethingSubtitle => 'اختر ما يناسبك من الإضافات';

  @override
  String get productAddonWater => 'مياة معدنية';

  @override
  String get productAddonToast => 'توسيت توت';

  @override
  String get productAddonChips => 'شيبسي';

  @override
  String get productAddToCart => 'إضافة الى السلة';

  @override
  String get ordersTitle => 'الطلبات';

  @override
  String get orderRestaurantAzAlSham => 'عز الشام';

  @override
  String get orderProductsCount => '3 منتجات';

  @override
  String get orderEstimatedArrival => 'وقت الوصول المتوقع';

  @override
  String get orderEstimatedArrivalRange => '15 : 20 دقيقة';

  @override
  String get orderWaitingAcceptance => 'طلبك بانتظار القبول';

  @override
  String get orderWaitingAcceptanceShort => 'بانتظار القبول';

  @override
  String get orderPreparing => 'جاري تحضير طلبك';

  @override
  String get orderPreparingShort => 'جاري التحضير';

  @override
  String get orderCourierOnWay => 'المندوب في الطريق إليك';

  @override
  String get orderCourierOnWayShort => 'في الطريق إليك';

  @override
  String get orderDelivered => 'تم تسليم الطلب';

  @override
  String get orderDeliveredShort => 'طلب مغلق';

  @override
  String get orderCancelled => 'طلب ملغي';

  @override
  String get orderCancelledShort => 'طلب ملغي';

  @override
  String orderNumber(String number) {
    return 'طلب رقم $number';
  }

  @override
  String get orderTotal => '340 ج.م';

  @override
  String get orderDetails => 'عرض الطلب';

  @override
  String get reorder => 'طلب جديد';

  @override
  String get trackOrder => 'تتبع الطلب';

  @override
  String get trackYourOrder => 'تابع طلبك';

  @override
  String get deliverTo => 'التوصيل الى :';

  @override
  String get orderItemsTitle => 'المنتجات المطلوبة :';

  @override
  String get paymentSummary => 'ملخص الطلب :';

  @override
  String get orderSubtotal => 'قيمة الطلب';

  @override
  String get orderSubtotalValue => '400 ج.م';

  @override
  String get orderDeliveryFee => 'التوصيل';

  @override
  String get orderDeliveryFeeValue => '20 ج.م';

  @override
  String get orderDiscount => 'الخصم';

  @override
  String get orderDiscountValue => '80 ج.م';

  @override
  String get orderGrandTotal => 'الاجمالي :';

  @override
  String orderQuantity(int count) {
    return 'الكمية : $count';
  }

  @override
  String get orderProductName => 'عرض البرجر مع الفرايز';

  @override
  String get orderProductPrice => '200 ج.م';

  @override
  String get cancelOrder => 'إلغاء الطلب';

  @override
  String get orderCancelDesignOnly => 'تم إلغاء الطلب بنجاح';

  @override
  String get courierDetails => 'بيانات المندوب :';

  @override
  String get orderCourierName => 'احمد على';

  @override
  String get orderCourierPhone => '01004059966';

  @override
  String get orderCourierRating => '4.5';

  @override
  String get orderAcceptedShort => 'تم القبول';

  @override
  String get orderHandedToCourierShort => 'تسليم للمندوب';

  @override
  String get orderYouCancelled => 'لقد قمت بالغاء الطلب';

  @override
  String get cancellationReasonTitle => 'سبب الالغاء :';

  @override
  String get cancellationReasonSample => 'تأخر تأكيد الطلب';

  @override
  String get rateOrderTitle => 'تقييم';

  @override
  String get yourRating => 'تقييمك';

  @override
  String get ratingFeedbackHint => 'اكتب مدى رضاك عن الخدمة';

  @override
  String get skipRating => 'تخطي';

  @override
  String get submitRating => 'إرسال';

  @override
  String get ratingSubmittedDesignOnly => 'تم إرسال التقييم بنجاح';

  @override
  String get orderDetailsDesignOnly => 'تم التحديث بنجاح';

  @override
  String get rateOrder => 'تقييم الطلب';

  @override
  String get currentOrders => 'الحالية';

  @override
  String get previousOrders => 'السابقة';

  @override
  String get cancelledOrders => 'الملغية';

  @override
  String get accountTitle => 'حسابي';

  @override
  String get accountPlaceholderName => 'أحمد فرج';

  @override
  String get accountPlaceholderEmail => 'afarag74@gmail.com';

  @override
  String get accountGeneralSettings => 'الإعدادات العامة';

  @override
  String get accountFavorites => 'المفضلة';

  @override
  String get accountDiscountPoints => 'نقاط الخصم';

  @override
  String get accountSavedAddresses => 'العناوين المحفوظة';

  @override
  String get accountCards => 'البطاقات';

  @override
  String get accountTechnicalSupport => 'الدعم الفني';

  @override
  String get accountTermsAndConditions => 'الشروط والاحكام';

  @override
  String get accountLogout => 'تسجيل الخروج';

  @override
  String get accountLoggingOut => 'جاري تسجيل الخروج...';

  @override
  String get favoritesTitle => 'المفضلة';

  @override
  String get favoritesEmptyTitle => 'لا توجد مفضلة بعد';

  @override
  String get favoritesEmptyMessage => 'ستظهر هنا المطاعم والوجبات التي تحفظها.';

  @override
  String get favoriteSampleRestaurant => 'مطعم الكيلاني';

  @override
  String get favoriteSampleDescription => 'مشويات وساندويتشات وتوصيل سريع';

  @override
  String get favoriteSampleMeal => 'وجبة دجاج مشوي';

  @override
  String get favoriteSampleMealDescription => 'دجاج، أرز، سلطة، وصوص';

  @override
  String get favoriteDeliveryTime => '٢٠ - ٣٠ دقيقة';

  @override
  String get favoriteRating => '٤٫٨';

  @override
  String get favoriteRestaurantAzAlSham => 'مطعم عز الشام';

  @override
  String get favoriteStatusAvailable => 'متاح';

  @override
  String get favoriteStatusBusy => 'مشغول';

  @override
  String get favoriteStatusClosed => 'مغلق';

  @override
  String get favoriteDeliveryTimeRange => '30-45 دقيقة';

  @override
  String get removeFromFavorites => 'إزالة من المفضلة';

  @override
  String get savedAddressesTitle => 'العناوين المحفوظة';

  @override
  String get savedAddressesEmpty => 'لا توجد عناوين محفوظة حتى الآن';

  @override
  String get savedAddressesLoadFailed => 'تعذر تحميل العناوين المحفوظة';

  @override
  String get homeAddressTitle => 'المنزل';

  @override
  String get workAddressTitle => 'العمل';

  @override
  String get sampleHomeAddress => '١٥ شارع التحرير، الدقي، الجيزة';

  @override
  String get sampleWorkAddress => '١٢ كورنيش النيل، المعادي، القاهرة';

  @override
  String get addNewAddress => 'إضافة عنوان جديد';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get deleteAddress => 'حذف العنوان';

  @override
  String get deleteAddressTitle => 'حذف العنوان';

  @override
  String get deleteAddressMessage => 'هل أنت متأكد من انك تريد حذف العنوان؟';

  @override
  String get confirmLocation => 'تأكيد';

  @override
  String get addAddressTitle => 'العنوان الجديد';

  @override
  String get editAddressTitle => 'تعديل العنوان';

  @override
  String get saveAddress => 'تاكيد الإضافة';

  @override
  String get updateAddress => 'تاكيد التعديل';

  @override
  String get fullAddress => 'العنوان بالتفصيل';

  @override
  String get building => 'رقم المبنى';

  @override
  String get apartment => 'رقم الشقة';

  @override
  String get floor => 'الدور';

  @override
  String get addressSavedDesignOnly => 'تم حفظ العنوان بنجاح';

  @override
  String get addressUpdatedDesignOnly => 'تم تحديث العنوان بنجاح';

  @override
  String get addressDeletedDesignOnly => 'تم حذف العنوان بنجاح';

  @override
  String get itemAddedToFavorites => 'تم إضافة العنصر للمفضلة بنجاح';

  @override
  String get itemRemovedFromFavorites => 'تم إزالة العنصر من المفضلة بنجاح';

  @override
  String get chooseLocation => 'تحديد الموقع الجغرافي';

  @override
  String get selectedLocation => 'عنوانك الحالي';

  @override
  String get selectDeliveryAddress => 'حدد عنوان التوصيل';

  @override
  String get searchForAddress => 'إبحث على موقعك';

  @override
  String get currentLocation => 'الموقع الحالي';

  @override
  String get deliveryAddress => 'القاهره الجديده ، مدينتي ، حي الزهور';

  @override
  String get sampleAddressMeta => 'مبنى : السعدني / شقة : 201 / الدور : الخامس';

  @override
  String get apartmentAddressTitle => 'الشقة';

  @override
  String get sampleBuildingName => 'السعدني';

  @override
  String get sampleApartmentNumber => '201';

  @override
  String get sampleFloorName => 'الخامس';

  @override
  String get editAddress => 'تعديل العنوان';

  @override
  String get helpSupportTitle => 'الدعم الفني';

  @override
  String get faqTitle => 'الأسئلة الشائعة';

  @override
  String get supportOrderIssue => 'لدي مشكلة في طلب';

  @override
  String get supportPaymentIssue => 'المساعدة في الدفع والاسترداد';

  @override
  String get supportContactUs => 'تواصل معنا';

  @override
  String get supportPhone => 'اتصل بالدعم';

  @override
  String get supportWhatsapp => 'دعم واتساب';

  @override
  String get supportEmail => 'البريد الإلكتروني للدعم';

  @override
  String get supportChatTitle => 'الدعم الفني';

  @override
  String get supportToday => 'اليوم';

  @override
  String get supportGoodEvening => 'مساء الخير';

  @override
  String get supportHowCanWeHelp => 'نقد نساعد حضرتك ازاي ؟';

  @override
  String get supportSampleUserIssue =>
      'عندي مشكله مع مطعم عز الشام الاكل اتأخر عن المده المحددة';

  @override
  String get supportInputHint => 'اكتب هنا...';

  @override
  String get supportAttachmentOptions => 'خيارات المرفقات';

  @override
  String get supportPickImage => 'اختر صورة';

  @override
  String get supportPickVideo => 'اختر فيديو';

  @override
  String get supportCancelAttachment => 'إلغاء';

  @override
  String get supportImageMessage => 'صورة';

  @override
  String get supportVideoMessage => 'فيديو';

  @override
  String get cardsTitle => 'البطاقات';

  @override
  String get paymentMethodsTitle => 'طرق الدفع';

  @override
  String get noCardsMessage => 'لا يوجد لديك اي بطاقة';

  @override
  String get addNewCard => 'إضافة بطاقة جديدة';

  @override
  String get addCard => 'إضافة';

  @override
  String get saveCardDetails => 'حفظ بيانات البطاقة';

  @override
  String get forLaterUse => 'للاستخدام لاحقاٍ';

  @override
  String get editCard => 'تعديل';

  @override
  String get editCardTitle => 'تعديل بيانات البطاقة';

  @override
  String get deleteCard => 'حذف';

  @override
  String get deleteCardTitle => 'حذف البطاقة';

  @override
  String get deleteCardMessage => 'هل أنت متأكد من انك تريد حذف البطاقة؟';

  @override
  String get confirmDelete => 'حذف البطاقة';

  @override
  String get updateCard => 'تعديل';

  @override
  String get cardHolderName => 'اسم حامل البطاقة';

  @override
  String get cardNumber => 'رقم البطاقة';

  @override
  String get expiryDate => 'تاريخ الانتهاء';

  @override
  String get cvv => 'رقم cvv';

  @override
  String get sampleCardHolder => 'أحمد فرج';

  @override
  String get sampleMaskedCardNumber => '**** **** **** 1234';

  @override
  String get sampleCardExpiry => '2026';

  @override
  String get paymentCardEnding => 'بطاقة فيزا تنتهي بـ 4242';

  @override
  String get paymentIntegrationComingSoon => 'حفظ بطاقات الدفع قادم قريباً.';

  @override
  String get cardAddedDesignOnly => 'تمت إضافة البطاقة بنجاح';

  @override
  String get cardUpdatedDesignOnly => 'تم تعديل البطاقة بنجاح';

  @override
  String get cardDeletedDesignOnly => 'تم حذف البطاقة بنجاح';

  @override
  String get editProfileTitle => 'تعديل البيانات الشخصية';

  @override
  String get personalDataTitle => 'البيانات الشخصية';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get mobileNumber => 'رقم الجوال';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get profileChangesSaved => 'تم حفظ التغييرات بنجاح';

  @override
  String get changePhone => 'تغيير';

  @override
  String get changePhoneTitle => 'تغيير رقم الجوال';

  @override
  String get changePhoneSubtitle =>
      'ادخل رقمك الجديد بشكل صحيح ليصلك كود التفعيل !';

  @override
  String get newPhoneNumber => 'رقم الجوال الجديد';

  @override
  String get continueButton => 'متابعة';

  @override
  String get verifyPhoneTitle => 'كود التحقق';

  @override
  String get verifyPhoneMessage => 'تم إرسال كود على رقمك الجديد للتحقق !';

  @override
  String get otpCode => 'كود التحقق';

  @override
  String get confirmOtp => 'تأكيد';

  @override
  String get resendCode => 'إعادة إرسال الكود ؟';

  @override
  String resendCodeTimer(int seconds) {
    return '$seconds ثانية';
  }

  @override
  String get phoneChangedTitle => 'تم تغيير رقم الجوال بنجاح';

  @override
  String get phoneChangedMessage => 'تم تحديث رقم الجوال بنجاح.';

  @override
  String get profileUpdatedDesignOnly => 'تم تحديث البيانات بنجاح';

  @override
  String get invalidPhoneMessage => 'يرجى إدخال رقم الجوال';

  @override
  String get invalidPhoneLengthMessage => 'رقم الجوال يجب أن يكون 11 أو 12 رقم';

  @override
  String get invalidOtpMessage => 'يرجى إدخال كود التحقق كاملاً';

  @override
  String get socialDivider => 'او';

  @override
  String get socialAppleSoon => 'دخول عبر Apple قريباً';

  @override
  String get socialGoogleSoon => 'دخول عبر Google قريباً';

  @override
  String get socialAppleLabel => 'دخول عبر Apple';

  @override
  String get socialGoogleLabel => 'دخول عبر Google';

  @override
  String get validationEmailRequiredDotComRequired => 'البريد الالكتروني مطلوب';

  @override
  String get validationEmailRequiredDotComInvalid =>
      'يرجى إدخال بريد الكتروني صحيح';

  @override
  String get validationEmailRequiredDotComNeedsCom =>
      'يجب أن ينتهي البريد الالكتروني بـ .com';

  @override
  String get validationPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get validationPasswordMin8 => 'كلمة المرور يجب ألا تقل عن ٨ أحرف';

  @override
  String get validationUsernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get validationUsernameMin3 => 'اسم المستخدم يجب ألا يقل عن ٣ أحرف';

  @override
  String get validationPhoneRequired => 'رقم الجوال مطلوب';

  @override
  String get validationPhoneEgyptian =>
      'يرجى إدخال رقم جوال مصري صحيح (١٠ أو ١١ رقماً بعد +٢٠)';

  @override
  String get validationConfirmPasswordRequired => 'تأكيد كلمة المرور مطلوب';

  @override
  String get validationConfirmPasswordMismatch => 'كلمة المرور غير متطابقة';

  @override
  String get validationOtpRequired => 'رمز التحقق مطلوب';

  @override
  String get validationOtpSixDigits => 'يرجى إدخال ٦ أرقام';

  @override
  String get homeDeliveryTo => 'التوصيل إلى';

  @override
  String get homeBannerEyebrow => 'فاتح اللذة';

  @override
  String get homeBannerTitle => 'برجر\nمميز';

  @override
  String get homeOrderNow => 'اطلب الآن';

  @override
  String get homeMissedOffersTitle => 'عروض لا تفوتها';

  @override
  String get homeMostOrderedTitle => 'الأكثر طلباً';

  @override
  String get searchTitle => 'البحث';

  @override
  String get searchCravingTitle => 'نفسك في ايه';

  @override
  String get searchRecentTitle => 'بحثك الاخير';

  @override
  String get searchTopStoresTitle => 'المتاجر الكبرى';

  @override
  String get searchMostSearchedTitle => 'الاكثر بحثاً';

  @override
  String get searchResultsTitle => 'نتائج البحث';

  @override
  String get searchEmptyTitle => 'لا توجد نتائج مطابقة';

  @override
  String get searchFilterAll => 'الكل';

  @override
  String get searchCravingBreakfast => 'فطار';

  @override
  String get searchCravingDairy => 'منتجات البان';

  @override
  String get searchCravingDrinks => 'مشروبات';

  @override
  String get searchCravingSnacks => 'تسالي';

  @override
  String get searchCravingFastFood => 'وجبات سريعة';

  @override
  String get searchCravingBakery => 'مخبوزات';

  @override
  String get searchCravingDesserts => 'حلويات';

  @override
  String get searchRecentJuice => 'عصير';

  @override
  String get searchRecentPepsi => 'بيبسي';

  @override
  String get searchRecentNuts => 'مكسرات';

  @override
  String get searchRecentFalafel => 'فول فلافل';

  @override
  String get searchMostSearchedAzAlSham => 'عز الشام';

  @override
  String get searchMostSearchedGawdat => 'جودت';

  @override
  String get searchMostSearchedTeaBun => 'Tea Bun';

  @override
  String get searchMostSearchedElBashawat => 'الباشوات';

  @override
  String get searchResultBurgerFriesTitle => 'عرض البرجر مع الفرايز';

  @override
  String get searchResultFalafelTitle => 'فول وفلافل';

  @override
  String get searchResultFalafelSubtitle => 'فطار، سندوتشات، مشروبات';

  @override
  String get searchResultFalafelPrice => '45 ج.م';

  @override
  String get searchResultFalafelKeywordBeans => 'فول';

  @override
  String get mapPickerLoadingAddress => 'جاري تحديد العنوان...';

  @override
  String get mapPickerFallbackAddress => 'موقع محدد على الخريطة';

  @override
  String get mapPickerFailedAddress => 'تعذر تحديد العنوان';

  @override
  String get restaurantDetailsTitle => 'تفاصيل المطعم';

  @override
  String get restaurantDiscountSubtitle => '50 %خصم على بعض المنتج';

  @override
  String get restaurantViewProducts => 'عرض المنتجات';

  @override
  String get restaurantSearchTitle => 'بحث';

  @override
  String get restaurantSearchEmptyTitle => 'لا توجد أصناف مطابقة';

  @override
  String get restaurantRateCustomerReviews => 'اراء العملاء :';

  @override
  String get restaurantRateRatingsLabel => 'التقييمات';

  @override
  String get restaurantRateMoreDetails => 'تفاصيل اكثر عنا :';

  @override
  String get restaurantRateDeliveryPrice => 'سعر التوصيل';

  @override
  String get restaurantRateMinimumOrder => 'الحد الادنى للطلب';

  @override
  String get restaurantRateDeliveryTime => 'وقت التوصيل';

  @override
  String get restaurantRateAddress => 'العنوان';

  @override
  String get restaurantRatePreviousOrders => 'طلبات مسبقة';

  @override
  String get restaurantRatePaymentMethod => 'طريقة الدفع';

  @override
  String get serviceDeliveryTime25To40 => '25-40 دقيقة';

  @override
  String get serviceDeliveryTime35To50 => '35-50 دقيقة';

  @override
  String get authErrorNoInternet => 'لا يوجد اتصال بالإنترنت';

  @override
  String get authErrorTimeout => 'انتهت مهلة الطلب';

  @override
  String get authErrorUnauthorized => 'غير مصرح لك';

  @override
  String get authErrorUnknown => 'حدث خطأ ما';

  @override
  String get authErrorRequestFailed => 'فشل الطلب';

  @override
  String get authErrorInvalidResponse => 'استجابة غير صالحة';

  @override
  String get authErrorMissingAccessToken =>
      'تم التحقق بنجاح ولكن لم يتم إرجاع رمز الوصول';

  @override
  String get searchChangeLocation => 'تغيير الموقع الجغرافي';

  @override
  String get searchMostSearchedDesserts => 'حلويات';

  @override
  String get searchMostSearchedFalafel => 'فول فلافل';

  @override
  String get searchMostSearchedPizza => 'بيتزا';

  @override
  String get searchMostSearchedNuts => 'مكسرات';

  @override
  String get searchMostSearchedPepsi => 'بيبسي';

  @override
  String get searchMostSearchedJuice => 'عصير';

  @override
  String get searchMostSearchedCheese => 'جبنة';

  @override
  String get startSearching => 'ابدأ البحث';

  @override
  String get itemsTitle => 'العناصر';

  @override
  String addressDetailsFormat(String building, String apartment, String floor) {
    return 'مبنى : $building / شقة : $apartment / الدور : $floor';
  }

  @override
  String get noOffersAvailable => 'لا توجد عروض متاحة حالياً';

  @override
  String get noRestaurantsFound => 'لا توجد مطاعم';

  @override
  String get connectingToApi => 'جاري ربط البيانات بالـ API...';

  @override
  String priceWithCurrency(String amount) {
    return '$amount ج.م';
  }

  @override
  String get orderConfirmedTitle => 'تم تأكيد الطلب';

  @override
  String get filterTopRated => 'الأعلى تقييمًا';

  @override
  String get filterMostOrdered => 'الأكثر طلبًا';

  @override
  String get filterWithOffers => 'مع عروض';

  @override
  String get trackOrderTitle => 'تتبع الطلب';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profileNoData => 'لا توجد بيانات للملف الشخصي';

  @override
  String get profileNameLabel => 'الاسم: ';

  @override
  String get profileEmailLabel => 'البريد الإلكتروني: ';

  @override
  String get profilePhoneLabel => 'رقم الهاتف: ';

  @override
  String get currencyEgp => 'ج.م';

  @override
  String get applyButton => 'تطبيق';

  @override
  String get cartConflictTitle => 'تعارض في السلة';

  @override
  String get cartConflictMessage =>
      'إضافة عناصر من مطعم مختلف ستمسح سلتك الحالية. هل ترغب في المتابعة؟';

  @override
  String get noCategoriesAvailable => 'لا توجد فئات متاحة';

  @override
  String get searchClearAll => 'مسح الكل';

  @override
  String get searchClearHistoryConfirm => 'هل أنت متأكد من مسح سجل البحث؟';

  @override
  String get clear => 'مسح';

  @override
  String get seeAll => 'عرض الكل';
}
