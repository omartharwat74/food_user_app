import os
import re

def replace_in_file(filepath, replacements):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    for old, new in replacements:
        content = content.replace(old, new)
        
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

# ProductDetailsScreen
replace_in_file('lib/features/product/presentation/pages/product_details_screen.dart', [
    ("'بدء سلة جديدة؟'", "AppLocalizations.of(context)!.startNewCartTitle"),
    ("'طلب جديد سيمسح سلتك الحالية.'", "AppLocalizations.of(context)!.cartConflictMessageCustom"),
    ("'إلغاء'", "AppLocalizations.of(context)!.cancel"),
    ("'بدء'", "AppLocalizations.of(context)!.start"),
    ("'مكونات الوجبة'", "AppLocalizations.of(context)!.mealIngredients"),
    ("'تم إضافة المنتج للسلة بنجاح'", "AppLocalizations.of(context)!.productAddedSuccessfully"),
])

# CheckoutScreen
replace_in_file('lib/features/checkout/presentation/pages/checkout_screen.dart', [
    ("'ملخص الطلب :'", "AppLocalizations.of(context)!.orderSummary"),
    ("'قيمة الطلب'", "AppLocalizations.of(context)!.orderValue"),
    ("'التوصيل'", "AppLocalizations.of(context)!.delivery"),
    ("'الضريبة'", "AppLocalizations.of(context)!.tax"),
    ("'الخصم'", "AppLocalizations.of(context)!.discount"),
    ("'الاجمالي : '", "AppLocalizations.of(context)!.total + ' '"),
])

# CartSummary
replace_in_file('lib/features/cart/presentation/widgets/cart_summary.dart', [
    ("'الضريبة'", "AppLocalizations.of(context)!.tax"),
])

# CartFloatingBanner
replace_in_file('lib/features/cart/presentation/widgets/cart_floating_banner.dart', [
    ("'اطلع على السلة'", "AppLocalizations.of(context)!.viewCart"),
])

# StoreSearchScreen
replace_in_file('lib/features/market/presentation/pages/store_search_screen.dart', [
    ("'لا توجد نتائج دقيقة — عرض اقتراحات'", "AppLocalizations.of(context)!.noExactResultsShowSuggestions"),
])

# MarketsListScreen
replace_in_file('lib/features/market/presentation/pages/markets_list_screen.dart', [
    ("isArabic ? 'المتاجر والسوبرماركت' : 'Markets & Supermarkets'", "AppLocalizations.of(context)!.marketsAndSupermarkets"),
    ("isArabic\n                          ? 'ابحث عن متجر أو سوبرماركت...'\n                          : 'Search for a market or supermarket...'", "AppLocalizations.of(context)!.searchMarketOrSupermarket"),
    ("isArabic ? 'ابحث عن متجر أو سوبرماركت...' : 'Search for a market or supermarket...'", "AppLocalizations.of(context)!.searchMarketOrSupermarket"),
    ("isArabic ? 'متاح الآن' : 'Available Now'", "AppLocalizations.of(context)!.availableNow"),
    ("isArabic ? 'حدث خطأ' : 'Error Occurred'", "AppLocalizations.of(context)!.errorOccurred"),
    ("isArabic\n                            ? 'لا توجد متاجر متاحة'\n                            : 'No available markets'", "AppLocalizations.of(context)!.noMarketsAvailable"),
    ("isArabic ? 'لا توجد متاجر متاحة' : 'No available markets'", "AppLocalizations.of(context)!.noMarketsAvailable"),
    ("isArabic\n                            ? 'لم نتمكن من العثور على متاجر مطابقة لبحثك.'\n                            : 'We couldn\\'t find markets matching your search.'", "AppLocalizations.of(context)!.noMarketsMatchingSearch"),
    ("isArabic ? 'لم نتمكن من العثور على متاجر مطابقة لبحثك.' : 'We couldn\\'t find markets matching your search.'", "AppLocalizations.of(context)!.noMarketsMatchingSearch"),
    ("isArabic ? 'استلام من الفرع' : 'Pickup Available'", "AppLocalizations.of(context)!.pickupAvailable"),
])

# MarketDetailsScreen
replace_in_file('lib/features/market/presentation/pages/market_details_screen.dart', [
    ("'تم إضافة المنتج للسلة بنجاح'", "AppLocalizations.of(context)!.productAddedSuccessfully"),
])

# MarketNotFoundWidget
replace_in_file('lib/features/market/presentation/widgets/market_not_found_widget.dart', [
    ("final titleText = isArabic ? 'المتجر غير متاح' : 'Market Unavailable';", "final titleText = AppLocalizations.of(context)!.marketUnavailable;"),
    ("message ??\n        (isArabic\n            ? 'عذراً، هذا المتجر لم يعد متاحاً حالياً أو قد تم إزالته.'\n            : 'Sorry, this market is no longer available or has been removed.');", "message ?? AppLocalizations.of(context)!.marketUnavailableMsg;"),
    ("Text(isArabic ? 'غير موجود' : 'Not Found')", "Text(AppLocalizations.of(context)!.notFound)"),
    ("isArabic ? 'العودة للمتاجر' : 'Back to Markets'", "AppLocalizations.of(context)!.backToMarkets"),
])

# MarketCard
replace_in_file('lib/features/market/presentation/widgets/market_card.dart', [
    ("isArabic ? 'تسجيل الدخول مطلوب' : 'Sign In Required'", "AppLocalizations.of(context)!.signInRequired"),
    ("isArabic\n              ? 'يرجى تسجيل الدخول لإضافة المفضلة واستخدام كامل الخدمات.'\n              : 'Please sign in to add markets to your favorites.'", "AppLocalizations.of(context)!.signInRequiredMsg"),
    ("isArabic ? 'يرجى تسجيل الدخول لإضافة المفضلة واستخدام كامل الخدمات.' : 'Please sign in to add markets to your favorites.'", "AppLocalizations.of(context)!.signInRequiredMsg"),
    ("isArabic ? 'إلغاء' : 'Cancel'", "AppLocalizations.of(context)!.cancel"),
    ("isArabic ? 'تسجيل الدخول' : 'Sign In'", "AppLocalizations.of(context)!.signIn"),
    ("isArabic ? 'استلام من الفرع' : 'Pickup Available'", "AppLocalizations.of(context)!.pickupAvailable"),
    ("isArabic ? 'مجاني' : 'Free'", "AppLocalizations.of(context)!.free"),
    ("isArabic ? \"ج.م\" : \"EGP\"", "AppLocalizations.of(context)!.currencyEgp"),
])

# MarketEmptyState
replace_in_file('lib/features/market/presentation/widgets/market_empty_state.dart', [
    ("title ?? (isArabic ? 'لا توجد بيانات' : 'No Items Found')", "title ?? AppLocalizations.of(context)!.noItemsFound"),
    ("message ??\n            (isArabic\n                ? 'لم نتمكن من العثور على أي منتجات أو أقسام هنا.'\n                : 'We couldn\\'t find any products or sections here.')", "message ?? AppLocalizations.of(context)!.noProductsOrSections"),
    ("message ?? (isArabic ? 'لم نتمكن من العثور على أي منتجات أو أقسام هنا.' : 'We couldn\\'t find any products or sections here.')", "message ?? AppLocalizations.of(context)!.noProductsOrSections"),
    ("isArabic ? 'إعادة المحاولة' : 'Try Again'", "AppLocalizations.of(context)!.tryAgain"),
])

# ProductCard
replace_in_file('lib/features/market/presentation/widgets/product_card.dart', [
    ("final currencyText = isArabic ? 'ج.م' : 'EGP';", "final currencyText = AppLocalizations.of(context)!.currencyEgp;"),
])

# StoreDetailsScreen
replace_in_file('lib/features/store/presentation/pages/store_details_screen.dart', [
    ("'تم إضافة المنتج للسلة بنجاح'", "AppLocalizations.of(context)!.productAddedSuccessfully"),
    ("'تسوّق حسب التصنيفات'", "AppLocalizations.of(context)!.shopByCategories"),
    ("'المنتجات الاكثر طلباً'", "AppLocalizations.of(context)!.mostRequestedProducts"),
    ("'ابحث عن ما تحب'", "AppLocalizations.of(context)!.searchForWhatYouLove"),
])

# UnifiedResultsScreen
replace_in_file('lib/features/search/presentation/pages/unified_results_screen.dart', [
    ("'نتائج البحث'", "AppLocalizations.of(context)!.searchResults"),
    ("isArabic ? 'بحث' : 'Search'", "AppLocalizations.of(context)!.searchTitle"),
    ("isArabic ? 'الأقسام' : 'Sections'", "AppLocalizations.of(context)!.sections"),
])

print("Finished replacing strings.")
