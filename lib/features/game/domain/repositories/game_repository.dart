import 'package:endless_trivia/features/game/domain/entities/question.dart';

abstract class GameRepository {
  Stream<Question> getQuestions(String category, String language, int count);
}
