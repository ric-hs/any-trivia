import 'package:flutter/material.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class GameResultsView extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final VoidCallback onBackToMenu;

  const GameResultsView({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.onBackToMenu,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = totalQuestions > 0 ? (score / totalQuestions) * 100 : 0.0;
    final scoreColor = _getScoreColor(percentage);

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.resultsTitle,
                style: GoogleFonts.rubikGlitch(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha:0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn().shimmer(duration: 1500.ms, color: Colors.white24),
              
              const SizedBox(height: 48),
              
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.black45, // Glassmorphic base
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: scoreColor.withValues(alpha:0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: scoreColor.withValues(alpha:0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                     Text(
                      AppLocalizations.of(context)!.scoreLabel.toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$score',
                          style: GoogleFonts.rubikGlitch(
                            fontSize: 72,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '/$totalQuestions',
                          style: GoogleFonts.rubikGlitch(
                            fontSize: 32,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.white10,
                        valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                        minHeight: 12,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.2, end: 0, duration: 600.ms),
              
              const SizedBox(height: 64),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  backgroundColor: const Color(0xFF6200EA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFFD300F9), width: 2),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFFD300F9).withValues(alpha:0.5),
                ),
                onPressed: onBackToMenu,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.backToMenu.toUpperCase(),
                      style: GoogleFonts.rubikGlitch(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.home_filled, size: 28),
                  ],
                ),
              )
              .animate(delay: 500.ms)
              .fadeIn()
              .scale()
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .boxShadow(
                begin: BoxShadow(color: const Color(0xFF6200EA).withValues(alpha:0.2), blurRadius: 4, spreadRadius: 0),
                end: BoxShadow(color: const Color(0xFF6200EA).withValues(alpha:0.6), blurRadius: 12, spreadRadius: 4),
                duration: 2.seconds,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return const Color(0xFF00C853); // Neon Green
    if (percentage >= 50) return const Color(0xFFFFAB00); // Neon Amber
    return const Color(0xFFFF2B5E); // Neon Red
  }
}
