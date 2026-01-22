class LoadingMessages {
  static const List<String> en = [
    "Summoning the trivia gods...",
    "Polishing the trophies...",
    "Consulting the oracle...",
    "Loading knowledge crystals...",
    "Sharpening the questions...",
    "Preparing your challenge...",
    "Rolling the dice in the cloud...",
    "Gathering intelligence..."
  ];

  static const List<String> es = [
    "Invocando a los dioses de la trivia...",
    "Puliendo los trofeos...",
    "Consultando al oráculo...",
    "Cargando cristales de conocimiento...",
    "Afilando las preguntas...",
    "Preparando tu desafío...",
    "Lanzando los dados en la nube...",
    "Recopilando inteligencia..."
  ];

  static List<String> getMessages(String languageCode) {
    switch (languageCode) {
      case 'es':
        return es;
      case 'en':
      default:
        return en;
    }
  }
}
