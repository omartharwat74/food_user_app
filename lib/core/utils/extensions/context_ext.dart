import 'package:flutter/material.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  Size get screenSize => MediaQuery.sizeOf(this);
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
