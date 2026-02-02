class LoadingMessages {
  static const List<String> en = [
    "Reticulating splines and caffeinating the CPU...",
    "Consulting the digital oracles...",
    "Downloading the entire internet. Please hold.",
    "Teaching the AI the difference between a duck and a dishwasher...",
    "Searching the deep web for things your teacher never told you.",
    "Looking for questions about 18th-century hats...",
    "Fact-checking your weirdest obsessions.",
    "Wait, you want to play a category about *what*?",
    "Checking if 'Professional Napping' is a real sport...",
    "Warming up the neurons...",
    "Dusting off the Encyclopedia Britannica.",
    "Gathering the facts. Do you have the answers?",
    "Synthesizing the ultimate challenge.",
  ];

  static const List<String> es = [
    "Dando cafeína al CPU...",
    "Consultando a los oráculos digitales...",
    "Descargando todo el internet. Un momento, por favor.",
    "Enseñándole a la IA la diferencia entre un pato y un lavavajillas...",
    "Buscando en la deep web cosas que tu profesor nunca te contó.",
    "Buscando preguntas sobre sombreros del siglo XVIII...",
    "Verificando datos sobre tus obsesiones más raras.",
    "Espera, ¿quieres jugar una categoría sobre *qué*?",
    "Comprobando si 'Siesta Profesional' es un deporte real...",
    "Calentando las neuronas...",
    "Desempolvando la Enciclopedia Británica.",
    "Reuniendo los hechos. ¿Tienes las respuestas?",
    "Sintetizando el desafío definitivo.",
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
