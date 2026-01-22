import 'package:equatable/equatable.dart';
import 'package:endless_trivia/features/game/domain/entities/question.dart';

sealed class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

final class GameInitial extends GameState {}

final class QuestionLoading extends GameState {}

final class QuestionLoaded extends GameState {
  final Question question;

  const QuestionLoaded(this.question);

  @override
  List<Object?> get props => [question];
}

final class AnswerSubmitted extends GameState {
  final Question question;
  final int selectedIndex;
  final bool isCorrect;

  const AnswerSubmitted({
    required this.question,
    required this.selectedIndex,
    required this.isCorrect,
  });

  @override
  List<Object?> get props => [question, selectedIndex, isCorrect];
}

final class GameError extends GameState {
  final String message;

  const GameError(this.message);

  @override
  List<Object?> get props => [message];
}

final class GameFinished extends GameState {}
