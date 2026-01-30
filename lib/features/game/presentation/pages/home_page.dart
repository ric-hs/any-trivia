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

  // Cached suggestions to prevent reshuffling on state changes
  List<String> _generalSuggestions = [];
  List<String> _specializedSuggestions = [];
  List<String> _quirkySuggestions = [];
  String? _currentLanguageCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (_currentLanguageCode != languageCode) {
      _currentLanguageCode = languageCode;
      _generalSuggestions = CategorySuggestions.getSuggestions(
        languageCode,
        type: SuggestionType.general,
      );
      _specializedSuggestions = CategorySuggestions.getSuggestions(
        languageCode,
        type: SuggestionType.specialized,
      );
      _quirkySuggestions = CategorySuggestions.getSuggestions(
        languageCode,
        type: SuggestionType.quirky,
      );
    }
  }

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
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final profile = state.profile;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header: Tokens (Left) and Settings (Right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Tokens Display
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0x336200EA),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF6200EA)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.monetization_on, color: Color(0xFFBB86FC), size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '${profile.tokens}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFBB86FC),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Settings Button
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SettingsPage(userId: state.profile.userId),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Main Content Area (Flexible to fit screen)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Category Input
                            TextField(
                              controller: _categoryController,
                              onSubmitted: (_) => _addCategory(),
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.enterTopic, // Updated hint
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
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Selected Categories
                            if (_selectedCategories.isNotEmpty) ...[
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 2.0,
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
                              const SizedBox(height: 16),
                            ],

                            // Recommendations
                            Text(
                              AppLocalizations.of(context)!.suggestionsTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Stack or List Carousels tightly
                            CategorySuggestionCarousel(
                              suggestions: _generalSuggestions,
                              onCategorySelected: _addCategoryWithName,
                              speed: 30.0,
                            ),
                            CategorySuggestionCarousel(
                              suggestions: _specializedSuggestions,
                              onCategorySelected: _addCategoryWithName,
                              speed: 45.0,
                            ),
                            CategorySuggestionCarousel(
                              suggestions: _quirkySuggestions,
                              onCategorySelected: _addCategoryWithName,
                              speed: 35.0,
                            ),
                            const SizedBox(height: 16),

                            // Favorites (Horizontal Scroll)
                            if (profile.favoriteCategories.isNotEmpty) ...[
                              Text(
                                AppLocalizations.of(context)!.favorites,
                                style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 40,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: profile.favoriteCategories.length,
                                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final cat = profile.favoriteCategories[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(20),
                                          onTap: () {
                                            if (!_selectedCategories.contains(cat)) {
                                              setState(() {
                                                _selectedCategories.add(cat);
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    final newFavorites = List<String>.from(profile.favoriteCategories)..remove(cat);
                                                    context.read<ProfileBloc>().add(
                                                      UpdateFavoriteCategories(
                                                        userId: profile.userId,
                                                        categories: newFavorites,
                                                      ),
                                                    );
                                                  },
                                                  child: const Icon(Icons.star, size: 18, color: Colors.amber),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  cat,
                                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                                ),
                                                const SizedBox(width: 4),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ] else ...[
                               Text(
                                AppLocalizations.of(context)!.favorites,
                                style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)!.noFavorites,
                                style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                              ),
                            ],
                             const SizedBox(height: 16),

                            // Round Counter
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.numberOfRounds,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2C2C2C),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        icon: const Icon(Icons.remove, size: 20, color: Colors.white),
                                        onPressed: _rounds > 1
                                            ? () => setState(() => _rounds--)
                                            : null,
                                      ),
                                      Text(
                                        '$_rounds',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        icon: const Icon(Icons.add, size: 20, color: Colors.white),
                                        onPressed: _rounds < 30
                                            ? () => setState(() => _rounds++)
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Start Game Button (Fixed at bottom)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6200EA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () =>
                            _startGame(context, profile.tokens, profile.userId),
                        child: Text(
                          AppLocalizations.of(context)!.playRound(_rounds),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
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
      ),
    );
  }
}
