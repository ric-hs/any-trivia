class GameCostCalculator {
  static int calculateCost(int rounds) {
    switch (rounds) {
      case 5:
        return 5;
      case 10:
        return 8;
      case 15:
        return 10;
      case 20:
        return 12;
      default:
        return rounds; // Fallback 1:1, though UI restricts to specific values
    }
  }
}
