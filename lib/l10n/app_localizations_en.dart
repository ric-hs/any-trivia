// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Endless Trivia';

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
  String playRound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'START GAME ($count Tokens)',
      one: 'START GAME (1 Token)',
    );
    return '$_temp0';
  }

  @override
  String get tokens => 'TOKENS';

  @override
  String get chooseAdventure => 'CHOOSE YOUR ADVENTURE';

  @override
  String get enterTopic => 'Enter a topic (e.g. 80s Movies, Quantum Physics)';

  @override
  String get favorites => 'FAVORITES';

  @override
  String get noFavorites => 'No favorites yet.';

  @override
  String get pleaseEnterCategory => 'Please enter a category';

  @override
  String get outOfTokens => 'Out of Tokens';

  @override
  String get zeroTokensMessage => 'You have 0 tokens. Wait for refill!';

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
  String notEnoughTokens(int rounds, int tokens) {
    return 'You selected $rounds rounds but only have $tokens tokens.';
  }

  @override
  String roundProgress(int current, int total) {
    return 'Round $current / $total';
  }

  @override
  String get numberOfRounds => 'Number of Rounds';

  @override
  String get maxRounds => '(max. 30)';
}
