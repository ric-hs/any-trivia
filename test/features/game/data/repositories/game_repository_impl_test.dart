
import 'package:endless_trivia/features/game/data/datasources/gemini_service.dart';
import 'package:endless_trivia/features/game/data/repositories/game_repository_impl.dart';
import 'package:endless_trivia/features/game/domain/entities/question.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple manual mock since we don't have mockito/mocktail in pubspec
class MockGeminiService extends GeminiService {
  final Map<String, dynamic> calls = {
    'generateQuestion': 0,
    'generateQuestionsBatch': 0,
  };
  
  Question? initialQuestion;
  List<Question>? batchQuestions;
  
  MockGeminiService() : super();

  @override
  Future<Question> generateQuestion(List<String> categories, String language) async {
    calls['generateQuestion'] = (calls['generateQuestion'] ?? 0) + 1;
    return initialQuestion ?? 
        const Question(
          text: 'Single Q', 
          answers: ['A', 'B', 'C', 'D'], 
          correctAnswerIndex: 0, 
          category: 'test'
        );
  }

  @override
  Future<List<Question>> generateQuestionsBatch(List<String> categories, String language, int count) async {
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

  test('getQuestions uses batch generation for 5 questions (<= threshold)', () async {
    final stream = repository.getQuestions(['General'], 'en', 5);
    final questions = await stream.toList();

    expect(questions.length, 5);
    expect(questions.first.text, contains('Batch Q'));
    
    // Verify interactions
    expect(mockGeminiService.calls['generateQuestion'], 0, reason: 'Should not generate single question');
    expect(mockGeminiService.calls['generateQuestionsBatch'], 1, reason: 'Should generate batch once');
    expect(mockGeminiService.calls['lastBatchCount'], 5);
  });

  test('getQuestions splits generation for 51 questions (> threshold)', () async {
    final stream = repository.getQuestions(['General'], 'en', 51);
    final questions = await stream.toList();

    expect(questions.length, 51);
    expect(questions.first.text, 'Single Q');
    expect(questions[1].text, contains('Batch Q'));
    
    // Verify interactions
    expect(mockGeminiService.calls['generateQuestion'], 1, reason: 'Should generate first question singly');
    expect(mockGeminiService.calls['generateQuestionsBatch'], 1, reason: 'Should generate remaining batch');
    expect(mockGeminiService.calls['lastBatchCount'], 50, reason: 'Batch count should be 51 - 1');
  });

  test('getQuestions respects threshold boundary (exactly 10)', () async {
    final stream = repository.getQuestions(['General'], 'en', 10);
    final questions = await stream.toList();

    expect(questions.length, 10);
    
    // Should still be batch only
    expect(mockGeminiService.calls['generateQuestion'], 0);
    expect(mockGeminiService.calls['generateQuestionsBatch'], 1);
    expect(mockGeminiService.calls['lastBatchCount'], 10);
  });
}
