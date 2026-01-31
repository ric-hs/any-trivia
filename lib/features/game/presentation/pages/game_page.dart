import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/core/di/injection_container.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_bloc.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_event.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_state.dart';

import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:endless_trivia/features/game/presentation/widgets/loading_view.dart';
import 'package:endless_trivia/features/game/presentation/widgets/game_results_view.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_event.dart';
import 'package:endless_trivia/features/game/presentation/utils/game_cost_calculator.dart';

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
            if (state is QuestionLoaded) {
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
                   ? AppLocalizations.of(context)!.notEnoughTokens(
                       rounds,
                       0,
                       GameCostCalculator.calculateCost(rounds),
                     ) // tokens count is tricky here, maybe just generic
                  : state.message;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sentiment_dissatisfied_outlined,
                        size: 80,
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Error: $message',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            AppLocalizations.of(context)!.backToMenu,
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is GameFinished) {
              return GameResultsView(
                score: state.score,
                totalQuestions: state.totalQuestions,
                onBackToMenu: () => Navigator.of(context).pop(),
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

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final inAnimation = Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation);

                  final outAnimation = Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation);

                  if (child.key == ValueKey(currentRound)) {
                    return SlideTransition(position: inAnimation, child: child);
                  } else {
                    return SlideTransition(
                      position: outAnimation,
                      child: child,
                    );
                  }
                },
                child: Column(
                  key: ValueKey(currentRound),
                  children: [
                    // Custom Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Round Counter (Top Left)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.roundProgress(currentRound, totalRounds),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          // Quit Button (Top Right)
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    AppLocalizations.of(context)!.quitGameTitle,
                                  ),
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.quitGameContent,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // Close dialog
                                        Navigator.of(
                                          context,
                                        ).pop(); // Go to Home
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.confirm,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.close),
                            tooltip: 'Quit Game',
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 20.0,
                        ),
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
                                  // Category (Top Center)
                                  Text(
                                    q.category.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).primaryColorLight,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
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
                            const SizedBox(height: 28),
                            ...List.generate(4, (index) {
                              Color backgroundColor = const Color(0xFF424242);
                              if (state is AnswerSubmitted) {
                                if (index == q.correctAnswerIndex) {
                                  backgroundColor = Colors.green;
                                } else if (index == selectedIndex &&
                                    !isCorrect!) {
                                  backgroundColor = Colors.red;
                                } else {
                                  backgroundColor = Colors.grey.shade800;
                                }
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
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
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            // if (state is AnswerSubmitted) ...[
                            //   const SizedBox(height: 20),
                            //   Text(
                            //     state.isCorrect
                            //         ? AppLocalizations.of(context)!.correct
                            //         : AppLocalizations.of(context)!.wrong,
                            //     style: TextStyle(
                            //       fontSize: 24,
                            //       fontWeight: FontWeight.bold,
                            //       color: state.isCorrect
                            //           ? Colors.green
                            //           : Colors.red,
                            //     ),
                            //     textAlign: TextAlign.center,
                            //   ),
                            //   if (!state.isCorrect) ...[
                            //     const SizedBox(height: 8),
                            //     Text(
                            //       AppLocalizations.of(
                            //         context,
                            //       )!.correctAnswerWas(
                            //         q.answers[q.correctAnswerIndex],
                            //       ),
                            //       style: const TextStyle(
                            //         fontSize: 16,
                            //         color: Colors.white70,
                            //       ),
                            //       textAlign: TextAlign.center,
                            //     ),
                            //   ],
                            //   const SizedBox(height: 20),
                            // ],
                          ],
                        ),
                      ),
                    ),
                    if (state is AnswerSubmitted) ...[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (currentRound == totalRounds) {
                              // If last round, next action should trigger finishing
                              context.read<GameBloc>().add(NextQuestion());
                            } else {
                              context.read<GameBloc>().add(NextQuestion());
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentRound == totalRounds
                                    ? AppLocalizations.of(context)!.resultsTitle
                                    : AppLocalizations.of(context)!.continueBtn,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
