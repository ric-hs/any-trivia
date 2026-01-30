class CategorySuggestions {
  static const List<String> en = [
    "80s Pop Culture",
    "Quantum Physics",
    "Ancient civilizations",
    "Marvel Universe",
    "World Capitals",
    "Gourmet Cuisine",
    "Space Exploration",
    "Video Game History",
    "Olympic Games",
    "Rock & Roll",
    "Renaissance Art",
    "Marine Biology",
    "Mythology",
    "Classic Literature",
    "Movie Directors"
  ];

  static const List<String> es = [
    "Cultura Pop de los 80",
    "Física Cuántica",
    "Civilizaciones Antiguas",
    "Universo Marvel",
    "Capitales del Mundo",
    "Cocina Gourmet",
    "Exploración Espacial",
    "Historia de Videojuegos",
    "Juegos Olímpicos",
    "Rock & Roll",
    "Arte del Renacimiento",
    "Biología Marina",
    "Mitología",
    "Literatura Clásica",
    "Directores de Cine"
  ];

  static List<String> getSuggestions(String languageCode) {
    switch (languageCode) {
      case 'es':
        return es;
      case 'en':
      default:
        return en;
    }
  }
}
