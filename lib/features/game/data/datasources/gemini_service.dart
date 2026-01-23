
import 'package:cloud_functions/cloud_functions.dart';
import 'package:endless_trivia/features/game/domain/entities/question.dart';

class GeminiService {
  final FirebaseFunctions _functions;

  GeminiService() : _functions = FirebaseFunctions.instance;

  Future<List<Question>> generateQuestions(List<String> categories, String language, int count) async {
    try {
      final result = await _functions.httpsCallable('generateQuestion').call({
        'categories': categories,
        'language': language,
        'count': count,
      });

      final List<dynamic> jsonList = result.data;
      return jsonList.map((json) => Question(
        text: json['question'],
        answers: List<String>.from(json['answers']),
        correctAnswerIndex: json['correctIndex'],
        category: json['category'] ?? categories.first,
      )).toList();
    } catch (e) {
      throw Exception('Failed to generate questions batch: $e');
    }
  }
}
