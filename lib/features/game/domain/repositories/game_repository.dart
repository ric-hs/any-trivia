import 'package:endless_trivia/features/game/domain/entities/question.dart';

abstract class GameRepository {
  Future<List<Question>> getQuestions(List<String> categories, String language, int count);
}
