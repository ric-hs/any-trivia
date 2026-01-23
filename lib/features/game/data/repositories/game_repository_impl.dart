import 'package:endless_trivia/features/game/data/datasources/gemini_service.dart';
import 'package:endless_trivia/features/game/domain/entities/question.dart';
import 'package:endless_trivia/features/game/domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final GeminiService _geminiService;

  GameRepositoryImpl({required GeminiService geminiService})
    : _geminiService = geminiService;

  @override
  Stream<Question> getQuestions(
    List<String> categories,
    String language,
    int count,
  ) async* {
    if (count <= 0) return;

    try {
      final batchQuestions = await _geminiService.generateQuestions(
        categories,
        language,
        count,
      );
      for (final question in batchQuestions) {
        yield question;
      }
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }
}
