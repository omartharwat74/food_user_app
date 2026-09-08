import 'package:go_router/go_router.dart';
import 'package:food_user_app/features/profile/presentation/pages/verify_phone_otp_args.dart';

import 'package:food_user_app/features/auth/presentation/pages/complete_profile_args.dart';

import 'route_names.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/auth/presentation/pages/auth_entry_screen.dart';
import '../../features/auth/presentation/pages/phone_auth_screen.dart';
import '../../features/auth/presentation/pages/mock_otp_screen.dart';
import '../../features/auth/presentation/pages/complete_profile_screen.dart';
import '../../features/auth/presentation/pages/terms_and_conditions_screen.dart';
import '../../features/main/presentation/pages/main_layout.dart';
import '../../features/home/presentation/pages/search_screen.dart';
import '../../features/home/presentation/pages/search_results_screen.dart';
import '../../features/restaurant/presentation/models/restaurant_detail_args.dart';
import '../../features/restaurant/presentation/pages/restaurant_detail_screen.dart';
import '../../features/restaurant/presentation/pages/restaurant_rate_screen.dart';
import '../../features/restaurant/presentation/pages/restaurant_search_screen.dart';
import '../../features/restaurant/presentation/pages/menu_item_detail_screen.dart';
import '../../features/restaurant/presentation/cubit/product_detail_cubit.dart';
import '../../features/restaurant/domain/entities/menu_item.dart';
import '../../features/cart/presentation/pages/cart_screen.dart';
import '../../features/product/presentation/pages/product_details_screen.dart';
import '../../features/checkout/presentation/pages/checkout_screen.dart';
import '../../features/checkout/domain/entities/map_picker_result.dart';
import '../../features/checkout/presentation/pages/address_selection_screen.dart';
import '../../features/checkout/presentation/pages/add_edit_address_screen.dart';
import '../../features/checkout/presentation/pages/map_picker_screen.dart';
import '../../features/checkout/presentation/pages/payment_method_screen.dart';
import '../../features/checkout/presentation/pages/order_confirmation_screen.dart';
import '../../features/order/presentation/pages/order_tracking_screen.dart';
import '../../features/order/presentation/pages/order_detail_screen.dart';
import '../../features/order/presentation/pages/order_history_screen.dart';
import '../../features/order/presentation/pages/rate_order_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/profile/presentation/pages/edit_profile_screen.dart';
import '../../features/profile/presentation/pages/change_phone_screen.dart';
import '../../features/profile/presentation/pages/verify_phone_otp_screen.dart';
import '../../features/profile/presentation/pages/address_book_screen.dart';
import '../../features/profile/presentation/pages/add_edit_address_screen.dart'
    as profile_address;
import '../../features/profile/presentation/pages/discount_points_screen.dart';
import '../../features/profile/presentation/pages/favourites_screen.dart';

import '../../features/profile/presentation/pages/settings_screen.dart';
import '../../features/support/presentation/pages/help_support_screen.dart';
import '../../features/support/presentation/pages/about_screen.dart';
import '../../features/service_listing/presentation/models/service_listing_type.dart';
import '../../features/service_listing/presentation/pages/service_listing_screen.dart';
import '../../features/search/presentation/pages/unified_results_screen.dart';
import '../../features/search/presentation/models/results_config.dart';
import '../../features/market/presentation/pages/markets_list_screen.dart';
import '../../features/market/presentation/pages/market_details_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/features/home/presentation/cubit/home_cubits.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static final router = GoRouter(
    // Auth UI Preview Mode: start from splash for design review.
    // TODO: Decide startup route once real auth/onboarding is ready.
    initialLocation: RouteNames.splash,
    // TODO: add redirect guard (auth check)
    routes: [
      GoRoute(path: RouteNames.splash, builder: (c, s) => const SplashScreen()),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (c, s) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.authEntry,
        builder: (c, s) => const AuthEntryScreen(),
      ),
      GoRoute(
        path: RouteNames.phoneAuth,
        builder: (c, s) {
          final args = s.extra is PhoneAuthArgs
              ? s.extra as PhoneAuthArgs
              : const PhoneAuthArgs();
          return PhoneAuthScreen(args: args);
        },
      ),
      GoRoute(
        path: RouteNames.mockOtp,
        builder: (c, s) {
          final args = s.extra is MockOtpArgs
              ? s.extra as MockOtpArgs
              : const MockOtpArgs(phoneNumber: '');
          return MockOtpScreen(args: args);
        },
      ),
      GoRoute(
        path: RouteNames.completeProfile,
        builder: (c, s) {
          if (s.extra is CompleteProfileArgs) {
            final args = s.extra as CompleteProfileArgs;
            return CompleteProfileScreen(
              registrationToken: args.registrationToken,
              requiredFields: args.requiredFields,
            );
          }
          final registrationToken = s.extra is String ? s.extra as String : '';
          return CompleteProfileScreen(
            registrationToken: registrationToken,
            requiredFields: const [],
          );
        },
      ),
      GoRoute(
        path: RouteNames.termsAndConditions,
        builder: (c, s) => const TermsAndConditionsScreen(),
      ),
      GoRoute(path: RouteNames.home, builder: (c, s) => const MainLayout()),
      GoRoute(path: RouteNames.search, builder: (c, s) => const SearchScreen()),
      GoRoute(
        path: RouteNames.searchResults,
        builder: (c, s) => const SearchResultsScreen(),
      ),
      GoRoute(
        path: RouteNames.serviceListing,
        builder: (c, s) {
          final sectionIdStr = s.uri.queryParameters['sectionId'];
          final sectionId = int.tryParse(sectionIdStr ?? '1') ?? 1;

          return MultiBlocProvider(
            providers: [
              BlocProvider<TagsCubit>(create: (_) => sl<TagsCubit>()),
              BlocProvider<StoresCubit>(create: (_) => sl<StoresCubit>()),
            ],
            child: ServiceListingScreen(
              type: ServiceListingType.fromPathSegment(s.pathParameters['type']),
              sectionId: sectionId,
            ),
          );
        },
      ),
      GoRoute(
        path: RouteNames.restaurantList,
        builder: (c, s) => MultiBlocProvider(
          providers: [
            BlocProvider<TagsCubit>(create: (_) => sl<TagsCubit>()),
            BlocProvider<StoresCubit>(create: (_) => sl<StoresCubit>()),
          ],
          child: const ServiceListingScreen(type: ServiceListingType.restaurants),
        ),
      ),
      GoRoute(
        path: RouteNames.restaurantDetail,
        builder: (c, s) => RestaurantDetailScreen(
          restaurantId: s.pathParameters['id'] ?? 'az-al-sham',
          restaurant: s.extra is RestaurantDetailArgs
              ? s.extra as RestaurantDetailArgs
              : null,
        ),
      ),
      GoRoute(
        path: RouteNames.restaurantRate,
        builder: (c, s) => RestaurantRateScreen(
          restaurantId: s.pathParameters['id'] ?? 'az-al-sham',
        ),
      ),
      GoRoute(
        path: RouteNames.restaurantSearch,
        builder: (c, s) => RestaurantSearchScreen(
          restaurantId: s.pathParameters['id'] ?? 'az-al-sham',
        ),
      ),
      GoRoute(
        path: RouteNames.marketsList,
        builder: (c, s) => const MarketsListScreen(),
      ),
      GoRoute(
        path: RouteNames.marketDetail,
        builder: (c, s) => MarketDetailsScreen(
          marketId: s.pathParameters['id'] ?? '',
        ),
      ),

      GoRoute(
        path: RouteNames.unifiedResults,
        builder: (c, s) {
          final config = s.extra is ResultsConfig
              ? s.extra as ResultsConfig
              : const ResultsConfig();
          return UnifiedResultsScreen(config: config);
        },
      ),
      GoRoute(
        path: RouteNames.menuItemDetail,
        builder: (c, s) {
          final item = s.extra as MenuItem;
          return BlocProvider<ProductDetailCubit>(
            create: (_) => sl<ProductDetailCubit>()..fetchProductDetails(item.id),
            child: MenuItemDetailScreen(item: item),
          );
        },
      ),
      GoRoute(path: RouteNames.cart, builder: (c, s) => const CartScreen()),
      GoRoute(
        path: RouteNames.productDetails,
        builder: (c, s) {
          final item = s.extra is MenuItem
              ? s.extra as MenuItem
              : const MenuItem(
                  id: 'burger-combo',
                  name: 'Burger meal with fries offer',
                  description:
                      'Fresh burger sandwich with grilled beef and special sauce, served with fries.',
                  price: 200,
                  originalPrice: 200,
                  imageUrl: '',
                  available: true,
                );
          return BlocProvider<ProductDetailCubit>(
            create: (context) => sl<ProductDetailCubit>()..fetchProductDetails(item.id),
            child: ProductDetailsScreen(item: item),
          );
        },
      ),
      GoRoute(
        path: RouteNames.checkout,
        builder: (c, s) => const CheckoutScreen(),
      ),
      GoRoute(
        path: RouteNames.addressSelection,
        builder: (c, s) => const AddressSelectionScreen(),
      ),
      GoRoute(
        path: RouteNames.addEditAddress,
        builder: (c, s) {
          final result = s.extra is MapPickerResult
              ? s.extra as MapPickerResult
              : null;
          return AddEditAddressScreen(mapResult: result);
        },
      ),
      GoRoute(
        path: RouteNames.mapPicker,
        builder: (c, s) {
          final args = s.extra is MapPickerArgs
              ? s.extra as MapPickerArgs
              : const MapPickerArgs();
          return MapPickerScreen.fromArgs(args);
        },
      ),
      GoRoute(
        path: RouteNames.paymentMethod,
        builder: (c, s) => const PaymentMethodScreen(),
      ),
      GoRoute(
        path: RouteNames.orderConfirmation,
        builder: (c, s) {
          final orderId = s.pathParameters['id'] ?? '';
          return OrderConfirmationScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: RouteNames.orderTracking,
        builder: (c, s) {
          final orderId = s.pathParameters['id'] ?? '';
          return OrderTrackingScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: RouteNames.orderDetail,
        builder: (c, s) {
          final orderId = s.pathParameters['id'] ?? '';
          final status =
              s.extra as OrderDetailsStatus? ??
              OrderDetailsStatus.waitingAcceptance;
          return OrderDetailsScreen(
            orderId: orderId,
            status: status,
          );
        },
      ),
      GoRoute(
        path: RouteNames.orderHistory,
        builder: (c, s) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: RouteNames.rateOrder,
        builder: (c, s) => const RateOrderScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (c, s) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        builder: (c, s) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.changePhone,
        builder: (c, s) => const ChangePhoneScreen(),
      ),
      GoRoute(
        path: RouteNames.verifyPhoneOtp,
        builder: (c, s) {
          if (s.extra is VerifyPhoneOtpArgs) {
            return VerifyPhoneOtpScreen(args: s.extra as VerifyPhoneOtpArgs);
          }
          final phone = s.extra is String ? s.extra as String : '';
          return VerifyPhoneOtpScreen(args: VerifyPhoneOtpArgs(phoneNumber: phone));
        },
      ),
      GoRoute(
        path: RouteNames.addressBook,
        builder: (c, s) => const AddressBookScreen(),
      ),
      GoRoute(
        path: RouteNames.addressBookAddMap,
        builder: (c, s) => const MapPickerScreen(mode: MapPickerMode.add),
      ),
      GoRoute(
        path: RouteNames.addressBookAddDetails,
        builder: (c, s) {
          final args = s.extra is profile_address.ProfileAddressDetailsArgs
              ? s.extra as profile_address.ProfileAddressDetailsArgs
              : null;
          final result =
              args?.mapResult ??
              (s.extra is MapPickerResult ? s.extra as MapPickerResult : null);
          return profile_address.AddressDetailsScreen(
            mode: profile_address.AddressFlowMode.add,
            mapResult: result,
          );
        },
      ),
      GoRoute(
        path: RouteNames.addressBookEditMap,
        builder: (c, s) {
          final args = s.extra is MapPickerArgs
              ? s.extra as MapPickerArgs
              : const MapPickerArgs(mode: MapPickerMode.edit);
          return MapPickerScreen.fromArgs(args);
        },
      ),
      GoRoute(
        path: RouteNames.addressBookEditDetails,
        builder: (c, s) {
          final args = s.extra is profile_address.ProfileAddressDetailsArgs
              ? s.extra as profile_address.ProfileAddressDetailsArgs
              : null;
          final result =
              args?.mapResult ??
              (s.extra is MapPickerResult ? s.extra as MapPickerResult : null);
          return profile_address.AddressDetailsScreen(
            mode: profile_address.AddressFlowMode.edit,
            addressId: args?.addressId,
            mapResult: result,
          );
        },
      ),
      GoRoute(
        path: RouteNames.favourites,
        builder: (c, s) => const FavouritesScreen(),
      ),
      GoRoute(
        path: RouteNames.discountPoints,
        builder: (c, s) => const DiscountPointsScreen(),
      ),

      GoRoute(
        path: RouteNames.settings,
        builder: (c, s) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.helpSupport,
        builder: (c, s) {
          final ticketId = s.extra is String ? s.extra as String : null;
          return HelpSupportScreen(ticketId: ticketId);
        },
      ),
      GoRoute(path: RouteNames.about, builder: (c, s) => const AboutScreen()),
    ],
  );
}
