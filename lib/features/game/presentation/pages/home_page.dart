import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:endless_trivia/features/auth/presentation/bloc/auth_event.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_event.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_state.dart';
import 'package:endless_trivia/features/game/presentation/pages/game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _categoryController = TextEditingController();

  void _startGame(BuildContext context, int currentTokens, String userId) {
    final category = _categoryController.text.trim();
    if (category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseEnterCategory)),
      );
      return;
    }
    
    if (currentTokens <= 0) {
       showDialog(context: context, builder: (_) => AlertDialog(
         title: Text(AppLocalizations.of(context)!.outOfTokens),
         content: Text(AppLocalizations.of(context)!.zeroTokensMessage),
       ));
       return;
    }

    // Consume Token
    context.read<ProfileBloc>().add(ConsumeToken(userId: userId, currentTokens: currentTokens));

    // Get current language
    final languageCode = Localizations.localeOf(context).languageCode;

    // Navigate to Game
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GamePage(category: category, language: languageCode)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle.toUpperCase()),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Token Display
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6200EA).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF6200EA)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.tokens, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('${profile.tokens}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFBB86FC))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Category Input
                  Text(AppLocalizations.of(context)!.chooseAdventure, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.enterTopic,
                      filled: true,
                      fillColor: const Color(0xFF2C2C2C),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Start Game Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _startGame(context, profile.tokens, profile.userId),
                      child: Text(AppLocalizations.of(context)!.playRound),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  // Favorites (Placeholder for now)
                  Text(AppLocalizations.of(context)!.favorites, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 8),
                  if (profile.favoriteCategories.isEmpty)
                    Text(AppLocalizations.of(context)!.noFavorites, style: const TextStyle(color: Colors.grey))
                  else
                    Wrap(
                      spacing: 8,
                      children: profile.favoriteCategories.map((cat) => Chip(label: Text(cat))).toList(),
                    ),
                ],
              ),
            );
          } else if (state is ProfileError) {
             return Center(child: Text(AppLocalizations.of(context)!.errorProfile(state.message)));
          }
          return const Center(child: Text('Loading Profile...'));
        },
      ),
    );
  }
}
