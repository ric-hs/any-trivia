import 'package:endless_trivia/features/game/data/datasources/gemini_service.dart';
import 'package:endless_trivia/features/game/domain/entities/question.dart';
import 'package:endless_trivia/features/game/domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final GeminiService _geminiService;

  GameRepositoryImpl({required GeminiService geminiService})
      : _geminiService = geminiService;

  @override
  Stream<Question> getQuestions(String category, String language, int count) async* {
    if (count <= 0) return;

    // 1. Generate the first question instantly
    try {
      final firstQuestion = await _geminiService.generateQuestion(category, language);
      yield firstQuestion;
    } catch (e) {
      // If the first one fails, we can't start the game.
      throw Exception('Failed to start game: $e');
    }

    if (count > 1) {
      // 2. Generate the rest in the background
      try {
        final remainingCount = count - 1;
        final batchQuestions = await _geminiService.generateQuestionsBatch(category, language, remainingCount);
        for (final question in batchQuestions) {
          yield question;
        }
      } catch (e) {
        // If batch fails, we can still play the first one, or throw. 
        // Emitting an error here allows handling it gracefully in the UI (e.g. end game early)
        throw Exception('Failed to load remaining questions: $e');
      }
    }
  }
}
