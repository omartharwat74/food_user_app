import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_scope.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _minSplashDuration = Duration(milliseconds: 900);

  bool _navigated = false;
  bool _minDelayElapsed = false;
  bool _showErrorRetry = false;
  AuthState? _pendingAuthState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthBloc>().add(const AuthCheckRequested());
    });
    Timer(_minSplashDuration, () {
      if (!mounted) return;
      setState(() => _minDelayElapsed = true);
      _maybeNavigate();
    });
  }

  Future<void> _maybeNavigate() async {
    if (_navigated || !_minDelayElapsed) return;

    // Prevent multiple parallel navigations
    final state = _pendingAuthState;
    if (state is Authenticated) {
      final addressController = SavedAddressesScope.of(context);
      await addressController.loadAddressesIfNeeded();
      if (!mounted) return;

      if (addressController.hasError) {
        if (addressController.hasCachedAddresses) {
          _navigated = true;
          context.go(RouteNames.home);
        } else {
          setState(() => _showErrorRetry = true);
        }
        return;
      }

      _navigated = true;
      if (addressController.addresses.isEmpty) {
        context.go('${RouteNames.addressBookAddMap}?isOnboarding=true');
      } else {
        context.go(RouteNames.home);
      }
    } else if (state is Unauthenticated) {
      _navigated = true;
      context.go(RouteNames.authEntry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          curr is Authenticated || curr is Unauthenticated,
      listener: (context, state) {
        _pendingAuthState = state;
        _maybeNavigate();
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: (width - 200) / 2,
                  top: height * 0.43,
                  child: const AppRasterImage.asset(
                    AppAssets.splashLogo,
                    width: 200,
                    height: 68,
                    fit: BoxFit.contain,
                  ),
                ),
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  bottom: 0,
                  child: const _SplashStripes(),
                ),
                if (_showErrorRetry)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: height * 0.43 + 120,
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          setState(() => _showErrorRetry = false);
                          SavedAddressesScope.of(
                            context,
                          ).loadAddresses().then((_) => _maybeNavigate());
                        },
                        child: const Text(
                          'إعادة المحاولة',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SplashStripes extends StatelessWidget {
  const _SplashStripes();

  static const _stripeHeight = 20.0;
  static const _stripeGap = 6.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : _stripeGap),
          child: const AppRasterImage.asset(
            AppAssets.splashBottomStripe,
            height: _stripeHeight,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        );
      }),
    );
  }
}
