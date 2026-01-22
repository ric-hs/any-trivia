import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:endless_trivia/features/game/domain/entities/question.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService({String? apiKey}) 
      : _model = GenerativeModel(
          model: 'gemini-3-flash-preview', 
          apiKey: apiKey ?? const String.fromEnvironment('GEMINI_API_KEY'),
          generationConfig: GenerationConfig(responseMimeType: 'application/json'),
        );

  Future<Question> generateQuestion(String category, String language) async {
    final prompt = '''
      Generate a trivia question about "$category" in "$language".
      Return a JSON object with the following schema:
      {
        "question": "The question text",
        "answers": ["Answer 1", "Answer 2", "Answer 3", "Answer 4"],
        "correctIndex": 0 // Index of the correct answer (0-3)
      }
      Ensure there is exactly one correct answer and 3 incorrect ones.
      Make the question challenging but fun.
    ''';

    final content = [Content.text(prompt)];
    try {
      final response = await _model.generateContent(content);
      
      if (response.text == null) throw Exception('Empty response from AI');

      final json = jsonDecode(response.text!);
      return Question(
        text: json['question'],
        answers: List<String>.from(json['answers']),
        correctAnswerIndex: json['correctIndex'],
        category: category,
      );
    } catch (e) {
      // Fallback or rethrow? Rethrow for now.
      throw Exception('Failed to generate question: $e');
    }
  }
}
