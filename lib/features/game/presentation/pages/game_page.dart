import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/core/di/injection_container.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_bloc.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_event.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_state.dart';

import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:endless_trivia/features/game/presentation/widgets/loading_view.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_event.dart';

class GamePage extends StatelessWidget {
  final List<String> categories;

  final String language;
  final int rounds;
  final String userId;

  const GamePage({
    super.key,
    required this.categories,
    required this.language,
    required this.userId,
    this.rounds = 1,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GameBloc>()
        ..add(
          GetQuestion(
            userId: userId,
            categories: categories,
            language: language,
            rounds: rounds,
          ),
        ),
      child: _GameView(rounds: rounds, userId: userId),
    );
  }
}

class _GameView extends StatelessWidget {
  final int rounds;
  final String userId;
  const _GameView({required this.rounds, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<GameBloc, GameState>(
          listener: (context, state) {
            if (state is GameFinished) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Game Over'),
                  content: const Text('You have completed all rounds!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.of(context).pop(); // Go back to Home
                      },
                      child: const Text('Main Menu'),
                    ),
                  ],
                ),
              );
            } else if (state is QuestionLoaded) {
              if (state.currentRound == 1) {
                // Sync UI tokens count after consumption
                context.read<ProfileBloc>().add(
                  LoadProfile(userId, showLoading: false),
                );
              }
            }
          },
          builder: (context, state) {
            if (state is GameInitial || state is QuestionLoading) {
              return const LoadingView();
            } else if (state is GameError) {
              final message = state.message == 'errorLoadQuestions'
                  ? AppLocalizations.of(context)!.errorLoadQuestions
                  : state.message == 'unableToRetrieveTokens'
                      ? AppLocalizations.of(context)!.unableToRetrieveTokens
                      : state.message == 'notEnoughTokens'
                          ? AppLocalizations.of(context)!.notEnoughTokens(rounds, 0) // tokens count is tricky here, maybe just generic
                          : state.message;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: $message', textAlign: TextAlign.center),
                ),
              );
            } else if (state is QuestionLoaded || state is AnswerSubmitted) {
              final q = (state is QuestionLoaded)
                  ? state.question
                  : (state as AnswerSubmitted).question;

              final currentRound = (state is QuestionLoaded)
                  ? state.currentRound
                  : (state as AnswerSubmitted).currentRound;

              final totalRounds = (state is QuestionLoaded)
                  ? state.totalRounds
                  : (state as AnswerSubmitted).totalRounds;

              int? selectedIndex;
              bool? isCorrect;

              if (state is AnswerSubmitted) {
                selectedIndex = state.selectedIndex;
                isCorrect = state.isCorrect;
              }

              return Column(
                children: [
                  // Custom Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Round Counter (Top Left)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.roundProgress(currentRound, totalRounds),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        // Category (Top Center)
                        Expanded(
                          child: Text(
                            q.category.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Quit Button (Top Right)
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          tooltip: 'Quit Game',
                        ),
                      ],
                    ),
                  ),
                  
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C2C2C),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  q.text,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          ...List.generate(4, (index) {
                            Color backgroundColor = const Color(0xFF424242);
                            if (state is AnswerSubmitted) {
                              if (index == q.correctAnswerIndex) {
                                backgroundColor = Colors.green;
                              } else if (index == selectedIndex && !isCorrect!) {
                                backgroundColor = Colors.red;
                              } else {
                                backgroundColor = Colors.grey.shade800;
                              }
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  backgroundColor: backgroundColor,
                                  disabledBackgroundColor: backgroundColor,
                                  disabledForegroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: state is AnswerSubmitted
                                    ? null
                                    : () {
                                        context.read<GameBloc>().add(
                                          AnswerQuestion(index),
                                        );
                                      },
                                child: Text(
                                  q.answers[index],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }),
                          if (state is AnswerSubmitted) ...[
                            const SizedBox(height: 20),
                            Text(
                              state.isCorrect
                                  ? AppLocalizations.of(context)!.correct
                                  : AppLocalizations.of(context)!.wrong,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: state.isCorrect ? Colors.green : Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (!state.isCorrect) ...[
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.correctAnswerWas(q.answers[q.correctAnswerIndex]),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                if (currentRound == totalRounds) {
                                  Navigator.of(context).pop(); // Go to Home
                                } else {
                                  context.read<GameBloc>().add(NextQuestion());
                                }
                              },
                              child: Text(
                                currentRound == totalRounds
                                    ? AppLocalizations.of(context)!.endGame
                                    : AppLocalizations.of(context)!.continueBtn,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
