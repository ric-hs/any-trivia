import 'package:endless_trivia/core/theme/app_theme.dart';
import 'package:endless_trivia/features/profile/domain/entities/user_profile.dart';
import 'package:endless_trivia/features/settings/presentation/pages/settings_page.dart';
import 'package:endless_trivia/features/store/presentation/pages/store_page.dart';
import 'package:endless_trivia/features/game/presentation/widgets/how_to_play_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Hud extends StatelessWidget {
  final UserProfile profile;
  const Hud({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const StorePage()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/a-token_icon_small.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${profile.tokens}',
                    style: AppTheme.gameFont.copyWith(
                      fontSize: 18,
                      color: const Color(0xFF00E5FF),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideX(begin: -0.5, end: 0),
          ),

          // Center Logo Title
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                'assets/logo/logo_title.png',
                height: 28,
                fit: BoxFit.contain,
              ).animate().fadeIn().slideY(begin: -0.5, end: 0),
            ),
          ),

          // Right Side Actions (Help & Settings)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Help Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: IconButton(
                  icon: const Icon(Icons.help_outline_rounded, color: Colors.white70),
                  onPressed: () => showHowToPlayDialog(context),
                ),
              ).animate().fadeIn().slideX(begin: 0.5, end: 0),
              
              const SizedBox(width: 8),

              // Settings Button (HUD Style)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white70),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SettingsPage(userId: profile.userId),
                      ),
                    );
                  },
                ),
              ).animate().fadeIn().slideX(begin: 0.5, end: 0),
            ],
          ),
        ],
      ),
    );
  }
}
