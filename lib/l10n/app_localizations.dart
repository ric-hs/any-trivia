import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Endless Trivia'**
  String get appTitle;

  /// No description provided for @appSlogan.
  ///
  /// In en, this message translates to:
  /// **'If you can think it, you can play it'**
  String get appSlogan;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get password;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'CREATE ACCOUNT'**
  String get createAccount;

  /// No description provided for @joinNow.
  ///
  /// In en, this message translates to:
  /// **'JOIN NOW'**
  String get joinNow;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'START GAME'**
  String get startGame;

  /// No description provided for @tokens.
  ///
  /// In en, this message translates to:
  /// **'AnyTokens'**
  String get tokens;

  /// No description provided for @chooseAdventure.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE YOUR ADVENTURE'**
  String get chooseAdventure;

  /// No description provided for @enterTopic.
  ///
  /// In en, this message translates to:
  /// **'Enter a topic'**
  String get enterTopic;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'FAVORITES'**
  String get favorites;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet.'**
  String get noFavorites;

  /// No description provided for @pleaseEnterCategory.
  ///
  /// In en, this message translates to:
  /// **'Pick a topic to start the battle!'**
  String get pleaseEnterCategory;

  /// No description provided for @outOfTokens.
  ///
  /// In en, this message translates to:
  /// **'Out of AnyTokens'**
  String get outOfTokens;

  /// No description provided for @zeroTokensMessage.
  ///
  /// In en, this message translates to:
  /// **'You have 0 AnyTokens. Wait for refill!'**
  String get zeroTokensMessage;

  /// No description provided for @generatingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Generating Question with AI...'**
  String get generatingQuestion;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'CORRECT!'**
  String get correct;

  /// No description provided for @wrong.
  ///
  /// In en, this message translates to:
  /// **'WRONG!'**
  String get wrong;

  /// No description provided for @greatJob.
  ///
  /// In en, this message translates to:
  /// **'Great job!'**
  String get greatJob;

  /// No description provided for @correctAnswerWas.
  ///
  /// In en, this message translates to:
  /// **'The correct answer was: {answer}'**
  String correctAnswerWas(String answer);

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get continueBtn;

  /// No description provided for @errorAuth.
  ///
  /// In en, this message translates to:
  /// **'Authentication Failure'**
  String get errorAuth;

  /// No description provided for @errorSignup.
  ///
  /// In en, this message translates to:
  /// **'Signup Failure'**
  String get errorSignup;

  /// No description provided for @errorProfile.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile: {message}'**
  String errorProfile(String message);

  /// No description provided for @notEnoughTokens.
  ///
  /// In en, this message translates to:
  /// **'You selected {rounds} rounds (Cost: {requiredTokens} AnyTokens) but only have {tokens} AnyTokens.'**
  String notEnoughTokens(int rounds, int tokens, int requiredTokens);

  /// No description provided for @roundProgress.
  ///
  /// In en, this message translates to:
  /// **'Round {current} / {total}'**
  String roundProgress(int current, int total);

  /// No description provided for @numberOfRounds.
  ///
  /// In en, this message translates to:
  /// **'Number of Rounds'**
  String get numberOfRounds;

  /// No description provided for @maxRounds.
  ///
  /// In en, this message translates to:
  /// **'(max. 30)'**
  String get maxRounds;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @addToGame.
  ///
  /// In en, this message translates to:
  /// **'Add to game'**
  String get addToGame;

  /// No description provided for @endGame.
  ///
  /// In en, this message translates to:
  /// **'END GAME'**
  String get endGame;

  /// No description provided for @validatorRequiredEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email address'**
  String get validatorRequiredEmail;

  /// No description provided for @validatorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validatorInvalidEmail;

  /// No description provided for @errorLoadQuestions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load questions, please try again later.'**
  String get errorLoadQuestions;

  /// No description provided for @unableToRetrieveTokens.
  ///
  /// In en, this message translates to:
  /// **'Unable to consume AnyTokens to start the game. Please try again.'**
  String get unableToRetrieveTokens;

  /// No description provided for @iHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'I have an account'**
  String get iHaveAnAccount;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @userIdLabel.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userIdLabel;

  /// No description provided for @deviceIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get deviceIdLabel;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsTitle;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @emptyCategoriesMessage.
  ///
  /// In en, this message translates to:
  /// **'Please choose one or more categories to start the game.'**
  String get emptyCategoriesMessage;

  /// No description provided for @emptyFavoritesMessage.
  ///
  /// In en, this message translates to:
  /// **'Here you will see your favorite categories'**
  String get emptyFavoritesMessage;

  /// No description provided for @suggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'IDEAS FOR YOU'**
  String get suggestionsTitle;

  /// No description provided for @suggestionsSpecificTitle.
  ///
  /// In en, this message translates to:
  /// **'SPECIALIZED TOPICS'**
  String get suggestionsSpecificTitle;

  /// No description provided for @suggestionsFunTitle.
  ///
  /// In en, this message translates to:
  /// **'QUIRKY & FUN'**
  String get suggestionsFunTitle;

  /// No description provided for @quitGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Quit Game?'**
  String get quitGameTitle;

  /// No description provided for @quitGameContent.
  ///
  /// In en, this message translates to:
  /// **'This will finish the game and the used AnyTokens will be lost. Are you sure you want to proceed?'**
  String get quitGameContent;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @resultsTitle.
  ///
  /// In en, this message translates to:
  /// **'RESULTS'**
  String get resultsTitle;

  /// No description provided for @scoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scoreLabel;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @backToMenu.
  ///
  /// In en, this message translates to:
  /// **'Back to Menu'**
  String get backToMenu;

  /// No description provided for @costDisplay.
  ///
  /// In en, this message translates to:
  /// **'COST: {amount} ANYTOKENS'**
  String costDisplay(int amount);

  /// No description provided for @storeTitle.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get storeTitle;

  /// No description provided for @storeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get storeComingSoon;

  /// No description provided for @storeWorkingOnItems.
  ///
  /// In en, this message translates to:
  /// **'We are working on great items for you!'**
  String get storeWorkingOnItems;

  /// No description provided for @getTokens.
  ///
  /// In en, this message translates to:
  /// **'Get AnyTokens'**
  String get getTokens;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
