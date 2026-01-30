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
  final int currentRound;
  final int totalRounds;

  const QuestionLoaded({required this.question, required this.currentRound, required this.totalRounds});

  @override
  List<Object?> get props => [question, currentRound, totalRounds];
}

final class AnswerSubmitted extends GameState {
  final Question question;
  final int selectedIndex;
  final bool isCorrect;
  final int currentRound;
  final int totalRounds;

  const AnswerSubmitted({
    required this.question,
    required this.selectedIndex,
    required this.isCorrect,
    required this.currentRound,
    required this.totalRounds,
  });

  @override
  List<Object?> get props => [question, selectedIndex, isCorrect, currentRound, totalRounds];
}

final class GameError extends GameState {
  final String message;

  const GameError(this.message);

  @override
  List<Object?> get props => [message];
}

final class GameFinished extends GameState {
  final int score;
  final int totalQuestions;

  const GameFinished({required this.score, required this.totalQuestions});

  @override
  List<Object?> get props => [score, totalQuestions];
}
