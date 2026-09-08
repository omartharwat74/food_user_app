import 'package:food_user_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:food_user_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:food_user_app/features/profile/domain/usecases/get_cached_profile_usecase.dart';
import 'package:food_user_app/features/profile/domain/usecases/get_cached_settings_usecase.dart';
import 'package:food_user_app/features/user/data/datasources/user_local_data_source.dart';

import 'package:food_user_app/features/home/domain/repositories/home_repository.dart';
import 'package:food_user_app/features/home/domain/usecases/get_general_settings_usecase.dart';
import 'package:food_user_app/features/home/domain/usecases/home_usecases.dart';
import 'package:food_user_app/features/home/presentation/cubit/home_cubits.dart';
import 'package:food_user_app/features/home/domain/usecases/get_nearby_restaurants_usecase.dart';
import 'package:food_user_app/features/profile/domain/usecases/get_favourites_usecase.dart';
import 'package:food_user_app/features/profile/domain/usecases/toggle_favourite_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:food_user_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:food_user_app/features/profile/domain/usecases/change_phone_usecases.dart';
import 'package:food_user_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:food_user_app/features/profile/domain/usecases/get_settings_usecase.dart';
import 'package:food_user_app/features/profile/domain/usecases/update_settings_usecase.dart';
import 'package:food_user_app/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_user_app/features/market/data/datasources/market_remote_data_source.dart';
import 'package:food_user_app/features/market/data/repositories/market_repository_impl.dart';
import 'package:food_user_app/features/market/domain/repositories/market_repository.dart';
import 'package:food_user_app/features/market/domain/usecases/get_markets_usecase.dart';
import 'package:food_user_app/features/market/domain/usecases/get_market_detail_usecase.dart';
import 'package:food_user_app/features/market/domain/usecases/get_market_categories_usecase.dart';
import 'package:food_user_app/features/market/domain/usecases/get_market_sub_categories_usecase.dart';
import 'package:food_user_app/features/market/domain/usecases/get_market_products_usecase.dart';
import 'package:food_user_app/features/market/domain/usecases/get_market_offers_usecase.dart';
import 'package:food_user_app/features/market/domain/usecases/get_favorite_markets_usecase.dart';
import 'package:food_user_app/features/market/domain/usecases/toggle_favorite_market_usecase.dart';
import 'package:food_user_app/features/market/presentation/cubit/markets_list_cubit.dart';
import 'package:food_user_app/features/market/presentation/cubit/market_details_cubit.dart';
import 'package:food_user_app/features/market/presentation/cubit/market_catalog_cubit.dart';
import 'package:food_user_app/features/market/presentation/cubit/market_favorite_cubit.dart';


import 'package:food_user_app/core/network/dio_client.dart';
import 'package:food_user_app/core/network/interceptors/auth_interceptor.dart';
import 'package:food_user_app/core/network/interceptors/global_error_interceptor.dart';
import 'package:food_user_app/core/network/interceptors/logging_interceptor.dart';
import 'package:food_user_app/core/network/interceptors/retry_interceptor.dart';
import 'package:food_user_app/core/network/interceptors/language_interceptor.dart';
import 'package:food_user_app/core/network/network_info.dart';
import 'package:food_user_app/core/storage/token_storage.dart';
import 'package:food_user_app/core/services/push_notification_service.dart';
import 'package:food_user_app/core/services/snackbar_service.dart';
import 'package:food_user_app/features/location/data/services/location_service_impl.dart';
import 'package:food_user_app/features/location/domain/services/location_service.dart';

import 'package:food_user_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:food_user_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:food_user_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:food_user_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:food_user_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:food_user_app/features/auth/domain/usecases/send_phone_otp_usecase.dart';
import 'package:food_user_app/features/auth/domain/usecases/verify_phone_otp_usecase.dart';
import 'package:food_user_app/features/auth/domain/usecases/complete_registration_usecase.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:food_user_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:food_user_app/features/checkout/domain/usecases/get_saved_addresses_usecase.dart';
import 'package:food_user_app/features/checkout/domain/usecases/save_address_usecase.dart';
import 'package:food_user_app/features/checkout/domain/usecases/update_address_usecase.dart';
import 'package:food_user_app/features/checkout/domain/usecases/delete_address_usecase.dart';
import 'package:food_user_app/features/checkout/domain/usecases/set_default_address_usecase.dart';
import 'package:food_user_app/features/user/data/datasources/user_remote_data_source.dart';
import 'package:food_user_app/features/user/data/repositories/user_repository_impl.dart';
import 'package:food_user_app/features/user/domain/repositories/user_repository.dart';
import 'package:food_user_app/features/address/data/datasources/address_remote_data_source.dart';
import 'package:food_user_app/features/address/data/repositories/address_repository_impl.dart';
import 'package:food_user_app/features/address/domain/repositories/address_repository.dart';
import 'package:food_user_app/features/home/data/datasources/banner_remote_data_source.dart';
import 'package:food_user_app/features/home/data/repositories/banner_repository_impl.dart';
import 'package:food_user_app/features/home/domain/repositories/banner_repository.dart';
import 'package:food_user_app/features/home/presentation/cubit/banner_cubit.dart';
import 'package:food_user_app/features/search/data/datasources/search_remote_data_source.dart';
import 'package:food_user_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:food_user_app/features/search/domain/repositories/search_repository.dart';
import 'package:food_user_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:food_user_app/features/restaurant/data/datasources/restaurant_remote_data_source.dart';
import 'package:food_user_app/features/restaurant/data/repositories/restaurant_repository_impl.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'package:food_user_app/features/restaurant/domain/usecases/get_restaurants_by_category_usecase.dart';
import 'package:food_user_app/features/restaurant/domain/usecases/get_restaurant_detail_usecase.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/restaurant_list_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/restaurant_detail_cubit.dart';
import 'package:food_user_app/features/restaurant/data/datasources/menu_remote_data_source.dart';
import 'package:food_user_app/features/restaurant/data/repositories/menu_repository_impl.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/menu_repository.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/menu_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/favorite_cubit.dart';

import 'package:food_user_app/features/store/presentation/cubit/store_detail_cubit.dart';
import 'package:food_user_app/features/search/presentation/cubit/unified_results_cubit.dart';
import 'package:food_user_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:food_user_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:food_user_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:food_user_app/features/checkout/domain/usecases/apply_promo_usecase.dart';
import 'package:food_user_app/features/support/data/datasources/support_remote_data_source.dart';
import 'package:food_user_app/features/support/data/repositories/support_repository_impl.dart';
import 'package:food_user_app/features/support/domain/repositories/support_repository.dart';
import 'package:food_user_app/features/support/domain/usecases/create_ticket_usecase.dart';
import 'package:food_user_app/features/support/domain/usecases/get_messages_usecase.dart';
import 'package:food_user_app/features/support/domain/usecases/send_message_usecase.dart';
import 'package:food_user_app/features/support/presentation/cubit/chat_cubit.dart';
import 'package:food_user_app/features/support/presentation/cubit/support_ticket_cubit.dart';

import 'package:food_user_app/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:food_user_app/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:food_user_app/features/payment/domain/repositories/payment_repository.dart';
import 'package:food_user_app/features/payment/domain/usecases/checkout_usecase.dart';
import 'package:food_user_app/features/payment/domain/usecases/delete_card_usecase.dart';
import 'package:food_user_app/features/payment/domain/usecases/get_saved_cards_usecase.dart';
import 'package:food_user_app/features/payment/domain/usecases/save_card_usecase.dart';
import 'package:food_user_app/features/payment/presentation/cubit/checkout_cubit.dart';
import 'package:food_user_app/features/payment/presentation/cubit/payment_method_cubit.dart';
import 'package:food_user_app/features/checkout/domain/usecases/place_order_usecase.dart';
import 'package:food_user_app/features/order/data/datasources/order_remote_data_source.dart';
import 'package:food_user_app/features/order/data/repositories/order_repository_impl.dart';
import 'package:food_user_app/features/order/domain/repositories/order_repository.dart';
import 'package:food_user_app/features/order/domain/usecases/get_order_detail_usecase.dart';
import 'package:food_user_app/features/order/domain/usecases/get_order_history_usecase.dart';
import 'package:food_user_app/features/order/domain/usecases/get_order_tracking_usecase.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_tracking_cubit.dart';

final sl = GetIt.instance;

/// Initializes the service locator.
///
/// Pass [prefs] in from `main.dart` so the same instance is shared with
/// [LocaleController] and anything else that needs SharedPreferences.
Future<void> init({SharedPreferences? prefs}) async {
  // ── External dependencies ───────────────────────────────────────────────
  if (prefs != null && !sl.isRegistered<SharedPreferences>()) {
    sl.registerLazySingleton<SharedPreferences>(() => prefs);
  }
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // ── Storage ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton<TokenStorage>(
    () => TokenStorage(storage: sl<FlutterSecureStorage>()),
  );

  // ── Network ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );

  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(
      sl<TokenStorage>(),
      getDio: () => sl<DioClient>().dio,
    ),
  );
  sl.registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor());

  // RetryInterceptor needs a Dio reference but is a pass-through in Phase 1
  // (see RetryInterceptor TODO). We give it a throwaway Dio here; once a real
  // retry policy is implemented, switch this to share `sl<DioClient>().dio`.
  sl.registerLazySingleton<RetryInterceptor>(
    () => RetryInterceptor(dio: Dio()),
  );

  sl.registerLazySingleton<LanguageInterceptor>(
    () => LanguageInterceptor(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<GlobalErrorHandlerInterceptor>(
    () => GlobalErrorHandlerInterceptor(),
  );

  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      authInterceptor: sl<AuthInterceptor>(),
      loggingInterceptor: sl<LoggingInterceptor>(),
      retryInterceptor: sl<RetryInterceptor>(),
      globalErrorHandlerInterceptor: sl<GlobalErrorHandlerInterceptor>(),
      languageInterceptor: sl<LanguageInterceptor>(),
    ),
  );

  // ── UI Services ─────────────────────────────────────────────────────────  // Services
  sl.registerLazySingleton<SnackbarService>(() => SnackbarService());
  sl.registerLazySingleton<LocationService>(() => LocationServiceImpl());
  sl.registerLazySingleton<PushNotificationService>(() => PushNotificationService());

  // ── Auth local cache ─────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      prefs: sl<SharedPreferences>(),
      tokenStorage: sl<TokenStorage>(),
    ),
  );

  // ── Auth remote (login still mock; register uses real API) ───────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  // Unified phone login/register (API v2)
  sl.registerLazySingleton(() => SendPhoneOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyPhoneOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
    () => CompleteRegistrationUseCase(sl<AuthRepository>()),
  );

  // Single AuthBloc shared across splash/login/register so the cached
  // session state is consistent. Provided globally in `app.dart`.
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      logoutUseCase: sl<LogoutUseCase>(),
      sendPhoneOtpUseCase: sl<SendPhoneOtpUseCase>(),
      verifyPhoneOtpUseCase: sl<VerifyPhoneOtpUseCase>(),
      completeRegistrationUseCase: sl<CompleteRegistrationUseCase>(),
      authRepository: sl<AuthRepository>(),
    ),
  );

  // Profile UseCases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetSettingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSettingsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl()));
  
  sl.registerLazySingleton(() => GetCachedProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedSettingsUseCase(sl()));

  // Phone cycle use cases
  sl.registerLazySingleton(() => SendCurrentPhoneOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyCurrentPhoneOtpUseCase(sl()));
  sl.registerLazySingleton(() => SendNewPhoneOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyNewPhoneOtpUseCase(sl()));

  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
      getSettingsUseCase: sl(),
      updateSettingsUseCase: sl(),
      deleteAccountUseCase: sl(),
      getCachedProfileUseCase: sl(),
      getCachedSettingsUseCase: sl(),
      sendCurrentPhoneOtpUseCase: sl(),
      verifyCurrentPhoneOtpUseCase: sl(),
      sendNewPhoneOtpUseCase: sl(),
      verifyNewPhoneOtpUseCase: sl(),
    ),
  );

  // ── Saved addresses ───────────────────────────────────────────────────────
  sl.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<AddressRepository>(
    () =>
        AddressRepositoryImpl(remoteDataSource: sl<AddressRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetSavedAddressesUseCase(sl<AddressRepository>()));
  sl.registerLazySingleton(() => SaveAddressUseCase(sl<AddressRepository>()));
  sl.registerLazySingleton(() => UpdateAddressUseCase(sl<AddressRepository>()));
  sl.registerLazySingleton(() => DeleteAddressUseCase(sl<AddressRepository>()));
  sl.registerLazySingleton(() => SetDefaultAddressUseCase(sl<AddressRepository>()));

  // ── User Profile & Settings ────────────────────────────────────────────────
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(prefs: sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // ── Banners & Search ───────────────────────────────────────────────────────
  sl.registerLazySingleton<BannerRemoteDataSource>(
    () => BannerRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<BannerRepository>(
    () => BannerRepositoryImpl(remoteDataSource: sl<BannerRemoteDataSource>()),
  );
  sl.registerFactory<BannerCubit>(
    () => BannerCubit(bannerRepository: sl<BannerRepository>()),
  );

  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl<SearchRemoteDataSource>()),
  );
  sl.registerFactory<SearchCubit>(
    () => SearchCubit(
      searchRepository: sl<SearchRepository>(),
      getTagsUseCase: sl<GetTagsUseCase>(),
    ),
  );

  // ── Categories & Home ──────────────────────────────────────────────────────
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl<HomeRemoteDataSource>()),
  );
  
  // Use cases
  sl.registerLazySingleton(() => GetGeneralSettingsUseCase(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetSectionsUseCase(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetTagsUseCase(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetStoresUseCase(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetMajorStoresUseCase(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetSpotlightsUseCase(sl<HomeRepository>()));

  // Cubits
  sl.registerFactory<SettingsCubit>(
    () => SettingsCubit(getGeneralSettingsUseCase: sl<GetGeneralSettingsUseCase>()),
  );
  sl.registerFactory<SectionsCubit>(
    () => SectionsCubit(getSectionsUseCase: sl<GetSectionsUseCase>()),
  );
  sl.registerFactory<TagsCubit>(
    () => TagsCubit(getTagsUseCase: sl<GetTagsUseCase>()),
  );
  sl.registerFactory<StoresCubit>(
    () => StoresCubit(getStoresUseCase: sl<GetStoresUseCase>()),
  );
  sl.registerFactory<MajorStoresCubit>(
    () => MajorStoresCubit(getMajorStoresUseCase: sl<GetMajorStoresUseCase>()),
  );
  sl.registerFactory<SpotlightsCubit>(
    () => SpotlightsCubit(getSpotlightsUseCase: sl<GetSpotlightsUseCase>()),
  );

  // ── Restaurants ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<RestaurantRemoteDataSource>(
    () => RestaurantRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepositoryImpl(
      remoteDataSource: sl<RestaurantRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton(
    () =>
        GetRestaurantsByCategoryUseCase(repository: sl<RestaurantRepository>()),
  );
  sl.registerLazySingleton(
    () => GetRestaurantDetailUseCase(repository: sl<RestaurantRepository>()),
  );
  sl.registerLazySingleton(
    () => GetNearbyRestaurantsUseCase(sl<RestaurantRepository>()),
  );
  sl.registerFactory<RestaurantListCubit>(
    () => RestaurantListCubit(
      getNearbyRestaurantsUseCase: sl<GetNearbyRestaurantsUseCase>(),
    ),
  );
  sl.registerFactory<RestaurantDetailCubit>(
    () => RestaurantDetailCubit(
      restaurantRepository: sl<RestaurantRepository>(),
      menuRepository: sl<MenuRepository>(),
    ),
  );

  sl.registerLazySingleton<MenuRemoteDataSource>(
    () => MenuRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(remoteDataSource: sl<MenuRemoteDataSource>()),
  );
  sl.registerFactory<MenuCubit>(
    () => MenuCubit(menuRepository: sl<MenuRepository>()),
  );

  sl.registerLazySingleton(
    () => GetFavouritesUseCase(sl<RestaurantRepository>()),
  );
  sl.registerLazySingleton(
    () => ToggleFavouriteUseCase(sl<RestaurantRepository>()),
  );
  sl.registerFactory<FavoriteCubit>(
    () => FavoriteCubit(restaurantRepository: sl<RestaurantRepository>()),
  );


  sl.registerFactory<StoreDetailCubit>(
    () => StoreDetailCubit(
      restaurantRepository: sl<RestaurantRepository>(),
      menuRepository: sl<MenuRepository>(),
    ),
  );

  sl.registerFactory<UnifiedResultsCubit>(
    () => UnifiedResultsCubit(menuRepository: sl<MenuRepository>()),
  );

  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl<CartRemoteDataSource>()),
  );
  
  sl.registerLazySingleton(() => GetCartUseCase(repository: sl<CartRepository>()));
  sl.registerLazySingleton(() => AddToCartUseCase(repository: sl<CartRepository>()));
  sl.registerLazySingleton(() => UpdateCartItemUseCase(repository: sl<CartRepository>()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(repository: sl<CartRepository>()));
  sl.registerLazySingleton(() => ClearCartUseCase(repository: sl<CartRepository>()));
  sl.registerLazySingleton(() => ApplyPromoUseCase(repository: sl<CartRepository>()));

  sl.registerFactory<CartCubit>(
    () => CartCubit(
      getCartUseCase: sl<GetCartUseCase>(),
      addToCartUseCase: sl<AddToCartUseCase>(),
      updateCartItemUseCase: sl<UpdateCartItemUseCase>(),
      removeFromCartUseCase: sl<RemoveFromCartUseCase>(),
      clearCartUseCase: sl<ClearCartUseCase>(),
      applyPromoUseCase: sl<ApplyPromoUseCase>(),
    ),
  );

  // ── Payment & Checkout ────────────────────────────────────────────────────
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(sl<PaymentRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetSavedCardsUseCase(sl<PaymentRepository>()));
  sl.registerLazySingleton(() => SaveCardUseCase(sl<PaymentRepository>()));
  sl.registerLazySingleton(() => DeleteCardUseCase(sl<PaymentRepository>()));
  sl.registerLazySingleton(() => CheckoutUseCase(sl<PaymentRepository>()));
  
  sl.registerFactory<PaymentMethodCubit>(
    () => PaymentMethodCubit(
      getSavedCardsUseCase: sl<GetSavedCardsUseCase>(),
      saveCardUseCase: sl<SaveCardUseCase>(),
      deleteCardUseCase: sl<DeleteCardUseCase>(),
    ),
  );
  sl.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(placeOrderUseCase: sl<PlaceOrderUseCase>()),
  );

  // ── Order & Tracking ──────────────────────────────────────────────────────
  importOrderDependencies();
  importSupportDependencies();
  importMarketDependencies();
}

void importMarketDependencies() {
  // Data Sources
  sl.registerLazySingleton<MarketRemoteDataSource>(
    () => MarketRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
      tokenStorage: sl<TokenStorage>(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<MarketRepository>(
    () => MarketRepositoryImpl(remoteDataSource: sl<MarketRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetMarketsUseCase(sl<MarketRepository>()));
  sl.registerLazySingleton(() => GetMarketDetailUseCase(sl<MarketRepository>()));
  sl.registerLazySingleton(() => GetMarketCategoriesUseCase(sl<MarketRepository>()));
  sl.registerLazySingleton(() => GetMarketSubCategoriesUseCase(sl<MarketRepository>()));
  sl.registerLazySingleton(() => GetMarketProductsUseCase(sl<MarketRepository>()));
  sl.registerLazySingleton(() => GetMarketOffersUseCase(sl<MarketRepository>()));
  sl.registerLazySingleton(() => GetFavoriteMarketsUseCase(sl<MarketRepository>()));
  sl.registerLazySingleton(() => ToggleFavoriteMarketUseCase(sl<MarketRepository>()));

  // Cubits
  sl.registerFactory(() => MarketsListCubit(getMarketsUseCase: sl()));
  sl.registerFactory(() => MarketDetailsCubit(
        getMarketDetailUseCase: sl(),
        getMarketCategoriesUseCase: sl(),
        getMarketOffersUseCase: sl(),
      ));
  sl.registerFactory(() => MarketCatalogCubit(
        getSubCategoriesUseCase: sl(),
        getProductsUseCase: sl(),
      ));
  sl.registerFactory(() => MarketFavoriteCubit(
        getFavoriteMarketsUseCase: sl(),
        toggleFavoriteMarketUseCase: sl(),
      ));
}

void importSupportDependencies() {

  // Data Sources
  sl.registerLazySingleton<SupportRemoteDataSource>(
    () => SupportRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );

  // Repositories
  sl.registerLazySingleton<SupportRepository>(
    () => SupportRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => CreateTicketUseCase(sl()));
  sl.registerLazySingleton(() => GetMessagesUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));

  // Cubits
  sl.registerFactory(() => SupportTicketCubit(sl()));
  sl.registerFactory(() => ChatCubit(sl<GetMessagesUseCase>(), sl<SendMessageUseCase>()));
}

void importOrderDependencies() {
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl<OrderRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => PlaceOrderUseCase(
        orderRepository: sl<OrderRepository>(),
        cartRepository: sl<CartRepository>(),
        paymentRepository: sl<PaymentRepository>(),
        addressRepository: sl<AddressRepository>(),
      ));
  sl.registerLazySingleton(() => GetOrderDetailUseCase(sl<OrderRepository>()));
  sl.registerLazySingleton(() => GetOrderHistoryUseCase(sl<OrderRepository>()));
  sl.registerLazySingleton(() => GetOrderTrackingUseCase(sl<OrderRepository>()));

  sl.registerFactory<OrderTrackingCubit>(
    () => OrderTrackingCubit(getOrderTrackingUseCase: sl<GetOrderTrackingUseCase>()),
  );
}
