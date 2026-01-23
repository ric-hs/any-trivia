// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Endless Trivia';

  @override
  String get login => 'INICIAR SESIÓN';

  @override
  String get email => 'CORREO';

  @override
  String get password => 'CONTRASEÑA';

  @override
  String get createAccount => 'CREAR CUENTA';

  @override
  String get joinNow => 'UNIRSE';

  @override
  String get startGame => 'INICIAR JUEGO';

  @override
  String playRound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'INICIAR PARTIDA ($count Fichas)',
      one: 'INICIAR PARTIDA (1 Ficha)',
    );
    return '$_temp0';
  }

  @override
  String get tokens => 'FICHAS';

  @override
  String get chooseAdventure => 'ELIGE TU AVENTURA';

  @override
  String get enterTopic =>
      'Ingresa un tema (ej. Películas de los 80, Física Cuántica)';

  @override
  String get favorites => 'FAVORITOS';

  @override
  String get noFavorites => 'Sin favoritos aún.';

  @override
  String get pleaseEnterCategory => 'Por favor ingresa una categoría';

  @override
  String get outOfTokens => 'Sin Fichas';

  @override
  String get zeroTokensMessage =>
      'Tienes 0 fichas. ¡Espera a que se recarguen!';

  @override
  String get generatingQuestion => 'Generando Pregunta con IA...';

  @override
  String get correct => '¡CORRECTO!';

  @override
  String get wrong => '¡INCORRECTO!';

  @override
  String get greatJob => '¡Buen trabajo!';

  @override
  String correctAnswerWas(String answer) {
    return 'La respuesta correcta era: $answer';
  }

  @override
  String get continueBtn => 'CONTINUAR';

  @override
  String get errorAuth => 'Error de Autenticación';

  @override
  String get errorSignup => 'Error de Registro';

  @override
  String errorProfile(String message) {
    return 'Error cargando perfil: $message';
  }

  @override
  String notEnoughTokens(int rounds, int tokens) {
    return 'Seleccionaste $rounds rondas pero solo tienes $tokens fichas.';
  }

  @override
  String roundProgress(int current, int total) {
    return 'Ronda $current / $total';
  }

  @override
  String get numberOfRounds => 'Número de Rondas';

  @override
  String get maxRounds => '(máx. 30)';

  @override
  String get removeFromFavorites => 'Eliminar de favoritos';

  @override
  String get addToGame => 'Agregar al juego';
}
