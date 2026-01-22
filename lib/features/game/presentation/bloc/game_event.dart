import 'package:equatable/equatable.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

final class StartGame extends GameEvent {}

final class GetQuestion extends GameEvent {
  final String category;
  final String language;

  const GetQuestion({required this.category, this.language = 'en'});

  @override
  List<Object> get props => [category, language];
}

final class AnswerQuestion extends GameEvent {
  final int selectedIndex;

  const AnswerQuestion(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}
