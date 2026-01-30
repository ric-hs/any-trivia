import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_event.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_state.dart';
import 'package:endless_trivia/features/game/presentation/pages/game_page.dart';
import 'package:endless_trivia/features/settings/presentation/pages/settings_page.dart';
import 'package:endless_trivia/features/game/presentation/widgets/category_suggestion_carousel.dart';
import 'package:endless_trivia/features/game/presentation/constants/category_suggestions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _categoryController = TextEditingController();
  final List<String> _selectedCategories = [];
  int _rounds = 1;

  void _addCategory() {
    final category = _categoryController.text.trim();
    if (category.isNotEmpty) {
      _addCategoryWithName(category);
      _categoryController.clear();
    }
  }

  void _addCategoryWithName(String category) {
    if (category.isNotEmpty && !_selectedCategories.contains(category)) {
      setState(() {
        _selectedCategories.add(category);
      });
    }
  }

  void _removeCategory(String category) {
    setState(() {
      _selectedCategories.remove(category);
    });
  }

  void _startGame(BuildContext context, int currentTokens, String userId) {
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseEnterCategory),
        ),
      );
      return;
    }

    // Check if user has enough tokens for the selected rounds
    if (currentTokens < _rounds) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.outOfTokens),
          content: Text(
            AppLocalizations.of(
              context,
            )!.notEnoughTokens(_rounds, currentTokens),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Token consumption is now handled by the Cloud Function consumeTokens,
    // which is called from the GameBloc when the game starts.
    // If there are not enough tokens, the Cloud Function will return an error status,
    // and the GameBloc will emit a GameError.

    // Get current language
    final languageCode = Localizations.localeOf(context).languageCode;

    // Navigate to Game
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GamePage(
          categories: List.from(_selectedCategories),
          language: languageCode,
          rounds: _rounds,
          userId: userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle.toUpperCase()),
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SettingsPage(userId: state.profile.userId),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
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
                        Text(
                          AppLocalizations.of(context)!.tokens,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${profile.tokens}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBB86FC),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Category Input
                  Text(
                    AppLocalizations.of(context)!.chooseAdventure,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _categoryController,
                    onSubmitted: (_) => _addCategory(),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.enterTopic,
                      filled: true,
                      fillColor: const Color(0xFF2C2C2C),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _addCategory,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Category Suggestions - General
                  _buildSectionTitle(context, AppLocalizations.of(context)!.suggestionsTitle),
                  CategorySuggestionCarousel(
                    suggestions: CategorySuggestions.getSuggestions(
                      Localizations.localeOf(context).languageCode,
                      type: SuggestionType.general,
                    ),
                    onCategorySelected: _addCategoryWithName,
                  ),

                  // Category Suggestions - Specialized
                  CategorySuggestionCarousel(
                    suggestions: CategorySuggestions.getSuggestions(
                      Localizations.localeOf(context).languageCode,
                      type: SuggestionType.specialized,
                    ),
                    onCategorySelected: _addCategoryWithName,
                  ),

                  // Category Suggestions - Quirky
                  CategorySuggestionCarousel(
                    suggestions: CategorySuggestions.getSuggestions(
                      Localizations.localeOf(context).languageCode,
                      type: SuggestionType.quirky,
                    ),
                    onCategorySelected: _addCategoryWithName,
                  ),
                  
                  if (_selectedCategories.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _selectedCategories.map((category) {
                        final isFavorite = profile.favoriteCategories.contains(category);
                        return InputChip(
                          label: Text(category),
                          onDeleted: () => _removeCategory(category),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                              final newFavorites = List<String>.from(profile.favoriteCategories);
                              if (isFavorite) {
                                newFavorites.remove(category);
                              } else {
                                newFavorites.add(category);
                              }
                              context.read<ProfileBloc>().add(
                                UpdateFavoriteCategories(
                                  userId: profile.userId,
                                  categories: newFavorites,
                                ),
                              );
                          },
                          avatar: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: isFavorite ? Colors.amber : Colors.grey,
                            size: 18,
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 24),

                  // Rounds Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.numberOfRounds,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.maxRounds,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.white),
                          onPressed: _rounds > 1
                              ? () => setState(() => _rounds--)
                              : null,
                        ),
                        Text(
                          '$_rounds',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: _rounds < 30
                              ? () => setState(() => _rounds++)
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Start Game Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () =>
                          _startGame(context, profile.tokens, profile.userId),
                      child: Text(AppLocalizations.of(context)!.playRound(_rounds)),
                    ),
                  ),

                  const SizedBox(height: 32),
                  // Favorites (Placeholder for now)
                  Text(
                    AppLocalizations.of(context)!.favorites,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  if (profile.favoriteCategories.isEmpty)
                    Text(
                      AppLocalizations.of(context)!.noFavorites,
                      style: const TextStyle(color: Colors.grey),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      children: profile.favoriteCategories
                          .map((cat) => InputChip(
                                label: Text(cat),
                                avatar: const Icon(Icons.star, size: 16, color: Colors.amber),
                                onPressed: () {
                                  if (!_selectedCategories.contains(cat)) {
                                    setState(() {
                                      _selectedCategories.add(cat);
                                    });
                                  }
                                },
                                onDeleted: () {
                                  final newFavorites = List<String>.from(profile.favoriteCategories)..remove(cat);
                                  context.read<ProfileBloc>().add(
                                    UpdateFavoriteCategories(
                                      userId: profile.userId,
                                      categories: newFavorites,
                                    ),
                                  );
                                },
                                deleteIcon: const Icon(Icons.delete_outline, size: 16),
                                deleteButtonTooltipMessage: AppLocalizations.of(context)!.removeFromFavorites,
                                tooltip: AppLocalizations.of(context)!.addToGame,
                              ))
                          .toList(),
                    ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.errorProfile(state.message),
              ),
            );
          }
          return const Center(child: Text('Loading Profile...'));
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
