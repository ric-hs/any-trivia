import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/core/di/injection_container.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_bloc.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_event.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_state.dart';

import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:endless_trivia/features/game/presentation/widgets/loading_view.dart';

class GamePage extends StatelessWidget {
  final List<String> categories;
  final String language;
  final int rounds;

  const GamePage({super.key, required this.categories, required this.language, this.rounds = 1});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GameBloc>()..add(GetQuestion(categories: categories, language: language, rounds: rounds)),
      child: const _GameView(),
    );
  }
}

class _GameView extends StatelessWidget {
  const _GameView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appTitle.toUpperCase())),
      body: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
           if (state is AnswerSubmitted) {
             showDialog(context: context, builder: (_) => AlertDialog(
               title: Text(
                 state.isCorrect ? AppLocalizations.of(context)!.correct : AppLocalizations.of(context)!.wrong,
                 style: TextStyle(color: state.isCorrect ? Colors.green : Colors.red),
               ),
               content: Text(state.isCorrect 
                   ? AppLocalizations.of(context)!.greatJob 
                   : AppLocalizations.of(context)!.correctAnswerWas(state.question.answers[state.question.correctAnswerIndex])),
               actions: [
                 TextButton(
                   onPressed: () {
                     Navigator.of(context).pop(); // Close dialog
                     context.read<GameBloc>().add(NextQuestion());
                   },
                   child: Text(AppLocalizations.of(context)!.continueBtn),
                 )
               ],
             ));
           } else if (state is GameFinished) {
             showDialog(context: context, builder: (_) => AlertDialog(
               title: const Text('Game Over'),
               content: const Text('You have completed all rounds!'),
               actions: [
                 TextButton(
                   onPressed: () {
                     Navigator.of(context).pop(); // Close dialog
                     Navigator.of(context).pop(); // Go back to Home
                   },
                   child: const Text('Main Menu'),
                 )
               ],
             ));
           }
        },
        builder: (context, state) {
          if (state is GameInitial || state is QuestionLoading) {
            return const LoadingView();
          } else if (state is GameError) {
             return Center(child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: Text('Error: ${state.message}', textAlign: TextAlign.center),
             ));
          } else if (state is QuestionLoaded) {
             final q = state.question;
             return Padding(
               padding: const EdgeInsets.all(20.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   Container(
                     margin: const EdgeInsets.only(bottom: 20),
                     child: Text(
                       AppLocalizations.of(context)!.roundProgress(state.currentRound, state.totalRounds),
                       style: const TextStyle(fontSize: 18, color: Colors.grey),
                       textAlign: TextAlign.center,
                     ),
                   ),
                   Container(
                     padding: const EdgeInsets.all(20),
                     decoration: BoxDecoration(
                       color: const Color(0xFF2C2C2C),
                       borderRadius: BorderRadius.circular(16),
                       border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                     ),
                     child: Column(
                       children: [
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                           margin: const EdgeInsets.only(bottom: 16),
                           decoration: BoxDecoration(
                             color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                             borderRadius: BorderRadius.circular(12),
                           ),
                           child: Text(
                             q.category.toUpperCase(),
                             style: TextStyle(
                               color: Theme.of(context).primaryColorLight,
                               fontSize: 12,
                               fontWeight: FontWeight.bold,
                               letterSpacing: 1.5,
                             ),
                           ),
                         ),
                         Text(
                           q.text, 
                           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                           textAlign: TextAlign.center,
                         ),
                       ],
                     ),
                   ),
                   const SizedBox(height: 40),
                   ...List.generate(4, (index) {
                     return Padding(
                       padding: const EdgeInsets.only(bottom: 16.0),
                       child: ElevatedButton(
                         style: ElevatedButton.styleFrom(
                           padding: const EdgeInsets.symmetric(vertical: 20),
                           backgroundColor: const Color(0xFF424242),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                         ),
                         onPressed: () {
                           context.read<GameBloc>().add(AnswerQuestion(index));
                         }, 
                         child: Text(q.answers[index], style: const TextStyle(fontSize: 18, color: Colors.white)),
                       ),
                     );
                   }),
                 ],
               ),
             );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
