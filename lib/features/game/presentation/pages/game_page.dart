import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:endless_trivia/core/theme/app_theme.dart';
import 'package:endless_trivia/core/di/injection_container.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_bloc.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_event.dart';
import 'package:endless_trivia/features/game/presentation/bloc/game_state.dart';

import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:endless_trivia/features/game/presentation/widgets/loading_view.dart';
import 'package:endless_trivia/features/game/presentation/widgets/game_results_view.dart';
import 'package:endless_trivia/features/game/presentation/widgets/particle_burst.dart';
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
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF100F1F), Color(0xFF2A0045)],
          ),
        ),
        child: SafeArea(
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
                          Icons.error_outline,
                          size: 80,
                          color: Theme.of(context).colorScheme.error,
                        ).animate().shake(),
                        const SizedBox(height: 24),
                        Text(
                          'SYSTEM FAILURE',
                          style: AppTheme.gameFont.copyWith(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6200EA),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.backToMenu.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                              ),
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

                return Stack(
                  children: [
                    // Main Content with Animation
                    Positioned.fill(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: Curves.easeOutBack,
                        switchOutCurve: Curves.easeInBack,
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              // Custom slide + fade
                              final inOffset = Tween<Offset>(
                                begin: const Offset(0.2, 0),
                                end: Offset.zero,
                              ).animate(animation);
                              final outOffset = Tween<Offset>(
                                begin: const Offset(-0.2, 0),
                                end: Offset.zero,
                              ).animate(animation);
                              final fade = Tween<double>(
                                begin: 0.0,
                                end: 1.0,
                              ).animate(animation);

                              return FadeTransition(
                                opacity: fade,
                                child: SlideTransition(
                                  position: child.key == ValueKey(currentRound)
                                      ? inOffset
                                      : outOffset,
                                  child: child,
                                ),
                              );
                            },
                        child: Column(
                          key: ValueKey(currentRound),
                          children: [
                            // HUD Header
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Round Counter
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF00E5FF,
                                        ).withValues(alpha: 0.5),
                                      ),
                                    ),
                                    child: Text(
                                      "ROUND $currentRound / $totalRounds",
                                      style: AppTheme.gameFont.copyWith(
                                        color: const Color(0xFF00E5FF),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  // Quit Button
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: Theme.of(
                                            context,
                                          ).cardTheme.color,
                                          title: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.quitGameTitle,
                                            style: AppTheme.gameFont.copyWith(
                                              fontSize: 24,
                                              color: Colors.white,
                                            ),
                                          ),
                                          content: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.quitGameContent,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.cancel,
                                                style: const TextStyle(
                                                  color: Colors.white60,
                                                ),
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
                                                AppLocalizations.of(
                                                  context,
                                                )!.confirm,
                                                style: const TextStyle(
                                                  color: Color(0xFFFF2B5E),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white70,
                                    ),
                                    tooltip: 'Quit Game',
                                  ),
                                ],
                              ),
                            ),

                            // Content
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 24.0,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Glassmorphic Question Card
                                    Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF252538,
                                        ).withValues(alpha: 0.8),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: const Color(
                                            0xFFD300F9,
                                          ).withValues(alpha: 0.5),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFD300F9,
                                            ).withValues(alpha: 0.2),
                                            blurRadius: 20,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          // Category Label
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFFD300F9,
                                              ).withValues(alpha: 0.2),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              q.category.toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.outfit(
                                                color: const Color(0xFFD300F9),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.5,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            q.text,
                                            style: GoogleFonts.outfit(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              height: 1.3,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ).animate().fadeIn().scale(),

                                    const SizedBox(height: 48),

                                    ...List.generate(4, (index) {
                                      Color backgroundColor = const Color(
                                        0xFF252538,
                                      );
                                      Color borderColor = Colors.white10;
                                      Color textColor = Colors.white;

                                      if (state is AnswerSubmitted) {
                                        if (index == q.correctAnswerIndex) {
                                          backgroundColor = const Color(
                                            0xFF00C853,
                                          ); // Success Green
                                          borderColor = const Color(0xFF69F0AE);
                                        } else if (index == selectedIndex &&
                                            !isCorrect!) {
                                          backgroundColor = const Color(
                                            0xFFFF2B5E,
                                          ); // Error Red
                                          borderColor = const Color(0xFFFF80AB);
                                        } else {
                                          backgroundColor = backgroundColor
                                              .withValues(alpha: 0.5);
                                          textColor = Colors.white38;
                                        }
                                      }

                                      final isSelectedWrong =
                                          state is AnswerSubmitted &&
                                          index == selectedIndex &&
                                          !isCorrect!;
                                      
                                      final isCorrectAnswer = 
                                          state is AnswerSubmitted && 
                                          index == q.correctAnswerIndex;

                                      return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 16.0,
                                            ),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              clipBehavior: Clip.none,
                                              children: [
                                                // 1. Particle Burst (Behind) - Only for correct answer
                                                if (isCorrectAnswer &&
                                                    (isCorrect == true))
                                                  Positioned.fill(
                                                    child: ParticleBurst(
                                                      color: const Color(0xFF00C853),
                                                    ),
                                                  ),
                                                  
                                                // 2. The Button
                                                AnimatedContainer(
                                                  duration: 300.ms,
                                                  width: double.infinity,
                                                  curve: Curves.easeOut,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 20,
                                                            horizontal: 16,
                                                          ),
                                                      backgroundColor:
                                                          backgroundColor,
                                                      disabledBackgroundColor:
                                                          backgroundColor,
                                                      disabledForegroundColor:
                                                          Colors.white,
                                                      elevation:
                                                          state
                                                                  is AnswerSubmitted &&
                                                              (index ==
                                                                      q.correctAnswerIndex ||
                                                                  index ==
                                                                      selectedIndex)
                                                          ? 8
                                                          : 2,
                                                      shadowColor: borderColor
                                                          .withValues(alpha: 0.5),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                        side: BorderSide(
                                                          color: borderColor,
                                                          width:
                                                              state
                                                                      is AnswerSubmitted &&
                                                                  (index ==
                                                                          q.correctAnswerIndex ||
                                                                      index ==
                                                                          selectedIndex)
                                                              ? 2
                                                              : 1,
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed:
                                                        state is AnswerSubmitted
                                                        ? null
                                                        : () {
                                                            context
                                                                .read<GameBloc>()
                                                                .add(
                                                                  AnswerQuestion(
                                                                    index,
                                                                  ),
                                                                );
                                                          },
                                                    child: Text(
                                                      q.answers[index],
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                // Incorrect: Rapid Horizontal Shake ("No")
                                                .animate(
                                                  target: isSelectedWrong ? 1 : 0,
                                                )
                                                .shakeX(hz: 8, amount: 6, curve: Curves.easeInOutCubic) // Horizontal Shake
                                                
                                                // Correct: Bounce (Squash & Stretch)
                                                .animate(
                                                  target: isCorrectAnswer ? 1 : 0,
                                                )
                                                .scaleXY(
                                                  end: 1.05, 
                                                  duration: 150.ms,
                                                  curve: Curves.easeOut,
                                                )
                                                .then()
                                                .scaleXY(
                                                  end: 1.0,
                                                  duration: 100.ms,
                                                  curve: Curves.easeIn,
                                                )
                                                
                                                // Entrance Animation (Always run on build)
                                                .animate(delay: (100 * index).ms)
                                                .fadeIn()
                                                .slideY(begin: 0.5, end: 0),
                                              ],
                                            ),
                                          );
                                    }),

                                    // Spacer for floating button
                                    const SizedBox(height: 100),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Floating Continue/Results Button
                    if (state is AnswerSubmitted)
                      Positioned(
                        bottom: 24,
                        left: 24,
                        right: 24,
                        child:
                            ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                    backgroundColor: const Color(0xFF6200EA),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                        color: Color.fromARGB(255, 143, 163, 255),
                                        width: 2,
                                      ),
                                    ),
                                    elevation: 12,
                                    shadowColor: const Color(
                                      0xFF6200EA,
                                    ).withValues(alpha: 0.6),
                                  ),
                                  onPressed: () {
                                    if (currentRound == totalRounds) {
                                      // If last round, next action should trigger finishing
                                      context.read<GameBloc>().add(
                                        NextQuestion(),
                                      );
                                    } else {
                                      context.read<GameBloc>().add(
                                        NextQuestion(),
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        currentRound == totalRounds
                                            ? AppLocalizations.of(
                                                context,
                                              )!.resultsTitle.toUpperCase()
                                            : AppLocalizations.of(
                                                context,
                                              )!.continueBtn.toUpperCase(),
                                        style: AppTheme.gameFont.copyWith(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        currentRound == totalRounds
                                            ? Icons.flag
                                            : Icons.arrow_forward_rounded,
                                        size: 28,
                                      ),
                                    ],
                                  ),
                                )
                                .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true),
                                )
                                .boxShadow(
                                  begin: BoxShadow(
                                    color: const Color(
                                      0xFF6200EA,
                                    ).withValues(alpha: 0.5),
                                    blurRadius: 10,
                                  ),
                                  end: BoxShadow(
                                    color: const Color(
                                      0xFF6200EA,
                                    ).withValues(alpha: 0.8),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                )
                                .scale(
                                  begin: const Offset(1, 1),
                                  end: const Offset(1.02, 1.02),
                                  duration: 1500.ms,
                                ),
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
