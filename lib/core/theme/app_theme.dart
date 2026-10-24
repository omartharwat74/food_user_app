import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const _fontFamilyArabic = 'ExpoArabic';

  /// Arabic typography (ExpoArabic). Used when [Locale.languageCode] is `ar`.
  static final ThemeData lightArabic = _buildLight(
    fontFamily: _fontFamilyArabic,
  );

  /// English and other Latin locales — uses the platform default typeface.
  static final ThemeData lightEnglish = _buildLight(fontFamily: null);

  static final ThemeData darkArabic = _buildDark(fontFamily: _fontFamilyArabic);

  static final ThemeData darkEnglish = _buildDark(fontFamily: null);

  static ThemeData themeFor(Locale locale, Brightness brightness) {
    final arabic = locale.languageCode == 'ar';
    if (brightness == Brightness.dark) {
      return arabic ? darkArabic : darkEnglish;
    }
    return arabic ? lightArabic : lightEnglish;
  }

  static ThemeData _buildLight({String? fontFamily}) => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: AppColors.lightScaffold,
    cardColor: AppColors.lightSurface,
    hintColor: AppColors.lightHint,
    iconTheme: const IconThemeData(color: AppColors.lightOnSurface),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.lightOnSurface,
        height: 1.4,
      ),
      iconTheme: const IconThemeData(color: AppColors.lightOnSurface),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.lightSurface,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.text,
      secondary: AppColors.secondary,
      onSecondary: AppColors.lightOnSecondary,
      error: AppColors.error,
      onError: AppColors.text,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
      onSurfaceVariant: AppColors.lightParagraph,
      outline: AppColors.lightOutline,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.text,
      contentTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.lightOnSurface,
      ),
      behavior: SnackBarBehavior.floating,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.textSelectionHandle,
      selectionColor: AppColors.textSelectionHighlight,
      selectionHandleColor: AppColors.textSelectionHandle,
    ),
  );

  static ThemeData _buildDark({String? fontFamily}) => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: AppColors.darkScaffold,
    cardColor: AppColors.darkSurface,
    hintColor: AppColors.darkHint,
    iconTheme: const IconThemeData(color: AppColors.text),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.4,
      ),
      iconTheme: const IconThemeData(color: AppColors.text),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkSurface,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.text,
      secondary: AppColors.secondary,
      onSecondary: AppColors.darkScaffold,
      error: AppColors.error,
      onError: AppColors.text,
      surface: AppColors.darkSurface,
      onSurface: AppColors.text,
      onSurfaceVariant: AppColors.darkParagraph,
      outline: AppColors.darkOutline,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.lightOnSurface,
      contentTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.text,
      ),
      behavior: SnackBarBehavior.floating,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.textSelectionHandle,
      selectionColor: AppColors.textSelectionHighlight,
      selectionHandleColor: AppColors.textSelectionHandle,
    ),
  );
}
