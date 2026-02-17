// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AnyTrivia';

  @override
  String get appSlogan => 'If you can think it, you can play it';

  @override
  String get login => 'LOGIN';

  @override
  String get email => 'EMAIL';

  @override
  String get password => 'PASSWORD';

  @override
  String get createAccount => 'CREATE ACCOUNT';

  @override
  String get joinNow => 'JOIN NOW';

  @override
  String get startGame => 'START GAME';

  @override
  String get tokens => 'AnyTokens';

  @override
  String get chooseAdventure => 'CHOOSE YOUR ADVENTURE';

  @override
  String get enterTopic => 'Enter a topic';

  @override
  String get favorites => 'FAVORITES';

  @override
  String get noFavorites => 'No favorites yet.';

  @override
  String get pleaseEnterCategory => 'Pick a topic to start the battle!';

  @override
  String get outOfTokens => 'Out of AnyTokens';

  @override
  String get zeroTokensMessage => 'You have 0 AnyTokens. Wait for refill!';

  @override
  String get generatingQuestion => 'Generating Question with AI...';

  @override
  String get correct => 'CORRECT!';

  @override
  String get wrong => 'WRONG!';

  @override
  String get greatJob => 'Great job!';

  @override
  String correctAnswerWas(String answer) {
    return 'The correct answer was: $answer';
  }

  @override
  String get continueBtn => 'CONTINUE';

  @override
  String get errorAuth => 'Authentication Failure';

  @override
  String get errorSignup => 'Signup Failure';

  @override
  String errorProfile(String message) {
    return 'Error loading profile: $message';
  }

  @override
  String notEnoughTokens(int rounds, int tokens, int requiredTokens) {
    return 'You selected $rounds rounds (Cost: $requiredTokens AnyTokens) but only have $tokens AnyTokens.';
  }

  @override
  String roundProgress(int current, int total) {
    return 'Round $current / $total';
  }

  @override
  String get numberOfRounds => 'Number of Rounds';

  @override
  String get maxRounds => '(max. 30)';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get addToGame => 'Add to game';

  @override
  String get endGame => 'END GAME';

  @override
  String get validatorRequiredEmail => 'Please enter an email address';

  @override
  String get validatorInvalidEmail => 'Please enter a valid email address';

  @override
  String get errorLoadQuestions =>
      'Failed to load questions, please try again later.';

  @override
  String get unableToRetrieveTokens =>
      'Unable to consume AnyTokens to start the game. Please try again.';

  @override
  String get iHaveAnAccount => 'I have an account';

  @override
  String get back => 'Back';

  @override
  String get settings => 'Settings';

  @override
  String get userIdLabel => 'User ID';

  @override
  String get deviceIdLabel => 'Device ID';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Español';

  @override
  String get signOut => 'Sign Out';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get categories => 'Categories';

  @override
  String get emptyCategoriesMessage =>
      'Please choose one or more categories to start the game.';

  @override
  String get emptyFavoritesMessage =>
      'Here you will see your favorite categories';

  @override
  String get suggestionsTitle => 'IDEAS FOR YOU';

  @override
  String get suggestionsSpecificTitle => 'SPECIALIZED TOPICS';

  @override
  String get suggestionsFunTitle => 'QUIRKY & FUN';

  @override
  String get quitGameTitle => 'Quit Game?';

  @override
  String get quitGameContent =>
      'This will finish the game and the used AnyTokens will be lost. Are you sure you want to proceed?';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get resultsTitle => 'RESULTS';

  @override
  String get scoreLabel => 'Score';

  @override
  String get playAgain => 'Play Again';

  @override
  String get backToMenu => 'Back to Menu';

  @override
  String costDisplay(int amount) {
    return 'COST: $amount ANYTOKENS';
  }

  @override
  String get storeTitle => 'Store';

  @override
  String get storeComingSoon => 'Coming Soon';

  @override
  String get storeWorkingOnItems => 'We are working on great items for you!';

  @override
  String get getTokens => 'Get AnyTokens';

  @override
  String get sound => 'Sound';

  @override
  String get soundEffects => 'Sound Effects';
}
