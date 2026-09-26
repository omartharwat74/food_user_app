import json

en_file = 'lib/l10n/app_en.arb'
ar_file = 'lib/l10n/app_ar.arb'

def update_arb(filepath, updates):
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    for k, v in updates.items():
        data[k] = v
        
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

en_updates = {
    "startNewCart": "Start",
    "mealIngredients": "Meal ingredients",
    "productAddedSuccessfully": "Product added to cart successfully",
    "orderSummary": "Order Summary",
    "orderValue": "Order Value",
    "delivery": "Delivery",
    "tax": "Tax",
    "discount": "Discount",
    "total": "Total :",
    "viewCart": "View Cart",
    "noExactResultsShowSuggestions": "No exact results — showing suggestions",
    "marketsAndSupermarkets": "Markets & Supermarkets",
    "searchMarketOrSupermarket": "Search for a market or supermarket...",
    "availableNow": "Available Now",
    "errorOccurred": "Error Occurred",
    "noMarketsAvailable": "No available markets",
    "noMarketsMatchingSearch": "We couldn't find markets matching your search.",
    "marketUnavailable": "Market Unavailable",
    "marketUnavailableMsg": "Sorry, this market is no longer available or has been removed.",
    "notFound": "Not Found",
    "backToMarkets": "Back to Markets",
    "signInRequired": "Sign In Required",
    "signInRequiredMsg": "Please sign in to add favorites and use all services.",
    "signIn": "Sign In",
    "pickupAvailable": "Pickup Available",
    "free": "Free",
    "noItemsFound": "No Items Found",
    "noProductsOrSections": "We couldn't find any products or sections here.",
    "tryAgain": "Try Again",
    "majorStores": "Major Stores",
    "allPlaces": "All Places",
    "shopByCategories": "Shop by Categories",
    "mostRequestedProducts": "Most requested products",
    "searchForWhatYouLove": "Search for what you love",
    "start": "Start",
    "cartConflictMessageCustom": "A new order will clear your current cart.",
    "startNewCartTitle": "Start a new cart?",
    "searchResults": "Search Results",
    "sections": "Sections"
}

ar_updates = {
    "startNewCart": "بدء",
    "mealIngredients": "مكونات الوجبة",
    "productAddedSuccessfully": "تم إضافة المنتج للسلة بنجاح",
    "orderSummary": "ملخص الطلب :",
    "orderValue": "قيمة الطلب",
    "delivery": "التوصيل",
    "tax": "الضريبة",
    "discount": "الخصم",
    "total": "الاجمالي :",
    "viewCart": "اطلع على السلة",
    "noExactResultsShowSuggestions": "لا توجد نتائج دقيقة — عرض اقتراحات",
    "marketsAndSupermarkets": "المتاجر والسوبرماركت",
    "searchMarketOrSupermarket": "ابحث عن متجر أو سوبرماركت...",
    "availableNow": "متاح الآن",
    "errorOccurred": "حدث خطأ",
    "noMarketsAvailable": "لا توجد متاجر متاحة",
    "noMarketsMatchingSearch": "لم نتمكن من العثور على متاجر مطابقة لبحثك.",
    "marketUnavailable": "المتجر غير متاح",
    "marketUnavailableMsg": "عذراً، هذا المتجر لم يعد متاحاً حالياً أو قد تم إزالته.",
    "notFound": "غير موجود",
    "backToMarkets": "العودة للمتاجر",
    "signInRequired": "تسجيل الدخول مطلوب",
    "signInRequiredMsg": "يرجى تسجيل الدخول لإضافة المفضلة واستخدام كامل الخدمات.",
    "signIn": "تسجيل الدخول",
    "pickupAvailable": "استلام من الفرع",
    "free": "مجاني",
    "noItemsFound": "لا توجد بيانات",
    "noProductsOrSections": "لم نتمكن من العثور على أي منتجات أو أقسام هنا.",
    "tryAgain": "إعادة المحاولة",
    "majorStores": "المتاجر الكبرى",
    "allPlaces": "كل الاماكن",
    "shopByCategories": "تسوّق حسب التصنيفات",
    "mostRequestedProducts": "المنتجات الاكثر طلباً",
    "searchForWhatYouLove": "ابحث عن ما تحب",
    "start": "بدء",
    "cartConflictMessageCustom": "طلب جديد سيمسح سلتك الحالية.",
    "startNewCartTitle": "بدء سلة جديدة؟",
    "searchResults": "نتائج البحث",
    "sections": "الأقسام"
}

update_arb(en_file, en_updates)
update_arb(ar_file, ar_updates)

print("Updated ARB files.")
