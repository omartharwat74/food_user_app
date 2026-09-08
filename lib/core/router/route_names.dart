class RouteNames {
  RouteNames._();
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const authEntry = '/auth';
  static const phoneAuth = '/auth/phone';
  static const mockOtp = '/auth/otp';
  static const completeProfile = '/auth/complete-profile';
  static const termsAndConditions = '/terms-and-conditions';
  static const home = '/home';
  static const search = '/search';
  static const searchResults = '/search-results';
  static const serviceListing = '/service-listing/:type';
  static const restaurantList = '/restaurants';
  static const restaurantDetail = '/restaurant/:id';
  static const restaurantRate = '/restaurant/:id/rate';
  static const restaurantSearch = '/restaurant/:id/search';
  static const unifiedResults = '/unified-results';
  static const menuItemDetail = '/menu-item/:id';
  static const cart = '/cart';
  static const productDetails = '/cart/product-details';
  static const checkout = '/checkout';
  static const addressSelection = '/checkout/address';
  static const addEditAddress = '/checkout/address/edit';
  static const mapPicker = '/checkout/map';
  static const paymentMethod = '/checkout/payment';
  static const orderConfirmation = '/checkout/confirmation/:id';
  static const orderTracking = '/order/:id/tracking';
  static const orderDetail = '/order/:id';
  static const orderHistory = '/orders';
  static const rateOrder = '/order/:id/rate';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const changePhone = '/profile/change-phone';
  static const verifyPhoneOtp = '/profile/change-phone/otp';
  static const addressBook = '/profile/addresses';
  static const addressBookAddMap = '/profile/address-book/add/map';
  static const addressBookAddDetails = '/profile/address-book/add/details';
  static const addressBookEditMap = '/profile/address-book/edit/map';
  static const addressBookEditDetails = '/profile/address-book/edit/details';
  static const favourites = '/profile/favourites';
  static const discountPoints = '/profile/discount-points';

  static const settings = '/settings';
  static const marketsList = '/markets';
  static const marketDetail = '/market/:id';
  static const helpSupport = '/help';

  static const about = '/about';

  static String serviceListingFor(String type, int sectionId) => '/service-listing/$type?sectionId=$sectionId';
  static String restaurantDetailFor(String id) => '/restaurant/$id';
  static String restaurantRateFor(String id) => '/restaurant/$id/rate';
  static String restaurantSearchFor(String id) => '/restaurant/$id/search';
  static String marketDetailFor(String id) => '/market/$id';
  static String orderDetailFor(String id) => '/order/$id';
  static String orderConfirmationFor(String id) => '/checkout/confirmation/$id';
  static String orderTrackingFor(String id) => '/order/$id/tracking';
}
