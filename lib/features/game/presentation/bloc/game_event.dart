import 'package:equatable/equatable.dart';
import 'package:endless_trivia/features/game/domain/entities/question.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

final class StartGame extends GameEvent {}

final class GetQuestion extends GameEvent {
  final String category;
  final String language;
  final int rounds;

  const GetQuestion({required this.category, this.language = 'en', this.rounds = 1});

  @override
  List<Object> get props => [category, language, rounds];
}

final class NextQuestion extends GameEvent {}

final class AnswerQuestion extends GameEvent {
  final int selectedIndex;

  const AnswerQuestion(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}

final class QuestionReceived extends GameEvent {
  final Question question;
  
  const QuestionReceived(this.question);

  @override
  List<Object> get props => [question];
}
