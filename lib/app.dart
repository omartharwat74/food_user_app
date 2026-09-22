import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/core/localization/app_locale_scope.dart';
import 'package:food_user_app/core/localization/locale_controller.dart';
import 'package:food_user_app/core/router/app_router.dart';
import 'package:food_user_app/core/theme/app_theme.dart';
import 'package:food_user_app/core/theme/app_theme_scope.dart';
import 'package:food_user_app/core/theme/theme_controller.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:food_user_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:food_user_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_controller.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_scope.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/features/home/presentation/cubit/banner_cubit.dart';
import 'package:food_user_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/favorite_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/payment/presentation/cubit/checkout_cubit.dart';
import 'package:food_user_app/features/payment/presentation/cubit/payment_method_cubit.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.localeController,
    required this.themeController,
    required this.savedAddressesController,
  });

  final LocaleController localeController;
  final ThemeController themeController;
  final SavedAddressesController savedAddressesController;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<ProfileBloc>(
          create: (_) => sl<ProfileBloc>()
            ..add(const GetProfileEvent())
            ..add(const GetSettingsEvent()),
        ),
        BlocProvider<BannerCubit>(
          create: (_) => sl<BannerCubit>()..getActiveBanners(),
        ),
        BlocProvider<SearchCubit>(
          create: (context) => sl<SearchCubit>(),
        ),
        BlocProvider<FavoriteCubit>(
          create: (_) => sl<FavoriteCubit>()..loadFavorites(),
        ),
        BlocProvider<CartCubit>(
          create: (_) => sl<CartCubit>()..loadCart(),
        ),
        BlocProvider<PaymentMethodCubit>(
          create: (_) => sl<PaymentMethodCubit>()..fetchSavedCards(),
        ),
        BlocProvider<CheckoutCubit>(
          create: (_) => sl<CheckoutCubit>(),
        ),
      ],
      child: AppLocaleScope(
        notifier: localeController,
        child: AppThemeScope(
          notifier: themeController,
          child: SavedAddressesScope(
            notifier: savedAddressesController,
            child: ListenableBuilder(
              listenable: Listenable.merge([localeController, themeController]),
              builder: (context, _) {
                final locale = localeController.locale;
                final code = locale.languageCode;
                return MaterialApp.router(
                  scaffoldMessengerKey: AppRouter.scaffoldMessengerKey,
                  onGenerateTitle: (context) =>
                      AppLocalizations.of(context)!.appTitle,
                  locale: locale,
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  localeResolutionCallback: (deviceLocale, supportedLocales) {
                    if (code == 'ar' || code == 'en') {
                      return locale;
                    }
                    return const Locale('en');
                  },
                  theme: code == 'ar'
                      ? AppTheme.lightArabic
                      : AppTheme.lightEnglish,
                  darkTheme: code == 'ar'
                      ? AppTheme.darkArabic
                      : AppTheme.darkEnglish,
                  themeMode: themeController.themeMode,
                  routerConfig: AppRouter.router,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
