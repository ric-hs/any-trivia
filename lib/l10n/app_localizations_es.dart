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
  String get appSlogan => 'Si puedes pensarlo, puedes jugarlo';

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
  String get tokens => 'FICHAS';

  @override
  String get chooseAdventure => 'ELIGE TU AVENTURA';

  @override
  String get enterTopic => 'Ingresa una categoría';

  @override
  String get favorites => 'FAVORITOS';

  @override
  String get noFavorites => 'Sin favoritos aún.';

  @override
  String get pleaseEnterCategory => '¡Elige un tema para comenzar la batalla!';

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
  String notEnoughTokens(int rounds, int tokens, int requiredTokens) {
    return 'Seleccionaste $rounds rondas (Costo: $requiredTokens Fichas) pero solo tienes $tokens fichas.';
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

  @override
  String get endGame => 'TERMINAR JUEGO';

  @override
  String get validatorRequiredEmail => 'Por favor ingresa un correo';

  @override
  String get validatorInvalidEmail => 'Por favor ingresa un correo válido';

  @override
  String get errorLoadQuestions =>
      'Error al cargar las preguntas, por favor intenta de nuevo más tarde.';

  @override
  String get unableToRetrieveTokens =>
      'No fue posible consumir las fichas para iniciar el juego. Por favor intenta de nuevo.';

  @override
  String get iHaveAnAccount => 'Ya tengo una cuenta';

  @override
  String get back => 'Atrás';

  @override
  String get settings => 'Ajustes';

  @override
  String get userIdLabel => 'ID de Usuario';

  @override
  String get deviceIdLabel => 'ID de Dispositivo';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Español';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get settingsTitle => 'AJUSTES';

  @override
  String get categories => 'Categorías';

  @override
  String get emptyCategoriesMessage =>
      'Por favor elige una o más categorías para comenzar.';

  @override
  String get emptyFavoritesMessage => 'Aquí verás tus categorías favoritas';

  @override
  String get suggestionsTitle => 'IDEAS PARA TI';

  @override
  String get suggestionsSpecificTitle => 'TEMAS ESPECIALIZADOS';

  @override
  String get suggestionsFunTitle => 'CURIOSOS Y DIVERTIDOS';

  @override
  String get quitGameTitle => '¿Salir del juego?';

  @override
  String get quitGameContent =>
      'Esto finalizará el juego y las fichas usadas se perderán. ¿Estás seguro de que quieres continuar?';

  @override
  String get confirm => 'Confirmar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get contactSupport => 'Contactar Soporte';

  @override
  String get resultsTitle => 'RESULTADOS';

  @override
  String get scoreLabel => 'Puntaje';

  @override
  String get playAgain => 'Jugar de nuevo';

  @override
  String get backToMenu => 'Volver al Menú';

  @override
  String costDisplay(int amount) {
    return 'COSTO: $amount FICHAS';
  }
}
