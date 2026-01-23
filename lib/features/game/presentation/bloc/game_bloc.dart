import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/features/game/domain/entities/question.dart';
import 'package:endless_trivia/features/game/domain/repositories/game_repository.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_event.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository _gameRepository;
  final List<Question> _questionsQueue = [];

  int _currentRound = 0;
  int _totalRounds = 0;

  GameBloc({required GameRepository gameRepository})
    : _gameRepository = gameRepository,
      super(GameInitial()) {
    on<StartGame>((event, emit) => emit(GameInitial()));
    on<GetQuestion>(_onGetQuestion);

    on<NextQuestion>(_onNextQuestion);
    on<AnswerQuestion>(_onAnswerQuestion);
  }

  Future<void> _onGetQuestion(
    GetQuestion event,
    Emitter<GameState> emit,
  ) async {
    _questionsQueue.clear();
    _currentRound = 1;
    _totalRounds = event.rounds;
    emit(QuestionLoading());

    try {
      final questions = await _gameRepository.getQuestions(
        event.categories,
        event.language,
        event.rounds,
      );

      if (questions.isNotEmpty) {
        _questionsQueue.addAll(questions);
        final firstQuestion = _questionsQueue.removeAt(0);
        emit(
          QuestionLoaded(
            question: firstQuestion,
            currentRound: _currentRound,
            totalRounds: _totalRounds,
          ),
        );
      } else {
        // Handle empty list if necessary, maybe emit failure or finish
        emit(GameFinished());
      }
    } catch (e) {
      // Ideally emit GameError or similar, but for now just log or stay in Loading/Init?
      // Based on existing code, it didn't strictly handle error state emission explicitly in the listener onError block shown.
      // We'll emit GameFinished for safety or maybe GameInitial.
      // Let's assume we should at least not be stuck in Loading.
      emit(GameError('errorLoadQuestions'));
    }
  }

  void _onNextQuestion(NextQuestion event, Emitter<GameState> emit) {
    if (_questionsQueue.isNotEmpty) {
      final nextQuestion = _questionsQueue.removeAt(0);
      _currentRound++;
      emit(
        QuestionLoaded(
          question: nextQuestion,
          currentRound: _currentRound,
          totalRounds: _totalRounds,
        ),
      );
    } else {
      // Logic for stream finished or waiting...
      // For now assuming if queue empty and stream done -> finished.
      // But we simplified to wait if queue empty (loading) or finish if we tracked it.
      // Let's stick to "wait for more" (Loading) if we expect more,
      // OR Finish if we hit total rounds.
      if (_currentRound >= _totalRounds) {
        emit(GameFinished());
      } else {
        emit(QuestionLoading());
      }
    }
  }

  void _onAnswerQuestion(AnswerQuestion event, Emitter<GameState> emit) {
    if (state is QuestionLoaded) {
      final currentQuestion = (state as QuestionLoaded).question;
      final isCorrect = currentQuestion.isCorrect(event.selectedIndex);
      emit(
        AnswerSubmitted(
          question: currentQuestion,
          selectedIndex: event.selectedIndex,
          isCorrect: isCorrect,
          currentRound: _currentRound,
          totalRounds: _totalRounds,
        ),
      );
    }
  }
}
