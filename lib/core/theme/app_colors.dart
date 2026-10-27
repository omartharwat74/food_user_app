import 'package:flutter/material.dart';

/// Brand and theme tokens. Surfaces and text tones use [BuildContext] so they
/// follow [ThemeMode.system] light/dark [ColorScheme].
class AppColors {
  AppColors._();

  // ── Brand (fixed) ─────────────────────────────────────────────────────────
  static const primary = Color(0xFFA3090F);
  static const text = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const secondary = Color(0xFF2EC4B6);
  static const error = Color(0xFFEC2D30);
  static const success = Color(0xFF0C9D61);
  static const warning = Color(0xFFF1D060);
  static const statusWarning = Color(0xFFEFBE1C);
  static const statusClosed = Color(0xFFA7A7A7);
  static const ratingStar = Color(0xFFFFB800);
  static const facebookBlue = Color(0xFF1877F2);
  static const textSelectionHandle = primary;
  static const textSelectionHighlight = Color(0x33A3090F); // primary ~20% opacity (Light mode)
  static const textSelectionHighlightDark = Color(0x66A3090F); // primary ~40% opacity (Dark mode)
  static const _neutralDarkStroke = Color(0xFF1A1A1A);

  static const flagRed = Color(0xFFCE1126);
  static const transparent = Color(0x00000000);
  static const shadow = Color(0xFF2C2B2B);
  static const shadowStrong = Color(0xFF373737);
  static const accountShadow = Color(0x142C2B2B);
  static const errorTint = Color(0x1AEC2D30);

  static const lightScaffold = Color(0xFFFAFAFA);
  static const lightHint = Color(0xFFB9B9B9);
  static const lightOnSecondary = Color(0xFF1B1B1B);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightOnSurface = Color(0xFF1B1B1B);
  static const lightParagraph = Color(0xFFA7A7A7);
  static const lightOutline = Color(0xFFE5E5E5);

  static const darkScaffold = Color(0xFF080404);
  static const darkHint = Color(0xFF515151);
  static const darkSurface = Color(0xFF0F0F0F);
  static const darkParagraph = Color(0xFF999999);
  static const darkOutline = Color(0xFF1A1A1A);

  static const activeBorderLight = Color(0xFF141414);
  static const languageModalLightBackground = Color(0xFFFAFAFA);
  static const languageModalDarkBackground = Color(0xFF080404);
  static const modalBarrierDark = Color(0x80000000);

  static const mutedControl = Color(0xFFB6B6B6);
  static const inputHintStrong = Color(0xFF787878);
  static const metaIcon = Color(0xFF666666);
  static const inactiveIndicator = Color(0xFFE7E7E7);
  static const settingsDarkTrack = Color(0xFF272727);
  static const settingsLightTrack = AppColors.lightOutline;
  static const settingsSwitchBorder = Color(0xFFEAEAEA);
  static const darkModeKnobOn = Color(0xFF5DC76B);
  static const darkModeKnobOff = Color(0xFFE9E9E9);
  static const sunIcon = Color(0xFFF4B23D);

  static const cravingBrown = Color(0xFFC4823B);
  static const cravingYellow = Color(0xFFF2A91B);
  static const cravingPink = Color(0xFFE15B94);
  static const cravingGreen = Color(0xFF54A75C);
  static const cravingBakery = Color(0xFFD58B3A);
  static const cravingDessert = Color(0xFFE15B4F);

  static const darkMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#212121"}]},
  {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},
  {"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},
  {"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},
  {"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},
  {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},
  {"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}
]
''';

  // ── Theme-aware (auth / onboarding / shared UI) ─────────────────────────────

  static Color onSurface(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color paragraph(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  static Color scaffoldBackground(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  static Color surfaceCard(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color border(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? _neutralDarkStroke
      : Theme.of(context).colorScheme.outline;

  static Color hint(BuildContext context) => Theme.of(context).hintColor;

  static Color fieldError(BuildContext context) =>
      Theme.of(context).colorScheme.error;

  /// Focus ring for text fields (Figma dark: white hairline).
  static Color fieldFocusBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? text
      : onSurface(context);

  /// OTP cell when focused (light: dark border; dark: white).
  static Color otpActiveBorder(BuildContext context) => activeBorder(context);

  /// Active selected/focused outline (light: Figma dark border; dark: white).
  static Color activeBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? text
      : activeBorderLight;

  /// Muted icons (e.g. password visibility).
  static Color iconMuted(BuildContext context) => hint(context);

  static Color cursor(BuildContext context) => onSurface(context);

  /// Dimmed scrim behind modals (e.g. language picker).
  static Color modalBarrierScrim(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45);

  /// Dialog/modal barrier (same scrim as [modalBarrierScrim]).
  static Color overlay(BuildContext context) => modalBarrierScrim(context);

  /// Centered language-picker card fill.
  static Color languageModalBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? languageModalDarkBackground
        : languageModalLightBackground;
  }

  /// Language-picker card outline; stronger in dark mode for separation.
  static Color languageModalBorder(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (Theme.of(context).brightness == Brightness.dark) {
      return _neutralDarkStroke;
    }
    return scheme.outline;
  }

  /// Dividers inside the language picker; clearer in dark mode.
  static Color languageModalDivider(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (Theme.of(context).brightness == Brightness.dark) {
      return _neutralDarkStroke;
    }
    return scheme.outline;
  }

  /// Dimmer behind the language picker in dark mode for contrast.
  static Color languageModalBarrier(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? modalBarrierDark
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45);
  }

  /// Disabled button fill color (adaptive light/dark).
  static Color disabledButtonBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF242424)
        : inactiveIndicator;
  }
}
