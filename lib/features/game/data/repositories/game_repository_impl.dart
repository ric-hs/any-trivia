import 'package:endless_trivia/features/game/data/datasources/gemini_service.dart';
import 'package:endless_trivia/features/game/domain/entities/question.dart';
import 'package:endless_trivia/features/game/domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final GeminiService _geminiService;

  GameRepositoryImpl({required GeminiService geminiService})
      : _geminiService = geminiService;

  @override
  Future<Question> getQuestion(String category, String language) async {
    return _geminiService.generateQuestion(category, language);
  }
}
