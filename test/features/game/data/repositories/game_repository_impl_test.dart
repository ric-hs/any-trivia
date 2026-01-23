
import 'package:endless_trivia/features/game/data/datasources/gemini_service.dart';
import 'package:endless_trivia/features/game/data/repositories/game_repository_impl.dart';
import 'package:endless_trivia/features/game/domain/entities/question.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple manual mock since we don't have mockito/mocktail in pubspec
class MockGeminiService implements GeminiService {
  final Map<String, dynamic> calls = {
    'generateQuestion': 0,
    'generateQuestionsBatch': 0,
    'lastBatchCount': 0,
  };
  
  Question? initialQuestion;
  List<Question>? batchQuestions;
  
  MockGeminiService(); // No super call needed

  // We only need to implement what is used, but since it's 'implements', we need all public members.
  // The 'generateQuestion' method was present in previous tests, not sure if it's in the class.
  // Viewing GeminiService in step 17 shows NO generateQuestion method, only generateQuestions.
  // So we only need to implement generateQuestions.
  // Wait, if generateQuestion is NOT in GeminiService, we don't need to implement it.
  
  @override
  Future<List<Question>> generateQuestions(List<String> categories, String language, int count) async {
    calls['generateQuestionsBatch'] = (calls['generateQuestionsBatch'] ?? 0) + 1;
    calls['lastBatchCount'] = count;
    
    if (batchQuestions != null && batchQuestions!.length == count) {
      return batchQuestions!;
    }
    
    return List.generate(count, (index) => 
      Question(
        text: 'Batch Q $index', 
        answers: const ['A', 'B', 'C', 'D'], 
        correctAnswerIndex: 0, 
        category: 'test'
      )
    );
  }
}

void main() {
  late GameRepositoryImpl repository;
  late MockGeminiService mockGeminiService;

  setUp(() {
    mockGeminiService = MockGeminiService();
    repository = GameRepositoryImpl(geminiService: mockGeminiService);
  });

  test('getQuestions returns list of questions from service', () async {
    const count = 5;
    final questions = await repository.getQuestions(['General'], 'en', count);

    expect(questions.length, count);
    expect(questions.first.text, contains('Batch Q'));
    
    // Verify interactions
    expect(mockGeminiService.calls['generateQuestion'], 0, reason: 'Should not generate single question');
    expect(mockGeminiService.calls['generateQuestionsBatch'], 1, reason: 'Should generate batch once');
    expect(mockGeminiService.calls['lastBatchCount'], count);
  });

  test('getQuestions returns empty list if count is 0', () async {
    final questions = await repository.getQuestions(['General'], 'en', 0);
    expect(questions, isEmpty);
    expect(mockGeminiService.calls['generateQuestionsBatch'], 0);
  });
}
