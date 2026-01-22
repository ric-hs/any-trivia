import 'package:endless_trivia/features/game/domain/entities/question.dart';

abstract class GameRepository {
  Future<Question> getQuestion(String category, String language);
}
