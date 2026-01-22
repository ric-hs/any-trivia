import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/features/game/domain/repositories/game_repository.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_event.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository _gameRepository;

  GameBloc({required GameRepository gameRepository})
      : _gameRepository = gameRepository,
        super(GameInitial()) {
    on<StartGame>((event, emit) => emit(GameInitial()));
    on<GetQuestion>(_onGetQuestion);
    on<AnswerQuestion>(_onAnswerQuestion);
  }

  Future<void> _onGetQuestion(GetQuestion event, Emitter<GameState> emit) async {
    emit(QuestionLoading());
    try {
      final question = await _gameRepository.getQuestion(event.category, event.language);
      emit(QuestionLoaded(question));
    } catch (e) {
      emit(GameError(e.toString()));
    }
  }

  void _onAnswerQuestion(AnswerQuestion event, Emitter<GameState> emit) {
    if (state is QuestionLoaded) {
      final currentQuestion = (state as QuestionLoaded).question;
      final isCorrect = currentQuestion.isCorrect(event.selectedIndex);
      emit(AnswerSubmitted(
        question: currentQuestion,
        selectedIndex: event.selectedIndex,
        isCorrect: isCorrect,
      ));
    }
  }
}
