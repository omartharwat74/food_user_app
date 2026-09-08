import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Food User App'**
  String get appTitle;

  /// No description provided for @settingsUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Settings updated successfully'**
  String get settingsUpdatedSuccess;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get deleteAccountSuccess;

  /// No description provided for @changeAppLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Change App Language'**
  String get changeAppLanguageTitle;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @generalSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettingsTitle;

  /// No description provided for @changeAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change App Language'**
  String get changeAppLanguage;

  /// No description provided for @notificationsControl.
  ///
  /// In en, this message translates to:
  /// **'Notifications Control'**
  String get notificationsControl;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Updates about orders and offers will appear here.'**
  String get notificationsEmptyMessage;

  /// No description provided for @notificationOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Order update'**
  String get notificationOrderTitle;

  /// No description provided for @notificationOrderMessage.
  ///
  /// In en, this message translates to:
  /// **'Your order is being prepared and will be on its way soon.'**
  String get notificationOrderMessage;

  /// No description provided for @notificationOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'New offer'**
  String get notificationOfferTitle;

  /// No description provided for @notificationOfferMessage.
  ///
  /// In en, this message translates to:
  /// **'Save on your next meal with today\'s special offer.'**
  String get notificationOfferMessage;

  /// No description provided for @notificationSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'Account notification'**
  String get notificationSystemTitle;

  /// No description provided for @notificationSystemMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account settings were updated successfully.'**
  String get notificationSystemMessage;

  /// No description provided for @notificationToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notificationToday;

  /// No description provided for @notificationYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notificationYesterday;

  /// No description provided for @notificationTimeNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get notificationTimeNow;

  /// No description provided for @notificationSampleTime.
  ///
  /// In en, this message translates to:
  /// **'2:30 PM'**
  String get notificationSampleTime;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @arabicLanguage.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabicLanguage;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @deleteAccountComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Delete account flow is coming soon.'**
  String get deleteAccountComingSoon;

  /// No description provided for @deleteAccountConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountConfirmationTitle;

  /// No description provided for @deleteAccountConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete account flow will be connected later.'**
  String get deleteAccountConfirmationMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in!'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back — sign in to continue.'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordHint;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubmit;

  /// No description provided for @loginSubmitting.
  ///
  /// In en, this message translates to:
  /// **'…'**
  String get loginSubmitting;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get loginNoAccount;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginCreateAccount;

  /// No description provided for @registerWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get registerWelcomeTitle;

  /// No description provided for @registerWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us today and enjoy faster delivery.'**
  String get registerWelcomeSubtitle;

  /// No description provided for @registerUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get registerUsernameLabel;

  /// No description provided for @registerUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get registerUsernameHint;

  /// No description provided for @registerPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get registerPhoneLabel;

  /// No description provided for @registerPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get registerPhoneHint;

  /// No description provided for @registerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmailHint;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPasswordLabel;

  /// No description provided for @registerPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPasswordHint;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get registerConfirmPasswordHint;

  /// No description provided for @registerTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get registerTermsPrefix;

  /// No description provided for @registerTermsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get registerTermsLink;

  /// No description provided for @registerTermsError.
  ///
  /// In en, this message translates to:
  /// **'You must accept the Terms & Conditions.'**
  String get registerTermsError;

  /// No description provided for @registerSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerSubmit;

  /// No description provided for @registerHasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get registerHasAccount;

  /// No description provided for @registerSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get registerSignIn;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password!'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email so we can verify your account.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get forgotPasswordSubmit;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password!'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password to keep your data secure.'**
  String get resetPasswordSubtitle;

  /// No description provided for @resetPasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get resetPasswordSubmit;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to you to confirm your mobile number and continue.'**
  String get otpSubtitle;

  /// No description provided for @otpVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otpVerify;

  /// No description provided for @otpTimerSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String otpTimerSeconds(int seconds);

  /// No description provided for @otpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code?'**
  String get otpResend;

  /// No description provided for @otpResentSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Code sent again'**
  String get otpResentSnackbar;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsTitle;

  /// No description provided for @termsBody.
  ///
  /// In en, this message translates to:
  /// **'This is the Terms & Conditions page for the app. By using this app, you agree to follow the usage policies, respect platform rules, and keep your account information confidential. This page will be updated with final legal content later.'**
  String get termsBody;

  /// No description provided for @onboardingTitleLine1.
  ///
  /// In en, this message translates to:
  /// **'Order more, wait less …'**
  String get onboardingTitleLine1;

  /// No description provided for @onboardingTitleAccent.
  ///
  /// In en, this message translates to:
  /// **' Order now'**
  String get onboardingTitleAccent;

  /// No description provided for @onboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Faster delivery, more options, and an experience designed\nfor your comfort with every order.'**
  String get onboardingDescription;

  /// No description provided for @onboardingCta.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get onboardingCta;

  /// No description provided for @authEntryTitleAccent.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get authEntryTitleAccent;

  /// No description provided for @authEntryTitleRest.
  ///
  /// In en, this message translates to:
  /// **' faster ... better service!'**
  String get authEntryTitleRest;

  /// No description provided for @authEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to register and enjoy faster delivery.'**
  String get authEntrySubtitle;

  /// No description provided for @authContinueWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Continue with mobile number'**
  String get authContinueWithPhone;

  /// No description provided for @authContinueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authContinueWithApple;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authContinueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get authContinueWithFacebook;

  /// No description provided for @authPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get authPhoneTitle;

  /// No description provided for @authPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number to complete registration.'**
  String get authPhoneSubtitle;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to you to confirm your mobile number.'**
  String get authOtpSubtitle;

  /// No description provided for @completeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your data!'**
  String get completeProfileTitle;

  /// No description provided for @completeProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us today and enjoy a faster delivery experience.'**
  String get completeProfileSubtitle;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameLabel;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameHint;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameLabel;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameHint;

  /// No description provided for @completeProfileSubmit.
  ///
  /// In en, this message translates to:
  /// **'Register now'**
  String get completeProfileSubmit;

  /// No description provided for @completeProfileTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'By registering in the app, you agree to '**
  String get completeProfileTermsPrefix;

  /// No description provided for @authAppLogoSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'App logo'**
  String get authAppLogoSemanticLabel;

  /// No description provided for @mainTabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get mainTabHome;

  /// No description provided for @mainTabCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get mainTabCart;

  /// No description provided for @mainTabOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get mainTabOrders;

  /// No description provided for @mainTabAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get mainTabAccount;

  /// No description provided for @homeCategoryRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get homeCategoryRestaurants;

  /// No description provided for @homeCategoryGrocery.
  ///
  /// In en, this message translates to:
  /// **'Grocery'**
  String get homeCategoryGrocery;

  /// No description provided for @homeCategoryStores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get homeCategoryStores;

  /// No description provided for @homeCategoryPickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get homeCategoryPickup;

  /// No description provided for @serviceSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for what you love'**
  String get serviceSearchHint;

  /// No description provided for @serviceAvailable.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get serviceAvailable;

  /// No description provided for @serviceClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get serviceClosed;

  /// No description provided for @serviceListingRestaurantsTitle.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get serviceListingRestaurantsTitle;

  /// No description provided for @serviceListingGroceryTitle.
  ///
  /// In en, this message translates to:
  /// **'Grocery'**
  String get serviceListingGroceryTitle;

  /// No description provided for @serviceListingStoresTitle.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get serviceListingStoresTitle;

  /// No description provided for @serviceListingPickupTitle.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get serviceListingPickupTitle;

  /// No description provided for @serviceCategoryDesserts.
  ///
  /// In en, this message translates to:
  /// **'Desserts'**
  String get serviceCategoryDesserts;

  /// No description provided for @serviceCategoryGrills.
  ///
  /// In en, this message translates to:
  /// **'Grills'**
  String get serviceCategoryGrills;

  /// No description provided for @serviceCategoryPizza.
  ///
  /// In en, this message translates to:
  /// **'Pizza'**
  String get serviceCategoryPizza;

  /// No description provided for @serviceCategoryFastFood.
  ///
  /// In en, this message translates to:
  /// **'Fast food'**
  String get serviceCategoryFastFood;

  /// No description provided for @serviceCategoryBurger.
  ///
  /// In en, this message translates to:
  /// **'Burger'**
  String get serviceCategoryBurger;

  /// No description provided for @serviceCategoryShawarma.
  ///
  /// In en, this message translates to:
  /// **'Shawarma'**
  String get serviceCategoryShawarma;

  /// No description provided for @serviceCategoryRoasters.
  ///
  /// In en, this message translates to:
  /// **'Roasters'**
  String get serviceCategoryRoasters;

  /// No description provided for @serviceCategoryFruitsVegetables.
  ///
  /// In en, this message translates to:
  /// **'Fruits & vegetables'**
  String get serviceCategoryFruitsVegetables;

  /// No description provided for @serviceCategoryDairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get serviceCategoryDairy;

  /// No description provided for @serviceCategorySnacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get serviceCategorySnacks;

  /// No description provided for @serviceCategorySupermarket.
  ///
  /// In en, this message translates to:
  /// **'Supermarket'**
  String get serviceCategorySupermarket;

  /// No description provided for @serviceCategoryFlowers.
  ///
  /// In en, this message translates to:
  /// **'Flowers'**
  String get serviceCategoryFlowers;

  /// No description provided for @serviceCategoryPerfumeBeauty.
  ///
  /// In en, this message translates to:
  /// **'Perfume & beauty'**
  String get serviceCategoryPerfumeBeauty;

  /// No description provided for @serviceLargeStores.
  ///
  /// In en, this message translates to:
  /// **'Large stores'**
  String get serviceLargeStores;

  /// No description provided for @serviceAllPlaces.
  ///
  /// In en, this message translates to:
  /// **'All places'**
  String get serviceAllPlaces;

  /// No description provided for @serviceFilterTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get serviceFilterTopRated;

  /// No description provided for @serviceFilterOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get serviceFilterOffers;

  /// No description provided for @serviceFilterFastDelivery.
  ///
  /// In en, this message translates to:
  /// **'Fast Delivery'**
  String get serviceFilterFastDelivery;

  /// No description provided for @serviceDeliveryTimeRange.
  ///
  /// In en, this message translates to:
  /// **'30-45 min'**
  String get serviceDeliveryTimeRange;

  /// No description provided for @serviceRestaurantKira.
  ///
  /// In en, this message translates to:
  /// **'Al Kira Restaurant'**
  String get serviceRestaurantKira;

  /// No description provided for @serviceRestaurantAzAlSham.
  ///
  /// In en, this message translates to:
  /// **'Az Al Sham Restaurant'**
  String get serviceRestaurantAzAlSham;

  /// No description provided for @serviceRestaurantDescription.
  ///
  /// In en, this message translates to:
  /// **'Shawarma, pizza, oriental meals'**
  String get serviceRestaurantDescription;

  /// No description provided for @serviceStoreFathallah.
  ///
  /// In en, this message translates to:
  /// **'Fathallah'**
  String get serviceStoreFathallah;

  /// No description provided for @serviceStoreCaptain.
  ///
  /// In en, this message translates to:
  /// **'Al Captain'**
  String get serviceStoreCaptain;

  /// No description provided for @serviceStoreRimasLand.
  ///
  /// In en, this message translates to:
  /// **'Rimas Land'**
  String get serviceStoreRimasLand;

  /// No description provided for @serviceStoreTaheraFry.
  ///
  /// In en, this message translates to:
  /// **'Al Tahera Fry'**
  String get serviceStoreTaheraFry;

  /// No description provided for @serviceStoreFamilyMarket.
  ///
  /// In en, this message translates to:
  /// **'Family Market'**
  String get serviceStoreFamilyMarket;

  /// No description provided for @serviceCaptainMarket.
  ///
  /// In en, this message translates to:
  /// **'Captain Market'**
  String get serviceCaptainMarket;

  /// No description provided for @serviceEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No places yet'**
  String get serviceEmptyTitle;

  /// No description provided for @serviceEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Matching places will appear here soon.'**
  String get serviceEmptyMessage;

  /// No description provided for @serviceNoResultsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No results available'**
  String get serviceNoResultsAvailable;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTitle;

  /// No description provided for @cartRestaurantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your order from Az Al Sham Restaurant'**
  String get cartRestaurantSubtitle;

  /// No description provided for @cartProductBurgerCombo.
  ///
  /// In en, this message translates to:
  /// **'Burger meal with fries offer'**
  String get cartProductBurgerCombo;

  /// No description provided for @cartNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Your notes here...'**
  String get cartNotesHint;

  /// No description provided for @cartDiscountCode.
  ///
  /// In en, this message translates to:
  /// **'Discount code'**
  String get cartDiscountCode;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Completed orders are cleared from this preview cart.'**
  String get cartEmptyMessage;

  /// No description provided for @cartCheckout.
  ///
  /// In en, this message translates to:
  /// **'Continue payment'**
  String get cartCheckout;

  /// No description provided for @cartAddMore.
  ///
  /// In en, this message translates to:
  /// **'Add more'**
  String get cartAddMore;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get checkoutDeliveryAddress;

  /// No description provided for @checkoutChangeAddress.
  ///
  /// In en, this message translates to:
  /// **'Change Address'**
  String get checkoutChangeAddress;

  /// No description provided for @checkoutPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose payment method:'**
  String get checkoutPaymentMethod;

  /// No description provided for @checkoutCashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on delivery'**
  String get checkoutCashOnDelivery;

  /// No description provided for @checkoutCashOnDeliverySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay when your order arrives'**
  String get checkoutCashOnDeliverySubtitle;

  /// No description provided for @checkoutCardPayment.
  ///
  /// In en, this message translates to:
  /// **'Pay by Visa'**
  String get checkoutCardPayment;

  /// No description provided for @checkoutConfirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Place order'**
  String get checkoutConfirmOrder;

  /// No description provided for @confirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm payment'**
  String get confirmPayment;

  /// No description provided for @checkoutOrderDesignOnly.
  ///
  /// In en, this message translates to:
  /// **'Order submitted successfully'**
  String get checkoutOrderDesignOnly;

  /// No description provided for @checkoutAddressUpdated.
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get checkoutAddressUpdated;

  /// No description provided for @cartPrice.
  ///
  /// In en, this message translates to:
  /// **'{amount} EGP'**
  String cartPrice(int amount);

  /// No description provided for @productDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get productDetailsTitle;

  /// No description provided for @productBurgerDescription.
  ///
  /// In en, this message translates to:
  /// **'Fresh burger sandwich made with grilled beef, special burger sauce, served with crispy fries.'**
  String get productBurgerDescription;

  /// No description provided for @productAddNotes.
  ///
  /// In en, this message translates to:
  /// **'Add your notes'**
  String get productAddNotes;

  /// No description provided for @productEditNotes.
  ///
  /// In en, this message translates to:
  /// **'Edit your notes'**
  String get productEditNotes;

  /// No description provided for @productYourNotes.
  ///
  /// In en, this message translates to:
  /// **'Your notes'**
  String get productYourNotes;

  /// No description provided for @productNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get productNotesTitle;

  /// No description provided for @productNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Write notes here ...'**
  String get productNotesHint;

  /// No description provided for @productNotesSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get productNotesSubmit;

  /// No description provided for @productTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get productTypeTitle;

  /// No description provided for @productTypeChicken.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get productTypeChicken;

  /// No description provided for @productTypeMeat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get productTypeMeat;

  /// No description provided for @productFlavorTitle.
  ///
  /// In en, this message translates to:
  /// **'Flavor'**
  String get productFlavorTitle;

  /// No description provided for @productFlavorNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get productFlavorNormal;

  /// No description provided for @productFlavorHot.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get productFlavorHot;

  /// No description provided for @productAddSomethingTitle.
  ///
  /// In en, this message translates to:
  /// **'Add something else?'**
  String get productAddSomethingTitle;

  /// No description provided for @productAddSomethingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the extras that suit you'**
  String get productAddSomethingSubtitle;

  /// No description provided for @productAddonWater.
  ///
  /// In en, this message translates to:
  /// **'Mineral water'**
  String get productAddonWater;

  /// No description provided for @productAddonToast.
  ///
  /// In en, this message translates to:
  /// **'Berry toast'**
  String get productAddonToast;

  /// No description provided for @productAddonChips.
  ///
  /// In en, this message translates to:
  /// **'Chips'**
  String get productAddonChips;

  /// No description provided for @productAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get productAddToCart;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTitle;

  /// No description provided for @orderRestaurantAzAlSham.
  ///
  /// In en, this message translates to:
  /// **'Az Al Sham'**
  String get orderRestaurantAzAlSham;

  /// No description provided for @orderProductsCount.
  ///
  /// In en, this message translates to:
  /// **'3 products'**
  String get orderProductsCount;

  /// No description provided for @orderEstimatedArrival.
  ///
  /// In en, this message translates to:
  /// **'Expected arrival time'**
  String get orderEstimatedArrival;

  /// No description provided for @orderEstimatedArrivalRange.
  ///
  /// In en, this message translates to:
  /// **'15 : 20 min'**
  String get orderEstimatedArrivalRange;

  /// No description provided for @orderWaitingAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Your order is waiting for acceptance'**
  String get orderWaitingAcceptance;

  /// No description provided for @orderWaitingAcceptanceShort.
  ///
  /// In en, this message translates to:
  /// **'Waiting for acceptance'**
  String get orderWaitingAcceptanceShort;

  /// No description provided for @orderPreparing.
  ///
  /// In en, this message translates to:
  /// **'Your order is being prepared'**
  String get orderPreparing;

  /// No description provided for @orderPreparingShort.
  ///
  /// In en, this message translates to:
  /// **'Being prepared'**
  String get orderPreparingShort;

  /// No description provided for @orderCourierOnWay.
  ///
  /// In en, this message translates to:
  /// **'The courier is on the way to you'**
  String get orderCourierOnWay;

  /// No description provided for @orderCourierOnWayShort.
  ///
  /// In en, this message translates to:
  /// **'Courier on the way'**
  String get orderCourierOnWayShort;

  /// No description provided for @orderDelivered.
  ///
  /// In en, this message translates to:
  /// **'Order delivered'**
  String get orderDelivered;

  /// No description provided for @orderDeliveredShort.
  ///
  /// In en, this message translates to:
  /// **'Closed order'**
  String get orderDeliveredShort;

  /// No description provided for @orderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled'**
  String get orderCancelled;

  /// No description provided for @orderCancelledShort.
  ///
  /// In en, this message translates to:
  /// **'Cancelled order'**
  String get orderCancelledShort;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{number}'**
  String orderNumber(String number);

  /// No description provided for @orderTotal.
  ///
  /// In en, this message translates to:
  /// **'340 EGP'**
  String get orderTotal;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'View order'**
  String get orderDetails;

  /// No description provided for @reorder.
  ///
  /// In en, this message translates to:
  /// **'New order'**
  String get reorder;

  /// No description provided for @trackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track order'**
  String get trackOrder;

  /// No description provided for @trackYourOrder.
  ///
  /// In en, this message translates to:
  /// **'Track your order'**
  String get trackYourOrder;

  /// No description provided for @deliverTo.
  ///
  /// In en, this message translates to:
  /// **'Deliver to:'**
  String get deliverTo;

  /// No description provided for @orderItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ordered items:'**
  String get orderItemsTitle;

  /// No description provided for @paymentSummary.
  ///
  /// In en, this message translates to:
  /// **'Order summary:'**
  String get paymentSummary;

  /// No description provided for @orderSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Order value'**
  String get orderSubtotal;

  /// No description provided for @orderSubtotalValue.
  ///
  /// In en, this message translates to:
  /// **'400 EGP'**
  String get orderSubtotalValue;

  /// No description provided for @orderDeliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get orderDeliveryFee;

  /// No description provided for @orderDeliveryFeeValue.
  ///
  /// In en, this message translates to:
  /// **'20 EGP'**
  String get orderDeliveryFeeValue;

  /// No description provided for @orderDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get orderDiscount;

  /// No description provided for @orderDiscountValue.
  ///
  /// In en, this message translates to:
  /// **'80 EGP'**
  String get orderDiscountValue;

  /// No description provided for @orderGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Total:'**
  String get orderGrandTotal;

  /// No description provided for @orderQuantity.
  ///
  /// In en, this message translates to:
  /// **'Qty: {count}'**
  String orderQuantity(int count);

  /// No description provided for @orderProductName.
  ///
  /// In en, this message translates to:
  /// **'Burger meal with fries offer'**
  String get orderProductName;

  /// No description provided for @orderProductPrice.
  ///
  /// In en, this message translates to:
  /// **'200 EGP'**
  String get orderProductPrice;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get cancelOrder;

  /// No description provided for @orderCancelDesignOnly.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled successfully'**
  String get orderCancelDesignOnly;

  /// No description provided for @courierDetails.
  ///
  /// In en, this message translates to:
  /// **'Courier details:'**
  String get courierDetails;

  /// No description provided for @orderCourierName.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Ali'**
  String get orderCourierName;

  /// No description provided for @orderCourierPhone.
  ///
  /// In en, this message translates to:
  /// **'01004059966'**
  String get orderCourierPhone;

  /// No description provided for @orderCourierRating.
  ///
  /// In en, this message translates to:
  /// **'4.5'**
  String get orderCourierRating;

  /// No description provided for @orderAcceptedShort.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get orderAcceptedShort;

  /// No description provided for @orderHandedToCourierShort.
  ///
  /// In en, this message translates to:
  /// **'Handed to courier'**
  String get orderHandedToCourierShort;

  /// No description provided for @orderYouCancelled.
  ///
  /// In en, this message translates to:
  /// **'You cancelled the order'**
  String get orderYouCancelled;

  /// No description provided for @cancellationReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancellation reason:'**
  String get cancellationReasonTitle;

  /// No description provided for @cancellationReasonSample.
  ///
  /// In en, this message translates to:
  /// **'Delayed order confirmation'**
  String get cancellationReasonSample;

  /// No description provided for @rateOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rateOrderTitle;

  /// No description provided for @yourRating.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get yourRating;

  /// No description provided for @ratingFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Write how satisfied you are with the service'**
  String get ratingFeedbackHint;

  /// No description provided for @skipRating.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipRating;

  /// No description provided for @submitRating.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get submitRating;

  /// No description provided for @ratingSubmittedDesignOnly.
  ///
  /// In en, this message translates to:
  /// **'Rating submitted successfully'**
  String get ratingSubmittedDesignOnly;

  /// No description provided for @orderDetailsDesignOnly.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get orderDetailsDesignOnly;

  /// No description provided for @rateOrder.
  ///
  /// In en, this message translates to:
  /// **'Rate order'**
  String get rateOrder;

  /// No description provided for @currentOrders.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentOrders;

  /// No description provided for @previousOrders.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousOrders;

  /// No description provided for @cancelledOrders.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledOrders;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get accountTitle;

  /// No description provided for @accountPlaceholderName.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Farag'**
  String get accountPlaceholderName;

  /// No description provided for @accountPlaceholderEmail.
  ///
  /// In en, this message translates to:
  /// **'afarag74@gmail.com'**
  String get accountPlaceholderEmail;

  /// No description provided for @accountGeneralSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get accountGeneralSettings;

  /// No description provided for @accountFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get accountFavorites;

  /// No description provided for @accountDiscountPoints.
  ///
  /// In en, this message translates to:
  /// **'Discount Points'**
  String get accountDiscountPoints;

  /// No description provided for @accountSavedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get accountSavedAddresses;

  /// No description provided for @accountCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get accountCards;

  /// No description provided for @accountTechnicalSupport.
  ///
  /// In en, this message translates to:
  /// **'Technical Support'**
  String get accountTechnicalSupport;

  /// No description provided for @accountTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get accountTermsAndConditions;

  /// No description provided for @accountLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get accountLogout;

  /// No description provided for @accountLoggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get accountLoggingOut;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Restaurants and meals you save will appear here.'**
  String get favoritesEmptyMessage;

  /// No description provided for @favoriteSampleRestaurant.
  ///
  /// In en, this message translates to:
  /// **'El Kelany Restaurant'**
  String get favoriteSampleRestaurant;

  /// No description provided for @favoriteSampleDescription.
  ///
  /// In en, this message translates to:
  /// **'Grilled meals, sandwiches, and fast delivery'**
  String get favoriteSampleDescription;

  /// No description provided for @favoriteSampleMeal.
  ///
  /// In en, this message translates to:
  /// **'Grilled Chicken Meal'**
  String get favoriteSampleMeal;

  /// No description provided for @favoriteSampleMealDescription.
  ///
  /// In en, this message translates to:
  /// **'Chicken, rice, salad, and sauce'**
  String get favoriteSampleMealDescription;

  /// No description provided for @favoriteDeliveryTime.
  ///
  /// In en, this message translates to:
  /// **'20 - 30 min'**
  String get favoriteDeliveryTime;

  /// No description provided for @favoriteRating.
  ///
  /// In en, this message translates to:
  /// **'4.8'**
  String get favoriteRating;

  /// No description provided for @favoriteRestaurantAzAlSham.
  ///
  /// In en, this message translates to:
  /// **'Az Al Sham Restaurant'**
  String get favoriteRestaurantAzAlSham;

  /// No description provided for @favoriteStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get favoriteStatusAvailable;

  /// No description provided for @favoriteStatusBusy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get favoriteStatusBusy;

  /// No description provided for @favoriteStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get favoriteStatusClosed;

  /// No description provided for @favoriteDeliveryTimeRange.
  ///
  /// In en, this message translates to:
  /// **'30-45 min'**
  String get favoriteDeliveryTimeRange;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @savedAddressesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get savedAddressesTitle;

  /// No description provided for @savedAddressesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved addresses yet'**
  String get savedAddressesEmpty;

  /// No description provided for @savedAddressesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load saved addresses'**
  String get savedAddressesLoadFailed;

  /// No description provided for @homeAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeAddressTitle;

  /// No description provided for @workAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get workAddressTitle;

  /// No description provided for @sampleHomeAddress.
  ///
  /// In en, this message translates to:
  /// **'15 Tahrir Street, Dokki, Giza'**
  String get sampleHomeAddress;

  /// No description provided for @sampleWorkAddress.
  ///
  /// In en, this message translates to:
  /// **'12 Nile Corniche, Maadi, Cairo'**
  String get sampleWorkAddress;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get deleteAddress;

  /// No description provided for @deleteAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get deleteAddressTitle;

  /// No description provided for @deleteAddressMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address?'**
  String get deleteAddressMessage;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmLocation;

  /// No description provided for @addAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'New Address'**
  String get addAddressTitle;

  /// No description provided for @editAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddressTitle;

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Confirm Add'**
  String get saveAddress;

  /// No description provided for @updateAddress.
  ///
  /// In en, this message translates to:
  /// **'Confirm Edit'**
  String get updateAddress;

  /// No description provided for @fullAddress.
  ///
  /// In en, this message translates to:
  /// **'Full Address'**
  String get fullAddress;

  /// No description provided for @building.
  ///
  /// In en, this message translates to:
  /// **'Building Number'**
  String get building;

  /// No description provided for @apartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment Number'**
  String get apartment;

  /// No description provided for @floor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floor;

  /// No description provided for @addressSavedDesignOnly.
  ///
  /// In en, this message translates to:
  /// **'Address saved successfully'**
  String get addressSavedDesignOnly;

  /// No description provided for @addressUpdatedDesignOnly.
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get addressUpdatedDesignOnly;

  /// No description provided for @addressDeletedDesignOnly.
  ///
  /// In en, this message translates to:
  /// **'Address deleted successfully'**
  String get addressDeletedDesignOnly;

  /// No description provided for @itemAddedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Item added to favorites successfully'**
  String get itemAddedToFavorites;

  /// No description provided for @itemRemovedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Item removed from favorites successfully'**
  String get itemRemovedFromFavorites;

  /// No description provided for @chooseLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get chooseLocation;

  /// No description provided for @selectedLocation.
  ///
  /// In en, this message translates to:
  /// **'Your current address'**
  String get selectedLocation;

  /// No description provided for @selectDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Select delivery address'**
  String get selectDeliveryAddress;

  /// No description provided for @searchForAddress.
  ///
  /// In en, this message translates to:
  /// **'Search for your location'**
  String get searchForAddress;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get currentLocation;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'New Cairo, Madinaty, Al Zuhour District'**
  String get deliveryAddress;

  /// No description provided for @sampleAddressMeta.
  ///
  /// In en, this message translates to:
  /// **'Building: El Saadany / Apartment: 201 / Floor: Fifth'**
  String get sampleAddressMeta;

  /// No description provided for @apartmentAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get apartmentAddressTitle;

  /// No description provided for @sampleBuildingName.
  ///
  /// In en, this message translates to:
  /// **'El Saadany'**
  String get sampleBuildingName;

  /// No description provided for @sampleApartmentNumber.
  ///
  /// In en, this message translates to:
  /// **'201'**
  String get sampleApartmentNumber;

  /// No description provided for @sampleFloorName.
  ///
  /// In en, this message translates to:
  /// **'Fifth'**
  String get sampleFloorName;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// No description provided for @helpSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupportTitle;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faqTitle;

  /// No description provided for @supportOrderIssue.
  ///
  /// In en, this message translates to:
  /// **'I have an issue with an order'**
  String get supportOrderIssue;

  /// No description provided for @supportPaymentIssue.
  ///
  /// In en, this message translates to:
  /// **'Payment and refund help'**
  String get supportPaymentIssue;

  /// No description provided for @supportContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get supportContactUs;

  /// No description provided for @supportPhone.
  ///
  /// In en, this message translates to:
  /// **'Call support'**
  String get supportPhone;

  /// No description provided for @supportWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp support'**
  String get supportWhatsapp;

  /// No description provided for @supportEmail.
  ///
  /// In en, this message translates to:
  /// **'Email support'**
  String get supportEmail;

  /// No description provided for @supportChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Technical Support'**
  String get supportChatTitle;

  /// No description provided for @supportToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get supportToday;

  /// No description provided for @supportGoodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get supportGoodEvening;

  /// No description provided for @supportHowCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get supportHowCanWeHelp;

  /// No description provided for @supportSampleUserIssue.
  ///
  /// In en, this message translates to:
  /// **'I have a problem with Az Al Sham Restaurant. The food was delayed beyond the expected time.'**
  String get supportSampleUserIssue;

  /// No description provided for @supportInputHint.
  ///
  /// In en, this message translates to:
  /// **'Write here...'**
  String get supportInputHint;

  /// No description provided for @supportAttachmentOptions.
  ///
  /// In en, this message translates to:
  /// **'Attachment options'**
  String get supportAttachmentOptions;

  /// No description provided for @supportPickImage.
  ///
  /// In en, this message translates to:
  /// **'Pick Image'**
  String get supportPickImage;

  /// No description provided for @supportPickVideo.
  ///
  /// In en, this message translates to:
  /// **'Pick Video'**
  String get supportPickVideo;

  /// No description provided for @supportCancelAttachment.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get supportCancelAttachment;

  /// No description provided for @supportImageMessage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get supportImageMessage;

  /// No description provided for @supportVideoMessage.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get supportVideoMessage;

  /// No description provided for @cardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cardsTitle;

  /// No description provided for @paymentMethodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethodsTitle;

  /// No description provided for @noCardsMessage.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any card'**
  String get noCardsMessage;

  /// No description provided for @addNewCard.
  ///
  /// In en, this message translates to:
  /// **'Add New Card'**
  String get addNewCard;

  /// No description provided for @addCard.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addCard;

  /// No description provided for @saveCardDetails.
  ///
  /// In en, this message translates to:
  /// **'Save card details'**
  String get saveCardDetails;

  /// No description provided for @forLaterUse.
  ///
  /// In en, this message translates to:
  /// **'for later use'**
  String get forLaterUse;

  /// No description provided for @editCard.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editCard;

  /// No description provided for @editCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Card Details'**
  String get editCardTitle;

  /// No description provided for @deleteCard.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteCard;

  /// No description provided for @deleteCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Card'**
  String get deleteCardTitle;

  /// No description provided for @deleteCardMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this card?'**
  String get deleteCardMessage;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Card'**
  String get confirmDelete;

  /// No description provided for @updateCard.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get updateCard;

  /// No description provided for @cardHolderName.
  ///
  /// In en, this message translates to:
  /// **'Card Holder Name'**
  String get cardHolderName;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @sampleCardHolder.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Farag'**
  String get sampleCardHolder;

  /// No description provided for @sampleMaskedCardNumber.
  ///
  /// In en, this message translates to:
  /// **'**** **** **** 1234'**
  String get sampleMaskedCardNumber;

  /// No description provided for @sampleCardExpiry.
  ///
  /// In en, this message translates to:
  /// **'2026'**
  String get sampleCardExpiry;

  /// No description provided for @paymentCardEnding.
  ///
  /// In en, this message translates to:
  /// **'Visa ending in 4242'**
  String get paymentCardEnding;

  /// No description provided for @paymentIntegrationComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Payment card saving is coming soon.'**
  String get paymentIntegrationComingSoon;

  /// No description provided for @cardAddedDesignOnly.
  ///
  /// In en, this message translates to:
  /// **'Card added successfully'**
  String get cardAddedDesignOnly;

  /// No description provided for @cardUpdatedDesignOnly.
  ///
  /// In en, this message translates to:
  /// **'Card updated successfully'**
  String get cardUpdatedDesignOnly;

  /// No description provided for @cardDeletedDesignOnly.
  ///
  /// In en, this message translates to:
  /// **'Card deleted successfully'**
  String get cardDeletedDesignOnly;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Personal Data'**
  String get editProfileTitle;

  /// No description provided for @personalDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get personalDataTitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileChangesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully'**
  String get profileChangesSaved;

  /// No description provided for @changePhone.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changePhone;

  /// No description provided for @changePhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Phone Number'**
  String get changePhoneTitle;

  /// No description provided for @changePhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your new number correctly so we can send the activation code.'**
  String get changePhoneSubtitle;

  /// No description provided for @newPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'New Phone Number'**
  String get newPhoneNumber;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @verifyPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verifyPhoneTitle;

  /// No description provided for @verifyPhoneMessage.
  ///
  /// In en, this message translates to:
  /// **'A code was sent to your new number for verification.'**
  String get verifyPhoneMessage;

  /// No description provided for @otpCode.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get otpCode;

  /// No description provided for @confirmOtp.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmOtp;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code?'**
  String get resendCode;

  /// No description provided for @resendCodeTimer.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String resendCodeTimer(int seconds);

  /// No description provided for @phoneChangedTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone number changed successfully'**
  String get phoneChangedTitle;

  /// No description provided for @phoneChangedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your phone number has been updated successfully.'**
  String get phoneChangedMessage;

  /// No description provided for @profileUpdatedDesignOnly.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedDesignOnly;

  /// No description provided for @invalidPhoneMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number'**
  String get invalidPhoneMessage;

  /// No description provided for @invalidPhoneLengthMessage.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 11 or 12 digits'**
  String get invalidPhoneLengthMessage;

  /// No description provided for @invalidOtpMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete verification code'**
  String get invalidOtpMessage;

  /// No description provided for @socialDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get socialDivider;

  /// No description provided for @socialAppleSoon.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple is coming soon'**
  String get socialAppleSoon;

  /// No description provided for @socialGoogleSoon.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google is coming soon'**
  String get socialGoogleSoon;

  /// No description provided for @socialAppleLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get socialAppleLabel;

  /// No description provided for @socialGoogleLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get socialGoogleLabel;

  /// No description provided for @validationEmailRequiredDotComRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validationEmailRequiredDotComRequired;

  /// No description provided for @validationEmailRequiredDotComInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validationEmailRequiredDotComInvalid;

  /// No description provided for @validationEmailRequiredDotComNeedsCom.
  ///
  /// In en, this message translates to:
  /// **'Email must end with .com'**
  String get validationEmailRequiredDotComNeedsCom;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordMin8.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get validationPasswordMin8;

  /// No description provided for @validationUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get validationUsernameRequired;

  /// No description provided for @validationUsernameMin3.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get validationUsernameMin3;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required'**
  String get validationPhoneRequired;

  /// No description provided for @validationPhoneEgyptian.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Egyptian mobile number (10 or 11 digits after +20)'**
  String get validationPhoneEgyptian;

  /// No description provided for @validationConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password confirmation is required'**
  String get validationConfirmPasswordRequired;

  /// No description provided for @validationConfirmPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationConfirmPasswordMismatch;

  /// No description provided for @validationOtpRequired.
  ///
  /// In en, this message translates to:
  /// **'Verification code is required'**
  String get validationOtpRequired;

  /// No description provided for @validationOtpSixDigits.
  ///
  /// In en, this message translates to:
  /// **'Please enter 6 digits'**
  String get validationOtpSixDigits;

  /// No description provided for @homeDeliveryTo.
  ///
  /// In en, this message translates to:
  /// **'Deliver to'**
  String get homeDeliveryTo;

  /// No description provided for @homeBannerEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Taste unlocked'**
  String get homeBannerEyebrow;

  /// No description provided for @homeBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Special\nBurger'**
  String get homeBannerTitle;

  /// No description provided for @homeOrderNow.
  ///
  /// In en, this message translates to:
  /// **'Order now'**
  String get homeOrderNow;

  /// No description provided for @homeMissedOffersTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers you cannot miss'**
  String get homeMissedOffersTitle;

  /// No description provided for @homeMostOrderedTitle.
  ///
  /// In en, this message translates to:
  /// **'Most ordered'**
  String get homeMostOrderedTitle;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchCravingTitle.
  ///
  /// In en, this message translates to:
  /// **'What are you craving?'**
  String get searchCravingTitle;

  /// No description provided for @searchRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get searchRecentTitle;

  /// No description provided for @searchTopStoresTitle.
  ///
  /// In en, this message translates to:
  /// **'Top stores'**
  String get searchTopStoresTitle;

  /// No description provided for @searchMostSearchedTitle.
  ///
  /// In en, this message translates to:
  /// **'Most searched'**
  String get searchMostSearchedTitle;

  /// No description provided for @searchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get searchResultsTitle;

  /// No description provided for @searchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching results'**
  String get searchEmptyTitle;

  /// No description provided for @searchFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get searchFilterAll;

  /// No description provided for @searchCravingBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get searchCravingBreakfast;

  /// No description provided for @searchCravingDairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get searchCravingDairy;

  /// No description provided for @searchCravingDrinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get searchCravingDrinks;

  /// No description provided for @searchCravingSnacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get searchCravingSnacks;

  /// No description provided for @searchCravingFastFood.
  ///
  /// In en, this message translates to:
  /// **'Fast food'**
  String get searchCravingFastFood;

  /// No description provided for @searchCravingBakery.
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get searchCravingBakery;

  /// No description provided for @searchCravingDesserts.
  ///
  /// In en, this message translates to:
  /// **'Desserts'**
  String get searchCravingDesserts;

  /// No description provided for @searchRecentJuice.
  ///
  /// In en, this message translates to:
  /// **'Juice'**
  String get searchRecentJuice;

  /// No description provided for @searchRecentPepsi.
  ///
  /// In en, this message translates to:
  /// **'Pepsi'**
  String get searchRecentPepsi;

  /// No description provided for @searchRecentNuts.
  ///
  /// In en, this message translates to:
  /// **'Nuts'**
  String get searchRecentNuts;

  /// No description provided for @searchRecentFalafel.
  ///
  /// In en, this message translates to:
  /// **'Falafel'**
  String get searchRecentFalafel;

  /// No description provided for @searchMostSearchedAzAlSham.
  ///
  /// In en, this message translates to:
  /// **'Az Al Sham'**
  String get searchMostSearchedAzAlSham;

  /// No description provided for @searchMostSearchedGawdat.
  ///
  /// In en, this message translates to:
  /// **'Gawdat'**
  String get searchMostSearchedGawdat;

  /// No description provided for @searchMostSearchedTeaBun.
  ///
  /// In en, this message translates to:
  /// **'Tea Bun'**
  String get searchMostSearchedTeaBun;

  /// No description provided for @searchMostSearchedElBashawat.
  ///
  /// In en, this message translates to:
  /// **'El Bashawat'**
  String get searchMostSearchedElBashawat;

  /// No description provided for @searchResultBurgerFriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Burger with fries offer'**
  String get searchResultBurgerFriesTitle;

  /// No description provided for @searchResultFalafelTitle.
  ///
  /// In en, this message translates to:
  /// **'Falafel breakfast'**
  String get searchResultFalafelTitle;

  /// No description provided for @searchResultFalafelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Breakfast, sandwiches, drinks'**
  String get searchResultFalafelSubtitle;

  /// No description provided for @searchResultFalafelPrice.
  ///
  /// In en, this message translates to:
  /// **'EGP 45'**
  String get searchResultFalafelPrice;

  /// No description provided for @searchResultFalafelKeywordBeans.
  ///
  /// In en, this message translates to:
  /// **'beans'**
  String get searchResultFalafelKeywordBeans;

  /// No description provided for @mapPickerLoadingAddress.
  ///
  /// In en, this message translates to:
  /// **'Locating address...'**
  String get mapPickerLoadingAddress;

  /// No description provided for @mapPickerFallbackAddress.
  ///
  /// In en, this message translates to:
  /// **'Selected location on the map'**
  String get mapPickerFallbackAddress;

  /// No description provided for @mapPickerFailedAddress.
  ///
  /// In en, this message translates to:
  /// **'Unable to locate address'**
  String get mapPickerFailedAddress;

  /// No description provided for @restaurantDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Restaurant details'**
  String get restaurantDetailsTitle;

  /// No description provided for @restaurantDiscountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'50% off selected products'**
  String get restaurantDiscountSubtitle;

  /// No description provided for @restaurantViewProducts.
  ///
  /// In en, this message translates to:
  /// **'View products'**
  String get restaurantViewProducts;

  /// No description provided for @restaurantSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get restaurantSearchTitle;

  /// No description provided for @restaurantSearchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching menu items'**
  String get restaurantSearchEmptyTitle;

  /// No description provided for @restaurantRateCustomerReviews.
  ///
  /// In en, this message translates to:
  /// **'Customer reviews:'**
  String get restaurantRateCustomerReviews;

  /// No description provided for @restaurantRateRatingsLabel.
  ///
  /// In en, this message translates to:
  /// **'ratings'**
  String get restaurantRateRatingsLabel;

  /// No description provided for @restaurantRateMoreDetails.
  ///
  /// In en, this message translates to:
  /// **'More details:'**
  String get restaurantRateMoreDetails;

  /// No description provided for @restaurantRateDeliveryPrice.
  ///
  /// In en, this message translates to:
  /// **'Delivery price'**
  String get restaurantRateDeliveryPrice;

  /// No description provided for @restaurantRateMinimumOrder.
  ///
  /// In en, this message translates to:
  /// **'Minimum order'**
  String get restaurantRateMinimumOrder;

  /// No description provided for @restaurantRateDeliveryTime.
  ///
  /// In en, this message translates to:
  /// **'Delivery time'**
  String get restaurantRateDeliveryTime;

  /// No description provided for @restaurantRateAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get restaurantRateAddress;

  /// No description provided for @restaurantRatePreviousOrders.
  ///
  /// In en, this message translates to:
  /// **'Previous orders'**
  String get restaurantRatePreviousOrders;

  /// No description provided for @restaurantRatePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get restaurantRatePaymentMethod;

  /// No description provided for @serviceDeliveryTime25To40.
  ///
  /// In en, this message translates to:
  /// **'25-40 min'**
  String get serviceDeliveryTime25To40;

  /// No description provided for @serviceDeliveryTime35To50.
  ///
  /// In en, this message translates to:
  /// **'35-50 min'**
  String get serviceDeliveryTime35To50;

  /// No description provided for @authErrorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get authErrorNoInternet;

  /// No description provided for @authErrorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get authErrorTimeout;

  /// No description provided for @authErrorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get authErrorUnauthorized;

  /// No description provided for @authErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get authErrorUnknown;

  /// No description provided for @authErrorRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Request failed'**
  String get authErrorRequestFailed;

  /// No description provided for @authErrorInvalidResponse.
  ///
  /// In en, this message translates to:
  /// **'Invalid response'**
  String get authErrorInvalidResponse;

  /// No description provided for @authErrorMissingAccessToken.
  ///
  /// In en, this message translates to:
  /// **'Verification succeeded but no access token was returned'**
  String get authErrorMissingAccessToken;

  /// No description provided for @searchChangeLocation.
  ///
  /// In en, this message translates to:
  /// **'Change location'**
  String get searchChangeLocation;

  /// No description provided for @searchMostSearchedDesserts.
  ///
  /// In en, this message translates to:
  /// **'Desserts'**
  String get searchMostSearchedDesserts;

  /// No description provided for @searchMostSearchedFalafel.
  ///
  /// In en, this message translates to:
  /// **'Falafel'**
  String get searchMostSearchedFalafel;

  /// No description provided for @searchMostSearchedPizza.
  ///
  /// In en, this message translates to:
  /// **'Pizza'**
  String get searchMostSearchedPizza;

  /// No description provided for @searchMostSearchedNuts.
  ///
  /// In en, this message translates to:
  /// **'Nuts'**
  String get searchMostSearchedNuts;

  /// No description provided for @searchMostSearchedPepsi.
  ///
  /// In en, this message translates to:
  /// **'Pepsi'**
  String get searchMostSearchedPepsi;

  /// No description provided for @searchMostSearchedJuice.
  ///
  /// In en, this message translates to:
  /// **'Juice'**
  String get searchMostSearchedJuice;

  /// No description provided for @searchMostSearchedCheese.
  ///
  /// In en, this message translates to:
  /// **'Cheese'**
  String get searchMostSearchedCheese;

  /// No description provided for @startSearching.
  ///
  /// In en, this message translates to:
  /// **'Start searching'**
  String get startSearching;

  /// No description provided for @itemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsTitle;

  /// No description provided for @addressDetailsFormat.
  ///
  /// In en, this message translates to:
  /// **'Building: {building} / Apartment: {apartment} / Floor: {floor}'**
  String addressDetailsFormat(String building, String apartment, String floor);

  /// No description provided for @noOffersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No offers available'**
  String get noOffersAvailable;

  /// No description provided for @noRestaurantsFound.
  ///
  /// In en, this message translates to:
  /// **'No restaurants found'**
  String get noRestaurantsFound;

  /// No description provided for @connectingToApi.
  ///
  /// In en, this message translates to:
  /// **'Connecting to API...'**
  String get connectingToApi;

  /// No description provided for @priceWithCurrency.
  ///
  /// In en, this message translates to:
  /// **'{amount} EGP'**
  String priceWithCurrency(String amount);

  /// No description provided for @orderConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed'**
  String get orderConfirmedTitle;

  /// No description provided for @filterTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get filterTopRated;

  /// No description provided for @filterMostOrdered.
  ///
  /// In en, this message translates to:
  /// **'Most Ordered'**
  String get filterMostOrdered;

  /// No description provided for @filterWithOffers.
  ///
  /// In en, this message translates to:
  /// **'With Offers'**
  String get filterWithOffers;

  /// No description provided for @trackOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get trackOrderTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileNoData.
  ///
  /// In en, this message translates to:
  /// **'No profile data'**
  String get profileNoData;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name: '**
  String get profileNameLabel;

  /// No description provided for @profileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email: '**
  String get profileEmailLabel;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone: '**
  String get profilePhoneLabel;

  /// No description provided for @currencyEgp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currencyEgp;

  /// No description provided for @applyButton.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyButton;

  /// No description provided for @cartConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart Conflict'**
  String get cartConflictTitle;

  /// No description provided for @cartConflictMessage.
  ///
  /// In en, this message translates to:
  /// **'Adding items from a different restaurant will clear your current cart. Continue?'**
  String get cartConflictMessage;

  /// No description provided for @noCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategoriesAvailable;

  /// No description provided for @searchClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get searchClearAll;

  /// No description provided for @searchClearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear your search history?'**
  String get searchClearHistoryConfirm;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
