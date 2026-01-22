import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String text;
  final List<String> answers;
  final int correctAnswerIndex;
  final String category;

  const Question({
    required this.text,
    required this.answers,
    required this.correctAnswerIndex,
    required this.category,
  });

  bool isCorrect(int index) => index == correctAnswerIndex;

  @override
  List<Object> get props => [text, answers, correctAnswerIndex, category];
}
