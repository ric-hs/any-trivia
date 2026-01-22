import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/core/di/injection_container.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_bloc.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_event.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_state.dart';

class GamePage extends StatelessWidget {
  final String category;

  const GamePage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GameBloc>()..add(GetQuestion(category: category)),
      child: const _GameView(),
    );
  }
}

class _GameView extends StatelessWidget {
  const _GameView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TRIVIA')),
      body: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
           if (state is AnswerSubmitted) {
             showDialog(context: context, builder: (_) => AlertDialog(
               title: Text(
                 state.isCorrect ? 'CORRECT!' : 'WRONG!',
                 style: TextStyle(color: state.isCorrect ? Colors.green : Colors.red),
               ),
               content: Text(state.isCorrect 
                   ? 'Great job!' 
                   : 'The correct answer was: ${state.question.answers[state.question.correctAnswerIndex]}'),
               actions: [
                 TextButton(
                   onPressed: () {
                     Navigator.of(context).pop(); // Close dialog
                     Navigator.of(context).pop(); // Go back to Home
                   },
                   child: const Text('CONTINUE'),
                 )
               ],
             ));
           }
        },
        builder: (context, state) {
          if (state is GameInitial || state is QuestionLoading) {
            return const Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Generating Question with AI...'),
              ],
            ));
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
                     padding: const EdgeInsets.all(20),
                     decoration: BoxDecoration(
                       color: const Color(0xFF2C2C2C),
                       borderRadius: BorderRadius.circular(16),
                       border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                     ),
                     child: Text(
                       q.text, 
                       style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                       textAlign: TextAlign.center,
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
