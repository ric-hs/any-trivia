enum SuggestionType { general, specialized, quirky }

class CategorySuggestions {
  static const List<String> generalEn = [
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

  static const List<String> specializedEn = [
    "Disney Classics",
    "Game of Thrones",
    "Malcolm in the Middle",
    "Formula 1 Racing",
    "Minecraft Lore",
    "Medical Breakthroughs",
    "Legal History",
    "The Beatles",
    "Modern Architecture",
    "Coding Languages"
  ];

  static const List<String> quirkyEn = [
    "Medieval Hygiene",
    "History of the Toaster",
    "19th Century Slang",
    "Weird Food Combinations",
    "Useless Animal Facts",
    "Imaginary Languages",
    "Disco Fashion",
    "Cryptids & Folklore"
  ];

  static const List<String> generalEs = [
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

  static const List<String> specializedEs = [
    "Clásicos de Disney",
    "Juego de Tronos",
    "Malcolm el de en medio",
    "Fórmula 1",
    "Lore de Minecraft",
    "Avances Médicos",
    "Historia de las Leyes",
    "The Beatles",
    "Arquitectura Moderna",
    "Lenguajes de Programación"
  ];

  static const List<String> quirkyEs = [
    "Higiene Medieval",
    "Historia de la Tostadora",
    "Jerga del Siglo XIX",
    "Combinaciones Raras de Comida",
    "Datos Inútiles de Animales",
    "Idiomas Imaginarios",
    "Moda Disco",
    "Criptidos y Folclore"
  ];

  static List<String> getSuggestions(String languageCode, {SuggestionType type = SuggestionType.general}) {
    List<String> originalSuggestions;
    
    if (languageCode == 'es') {
      switch (type) {
        case SuggestionType.specialized:
          originalSuggestions = specializedEs;
          break;
        case SuggestionType.quirky:
          originalSuggestions = quirkyEs;
          break;
        case SuggestionType.general:
        default:
          originalSuggestions = generalEs;
      }
    } else {
      switch (type) {
        case SuggestionType.specialized:
          originalSuggestions = specializedEn;
          break;
        case SuggestionType.quirky:
          originalSuggestions = quirkyEn;
          break;
        case SuggestionType.general:
        default:
          originalSuggestions = generalEn;
      }
    }

    return List<String>.from(originalSuggestions)..shuffle();
  }
}
