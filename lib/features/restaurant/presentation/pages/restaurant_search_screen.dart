import 'package:flutter/material.dart';

import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class RestaurantSearchScreen extends StatelessWidget {
  const RestaurantSearchScreen({this.restaurantId = 'az-al-sham', super.key});

  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBar(title: Text(l10n.searchTitle)),
      body: Center(child: Text(l10n.connectingToApi)),
    );
  }
}
