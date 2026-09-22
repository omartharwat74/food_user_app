import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:food_user_app/features/cart/presentation/pages/cart_screen.dart';
import 'package:food_user_app/features/home/presentation/pages/home_screen.dart';
import 'package:food_user_app/features/main/presentation/pages/account_tab_page.dart';
import 'package:food_user_app/features/order/presentation/pages/order_history_screen.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class MainLayout extends StatefulWidget {
  static final GlobalKey<MainLayoutState> globalKey = GlobalKey();

  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  void changeIndex(int index) {
    if (mounted) setState(() => _selectedIndex = index);
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is Unauthenticated && previous is LogoutInProgress,
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go(RouteNames.authEntry);
        }
      },
      builder: (context, state) {
        final tabs = _tabs;
        final body = IndexedStack(
          index: _selectedIndex,
          children: tabs.map((tab) => tab.child).toList(),
        );

        return Scaffold(
          body: SafeArea(
            top: _selectedIndex != 0 && _selectedIndex != 3,
            bottom: false,
            child: body,
          ),
          bottomNavigationBar: _BottomTabBar(
            selectedIndex: _selectedIndex,
            tabs: tabs,
            onSelected: (index) => setState(() => _selectedIndex = index),
          ),
        );
      },
    );
  }

  List<_MainTab> get _tabs {
    return [
      const _MainTab(
        labelKey: _MainTabLabel.home,
        iconAsset: AppAssets.mainHome,
        child: HomeScreen(),
      ),
      _MainTab(
        labelKey: _MainTabLabel.cart,
        iconAsset: AppAssets.mainCart,
        child: CartScreen(isActive: _selectedIndex == 1),
      ),
      const _MainTab(
        labelKey: _MainTabLabel.orders,
        iconAsset: AppAssets.mainOrders,
        child: OrderHistoryScreen(),
      ),
      const _MainTab(
        labelKey: _MainTabLabel.account,
        iconAsset: AppAssets.mainAccount,
        child: AccountTabPage(),
      ),
    ];
  }
}

class _MainTab {
  const _MainTab({
    required this.labelKey,
    required this.iconAsset,
    required this.child,
  });

  final _MainTabLabel labelKey;
  final String iconAsset;
  final Widget child;
}

enum _MainTabLabel { home, orders, cart, account }

class _BottomTabBar extends StatelessWidget {
  const _BottomTabBar({
    required this.selectedIndex,
    required this.tabs,
    required this.onSelected,
  });

  final int selectedIndex;
  final List<_MainTab> tabs;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        border: Border(
          top: BorderSide(color: AppColors.border(context), width: 0.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          final selected = selectedIndex == index;
          return Expanded(
            child: _BottomTabButton(
              label: _localizedTabLabel(l10n, tab.labelKey),
              iconAsset: tab.iconAsset,
              selected: selected,
              onPressed: () => onSelected(index),
            ),
          );
        }),
      ),
    );
  }

  String _localizedTabLabel(AppLocalizations l10n, _MainTabLabel label) {
    return switch (label) {
      _MainTabLabel.home => l10n.mainTabHome,
      _MainTabLabel.orders => l10n.mainTabOrders,
      _MainTabLabel.cart => l10n.mainTabCart,
      _MainTabLabel.account => l10n.mainTabAccount,
    };
  }
}

class _BottomTabButton extends StatelessWidget {
  const _BottomTabButton({
    required this.label,
    required this.iconAsset,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final String iconAsset;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.paragraph(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                iconAsset,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption(context).copyWith(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                  height: 1.3,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
