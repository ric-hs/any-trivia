import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:endless_trivia/core/theme/app_theme.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:endless_trivia/core/presentation/widgets/glass_container.dart';
import 'package:endless_trivia/core/presentation/widgets/primary_button.dart';
import 'dart:ui' show ImageFilter;

class HowToPlayDialog extends StatelessWidget {
  const HowToPlayDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return DefaultTextStyle(
      style: const TextStyle(decoration: TextDecoration.none),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
            child: Hero(
              tag: 'how_to_play_dialog',
              child: GlassContainer(
                padding: const EdgeInsets.all(24.0),
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFF100F1F).withValues(alpha: 0.85),
                border: Border.all(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.menu_book_rounded,
                              color: Color(0xFF00E5FF),
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.howToPlay.toUpperCase(),
                              style: AppTheme.gameFont.copyWith(
                                fontSize: 24,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: Colors.white70),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Steps
                    _buildStep(
                      icon: Icons.lightbulb_outline_rounded,
                      color: const Color(0xFFFFD600), // Neon Yellow
                      title: l10n.howToPlayStep1Title,
                      description: l10n.howToPlayStep1Desc,
                      delay: 100,
                    ),
                    const SizedBox(height: 20),
                    
                    _buildStep(
                      icon: Icons.keyboard_alt_outlined,
                      color: const Color(0xFFFF2B5E), // Neon Pink
                      title: l10n.howToPlayStep2Title,
                      description: l10n.howToPlayStep2Desc,
                      delay: 200,
                    ),
                    const SizedBox(height: 20),
                    
                    _buildStep(
                      icon: Icons.smart_toy_outlined,
                      color: const Color(0xFF00C853), // Neon Green
                      title: l10n.howToPlayStep3Title,
                      description: l10n.howToPlayStep3Desc,
                      delay: 300,
                    ),

                    const SizedBox(height: 32),

                    // Got it button
                    PrimaryButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        l10n.gotIt.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: AppTheme.gameFont.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required int delay,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: delay.ms).slideX(begin: 0.1, end: 0);
  }
}

/// Helper function to show the dialog with a customized blur effect
void showHowToPlayDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'How to play dialog',
    barrierColor: Colors.black.withValues(alpha: 0.6), // Slightly darker background
    pageBuilder: (context, animation, secondaryAnimation) {
      return const HowToPlayDialog();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      // Create a smooth scale and fade transition
      final scaleTween = Tween<double>(begin: 0.9, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOutCubic));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOut));

      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: animation.value * 8, // Animate blur
          sigmaY: animation.value * 8, 
        ),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: ScaleTransition(
            scale: animation.drive(scaleTween),
            child: child,
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
