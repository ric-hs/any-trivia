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

  /// No description provided for @playRound.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{START GAME (1 Token)} other{START GAME ({count} Tokens)}}'**
  String playRound(int count);

  /// No description provided for @tokens.
  ///
  /// In en, this message translates to:
  /// **'TOKENS'**
  String get tokens;

  /// No description provided for @chooseAdventure.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE YOUR ADVENTURE'**
  String get chooseAdventure;

  /// No description provided for @enterTopic.
  ///
  /// In en, this message translates to:
  /// **'Enter a topic (e.g. 80s Movies, Quantum Physics)'**
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
  /// **'Please enter a category'**
  String get pleaseEnterCategory;

  /// No description provided for @outOfTokens.
  ///
  /// In en, this message translates to:
  /// **'Out of Tokens'**
  String get outOfTokens;

  /// No description provided for @zeroTokensMessage.
  ///
  /// In en, this message translates to:
  /// **'You have 0 tokens. Wait for refill!'**
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
  /// **'You selected {rounds} rounds but only have {tokens} tokens.'**
  String notEnoughTokens(int rounds, int tokens);

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
