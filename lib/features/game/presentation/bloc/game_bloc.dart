import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/features/game/domain/entities/question.dart';
import 'package:endless_trivia/features/game/domain/repositories/game_repository.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_event.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_state.dart';
import 'package:endless_trivia/features/profile/domain/repositories/profile_repository.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository _gameRepository;
  final ProfileRepository _profileRepository;
  final List<Question> _questionsQueue = [];

  int _currentRound = 0;
  int _totalRounds = 0;

  GameBloc({
    required GameRepository gameRepository,
    required ProfileRepository profileRepository,
  }) : _gameRepository = gameRepository,
       _profileRepository = profileRepository,
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
        // Questions were retrieved successfully, now try to consume token
        try {
          await _profileRepository.consumeTokens(
            event.userId,
            event.rounds,
          );

          // Token consumed successfully, proceed with game
          _questionsQueue.addAll(questions);
          final firstQuestion = _questionsQueue.removeAt(0);
          emit(
            QuestionLoaded(
              question: firstQuestion,
              currentRound: _currentRound,
              totalRounds: _totalRounds,
            ),
          );
        } catch (e) {
          // Failure during token retrieval or update
          emit(const GameError('unableToRetrieveTokens'));
        }
      } else {
        emit(GameFinished());
      }
    } catch (e) {
      emit(const GameError('errorLoadQuestions'));
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
