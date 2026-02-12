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
    "Movie Directors",
    "General Science",
    "World History",
    "Geography",
    "Literature",
    "Art History",
    "Mathematics",
    "Biology",
    "Chemistry",
    "Physics",
    "Music",
    "Movies",
    "Sports",
    "Politics",
    "Economics",
    "Astronomy",
    "Philosophy",
    "Technology",
    "Languages",
    "The history of London",
  ];

  static const List<String> specializedEn = [
    "Disney Classics",
    "Game of Thrones",
    "Malcolm in the Middle",
    "Medicine",
    "Legal History",
    "The Beatles",
    "Coding Languages",
    "Formula 1",
    "Minecraft",
    "The Lord of the Rings",
    "90s Hip Hop",
    "NASA Space Missions",
    "Renaissance Painting",
    "Premier League History",
    "The Witcher Universe",
    "Mechanical Engineering",
    "Pokemon",
    "True Crime",
    "Modern Architecture",
    "Board Games",
    "Classic Rock Vinyls",
    "Viking Age History",
    "Sushi Varieties",
    "Mario Kart",
    "The Simpsons",
    "How I Met Your Mother",
    "Artificial Intelligence",
    "World War II Battles",
    "Jazz Music",
    "Baking Techniques",
    "Yoga Styles",
    "Harry Potter Spells",
    "Harry Potter",
    "Frida Kahlo",
    "Nikola Tesla",
    "Mario Molina",
    "Bad Bunny",
  ];

  static const List<String> quirkyEn = [
    "Medieval Hygiene",
    "History of the Toaster",
    "19th Century Slang",
    "Weird Food Combinations",
    "Useless Animal Facts",
    "Imaginary Languages",
    "Disco Fashion",
    "Cryptids & Folklore",
    "Useless Inventions",
    "The History of the Sandwich",
    "Conspiracy Theories about Pigeons",
    "Strange Local Laws",
    "Florida Man Headlines",
    "Forgotten 2000s Memes",
    "Phobias of Famous People",
    "Fast Food Secret Menus",
    "Absurd Victorian Etiquette",
    "Naming Conventions of IKEA Furniture",
    "Animals that Look Like Celebrities",
    "Extinct Birds No One Misses",
    "Vending Machine Oddities",
    "The Secret Language of Flowers",
    "Guinness World Records for Food",
    "Historical Fashion Disasters",
    "Tricky Questions",
    "Unusual Sports",
    "Strange Holidays",
    "Bizarre World Records",
    "Odd Traditions",
    "Weird Inventions",
    "Dolphins’ World Domination",
  ];

  static const List<String> generalEs = [
    "Cultura Pop de los 80",
    "Física Cuántica",
    "Civilizaciones Antiguas",
    "Universo Marvel",
    "Capitales del Mundo",
    "Cocina Gourmet",
    "Exploración Espacial",
    "Historia de los Videojuegos",
    "Juegos Olímpicos",
    "Rock & Roll",
    "Arte del Renacimiento",
    "Biología Marina",
    "Mitología",
    "Literatura Clásica",
    "Directores de Cine",
    "Ciencia General",
    "Historia Universal",
    "Geografía",
    "Literatura",
    "Historia del Arte",
    "Matemáticas",
    "Biología",
    "Química",
    "Física",
    "Música",
    "Cine",
    "Deportes",
    "Política",
    "Economía",
    "Astronomía",
    "Filosofía",
    "Tecnología",
    "Idiomas",
    "Historia de México",
  ];

  static const List<String> specializedEs = [
    "Clásicos de Disney",
    "Juego de Tronos",
    "Malcolm el de en medio",
    "Medicina",
    "Derecho",
    "The Beatles",
    "Programación",
    "Fórmula 1",
    "Minecraft",
    "El Señor de los Anillos",
    "Hip Hop de los 90",
    "Misiones Espaciales de la NASA",
    "Pintura Renacentista",
    "Historia de la Premier League",
    "El Universo de The Witcher",
    "Ingeniería Mecánica",
    "Pokémon",
    "True Crime",
    "Arquitectura Moderna",
    "Juegos de Mesa",
    "Vinilos de Rock Clásico",
    "Historia de la Era Vikinga",
    "Variedades de Sushi",
    "Mario Kart",
    "Los Simpson",
    "Cómo conocí a tu madre",
    "Inteligencia Artificial",
    "Batallas de la Segunda Guerra Mundial",
    "Música Jazz",
    "Técnicas de Repostería",
    "Estilos de Yoga",
    "Hechizos de Harry Potter",
    "Harry Potter",
    "Frida Kahlo",
    "Nikola Tesla",
    "Mario Molina",
    "Bad Bunny",
  ];

  static const List<String> quirkyEs = [
    "Higiene Medieval",
    "Historia de la Tostadora",
    "Jerga del Siglo XIX",
    "Combinaciones de Comida Extrañas",
    "Datos Inútiles sobre Animales",
    "Idiomas Imaginarios",
    "Moda Disco",
    "Criptidos y Folklore",
    "Inventos Inútiles",
    "La Historia del Sándwich",
    "Teorías de Conspiración sobre Palomas",
    "Leyes Locales Extrañas",
    "Memes Olvidados de los 2000",
    "Fobias de Personas Famosas",
    "Menús Secretos de Comida Rápida",
    "Nomenclatura de Muebles de IKEA",
    "Animales que se parecen a Famosos",
    "Aves Extintas que Nadie Extraña",
    "Curiosidades de Máquinas Expendedoras",
    "El Lenguaje Secreto de las Flores",
    "Récords Guinness de Comida",
    "Desastres de la Moda Histórica",
    "Preguntas Capciosas",
    "Deportes Inusuales",
    "Días Festivos Extraños",
    "Récords Mundiales Bizarros",
    "Tradiciones Extrañas",
    "Inventos Raros",
    "El dominio mundial de los delfines",
  ];

  static List<String> getSuggestions(
    String languageCode, {
    SuggestionType type = SuggestionType.general,
  }) {
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
          originalSuggestions = generalEs;
          break;
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
          originalSuggestions = generalEn;
          break;
      }
    }

    return List<String>.from(originalSuggestions)..shuffle();
  }
}
