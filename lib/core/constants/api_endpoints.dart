class ApiEndpoints {
  ApiEndpoints._();

  /// Base URL is overridable at build/run time via:
  ///   flutter run --dart-define=API_BASE_URL=https://...
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://mycar.msarweb.net',
  );

  /// Base URL for v2 API if needed.
  static const String baseUrlV2 = String.fromEnvironment(
    'API_BASE_URL_V2',
    defaultValue: 'https://mycar.msarweb.net',
  );

  // ── Auth (v1) ─────────────────────────────────────────────────────────────

  // ── Phone OTP Flow ────────────────────────────────────────────────────────
  /// `POST /api/v1/auth/phone/send-otp` body: `{ phone }`
  static const String sendOtp = '/api/v1/auth/phone/send-otp';

  /// `POST /api/v1/auth/phone/verify-otp` body: `{ phone, otp, device_id, platform }`
  /// Returns `status: "authenticated"` or `status: "complete_profile"`.
  static const String verifyOtp = '/api/v1/auth/phone/verify-otp';

  /// `POST /api/v1/auth/complete-profile` body: `{ registration_token, first_name, last_name, email }`
  static const String completeProfile = '/api/v1/auth/complete-profile';

  /// `POST /api/v1/auth/logout` body: `{ device_id }`
  static const String logout = '/api/v1/auth/logout';

  /// `PATCH /api/v1/auth/update-fcm` body: `{ device_id, fcm_token, platform }`
  static const String updateFcm = '/api/v1/auth/update-fcm';

  /// `POST /api/v1/auth/social/login` social login handshake
  static const String socialLogin = '/api/v1/auth/social/login';

  static const String me = '/api/v1/auth/me';
  static const String refreshToken = '/api/v1/auth/refresh';

  // Legacy aliases (kept for compatibility with old code)
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String registerV2 = '/api/v1/auth/register';
  static const String setPassword = '/api/v1/auth/set-password';
  static String v2(String path) => '$baseUrl$path';

  // ── User addresses ────────────────────────────────────────────────────────
  static const String userAddressesAll = '/api/v1/user-addresses/all';
  static const String userAddressesCreate = '/api/v1/user-addresses/create';
  static const String userAddressesEdit = '/api/v1/user-addresses/edit';
  static String userAddressShow(String id) => '/api/v1/user-addresses/show?id=$id';
  static String userAddressDelete(String id) => '/api/v1/user-addresses/delete?id=$id';
  
  // Legacy aliases
  static const String userAddresses = '/user/addresses';
  static String userAddress(String id) => '$userAddresses/$id';
  static String userAddressDefault(String id) => '$userAddresses/$id/default';

  // ── User Profile & Settings ───────────────────────────────────────────────
  /// `GET /api/v1/profile/show`
  static const String profileShow = '/api/v1/profile/show';
  /// `PUT /api/v1/profile/edit`
  static const String profileEdit = '/api/v1/profile/edit';
  /// `PUT /api/v1/profile/notifications`
  static const String profileNotifications = '/api/v1/profile/notifications';

  /// Change Phone Flow
  static const String phoneSendCurrentOtp = '/api/v1/profile/phone/send-current-otp';
  static const String phoneVerifyCurrentOtp = '/api/v1/profile/phone/verify-current-otp';
  static const String phoneSendOtp = '/api/v1/profile/phone/send-otp';
  static const String phoneVerifyOtp = '/api/v1/profile/phone/verify-otp';

  // Legacy user profile endpoints
  static const String userProfile = '/user/profile';
  static const String userSettings = '/user/settings';
  static const String user = '/user';

  // ── Cart ──────────────────────────────────────────────────────────────────
  static const String userCart = '/user/cart';
  static const String userCartItems = '/user/cart/items';
  static String userCartItem(String itemId) => '$userCartItems/$itemId';
  static const String applyPromo = '/cart/promo';

  // ── Payment & Checkout ────────────────────────────────────────────────────
  static const String userCardsAll = '/api/v1/user-cards/all';
  static const String userCardsCreate = '/api/v1/user-cards/create';
  static const String userCardsEdit = '/api/v1/user-cards/edit';
  static String userCardShow(String id) => '/api/v1/user-cards/show?id=$id';
  static String userCardDelete(String id) => '/api/v1/user-cards/delete?id=$id';

  // Legacy
  static const String userCards = '/user/cards';
  static String userCard(String id) => '$userCards/$id';
  static const String checkout = '/payments/checkout';

  // ── Orders ────────────────────────────────────────────────────────────────
  static const String orders = '/orders';
  static String orderDetail(String id) => '$orders/$id';
  static String orderTracking(String id) => '$orders/$id/tracking';

  // ── Notifications ──────────────────────────────────────────────────────────
  static const String notifications = '/notifications';
  static String notificationRead(String id) => '$notifications/$id/read';
  static const String notificationsReadAll = '/notifications/read-all';
  static const String notificationsToken = '/notifications/token';

  // ── General Settings ──────────────────────────────────────────────────────
  /// `GET /api/v1/general-settings` — public, no auth.
  static const String generalSettings = '/api/v1/general-settings';

  // ── Banners ────────────────────────────────────────────────────────────────
  /// `GET /api/v1/banners` — public, no auth.
  static const String banners = '/api/v1/banners';

  // ── Sections ──────────────────────────────────────────────────────────────
  /// `GET /api/v1/sections` — returns active home sections.
  static const String sections = '/api/v1/sections';

  // ── Tags ──────────────────────────────────────────────────────────────────
  /// `GET /api/v1/tags?section_id={id}` — tags scoped to a section.
  static const String tags = '/api/v1/tags';

  // ── Stores ────────────────────────────────────────────────────────────────
  /// `GET /api/v1/stores?section_id={id}&search=&tag_ids[]=&page=&per_page=`
  static const String stores = '/api/v1/stores';

  /// `GET /api/v1/stores/major?section_id={id}&page=&per_page=`
  static const String majorStores = '/api/v1/stores/major';

  /// `GET /api/v1/stores/show?id={storeId}` — full store details.
  static const String storeShow = '/api/v1/stores/show';

  /// `GET /api/v1/stores/products/all?store_id={storeId}` — menu sections.
  static const String storeProducts = '/api/v1/stores/products/all';

  /// `GET /api/v1/stores/products/show?id={productId}` — single product details.
  static const String storeProductShow = '/api/v1/stores/products/show';

  // ── Spotlights ────────────────────────────────────────────────────────────
  /// `GET /api/v1/spotlights`
  static const String spotlights = '/api/v1/spotlights';

  // ── Search Logs ───────────────────────────────────────────────────────────
  static const String userSearchLogsAll = '/api/v1/user-search-logs/all';
  static const String userSearchLogsCreate = '/api/v1/user-search-logs/create';
  static const String userSearchLogsDelete = '/api/v1/user-search-logs/delete';
  static const String userSearchLogsClear = '/api/v1/user-search-logs/clear';

  // ── Legacy search endpoint (kept for backward compat) ─────────────────────
  static const String search = '/search';
  static const String searchHistory = '/search/history';
  static const String searchKeywords = '/api/v1/search-keywords';

  // ── Restaurants ───────────────────────────────────────────────────────────
  static const String restaurants = '/restaurants';
  static String restaurantDetails(String id) => '$restaurants/$id';
  static String restaurantBranches(String id) => '$restaurants/$id/branches';
  static String restaurantOffers(String id) => '$restaurants/$id/offers';
  static String restaurantMenu(String id) => '$restaurants/$id/menu';
  static String branchMenu(String branchId) => '/menus/branch/$branchId';
  static String itemModifiers(String itemId) =>
      '/menus/items/$itemId/modifiers';

  // ── Favorites ───────────────────────────────────────────────────────────────
  static const String favoritesList = '/api/v1/favorites';
  static const String favoritesToggle = '/api/v1/favorites/toggle';

  // Legacy favorites (deprecated)
  // static const String favorites = '/restaurants/favorites';
  // static String toggleFavorite(String id) => '$restaurants/$id/favorite';

  // ── Markets ───────────────────────────────────────────────────────────────
  static const String markets = '/markets';
  static String marketDetails(String id) => '$markets/$id';
  static String marketCategories(String id) => '$markets/$id/categories';
  static String marketSubCategories(String id, String categoryId) =>
      '$markets/$id/categories/$categoryId/subcategories';
  static String marketProducts(
    String id,
    String categoryId,
    String subCategoryId,
  ) =>
      '$markets/$id/categories/$categoryId/subcategories/$subCategoryId/products';
  static String marketOffers(String id) => '$markets/$id/offers';
  static const String favoriteMarkets = '/markets/favorites';
  static String toggleFavoriteMarket(String id) => '$markets/$id/favorite';


  /// Public auth endpoints that must NOT receive an Authorization header.
  /// `/auth/set-password` is intentionally NOT listed here.
  // Note: [registerV2] shares the same path string as [register]
  // (`/auth/register`), so it is already covered here and not repeated.
  static const Set<String> publicAuthPaths = {
    login,
    register,
    sendOtp,
    verifyOtp,
    completeProfile,
    socialLogin,
    refreshToken,
  };
}
