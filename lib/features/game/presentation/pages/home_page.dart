import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:endless_trivia/core/theme/app_theme.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_event.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_state.dart';
import 'package:endless_trivia/features/game/presentation/pages/game_page.dart';
import 'package:endless_trivia/features/settings/presentation/pages/settings_page.dart';
import 'package:endless_trivia/features/game/presentation/widgets/category_suggestion_carousel.dart';
import 'package:endless_trivia/features/game/presentation/constants/category_suggestions.dart';
import 'package:endless_trivia/features/game/presentation/utils/game_cost_calculator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _categoryController = TextEditingController();
  final List<String> _selectedCategories = [];
  int _rounds = 5;

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
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Check if user has enough tokens for the selected rounds
    final requiredTokens = GameCostCalculator.calculateCost(_rounds);
    if (currentTokens < requiredTokens) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Theme.of(context).cardTheme.color,
          title: Text(
            AppLocalizations.of(context)!.outOfTokens,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            AppLocalizations.of(
              context,
            )!.notEnoughTokens(_rounds, currentTokens, requiredTokens),
            style: const TextStyle(color: Colors.white70),
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
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF100F1F), // Dark BG
              Color(0xFF2A0045), // Deep Purple Accent
            ],
            stops: [0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded) {
                final profile = state.profile;
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // HUD Header
                        _buildHUD(context, profile),

                        // Main Content
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 16),
                                // Hero Title or Welcome
                                Text(
                                      "PREPARE FOR BATTLE",
                                      style: AppTheme.gameFont.copyWith(
                                        fontSize: 32,
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        letterSpacing: 2,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                    .animate()
                                    .fadeIn(duration: 600.ms)
                                    .slideY(begin: -0.2, end: 0),

                                const SizedBox(height: 24),

                                // Category Input
                                TextField(
                                  controller: _categoryController,
                                  onSubmitted: (_) => _addCategory(),
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(
                                      context,
                                    )!.enterTopic,
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Color(0xFF00E5FF),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.add_circle,
                                        color: Color(0xFFD300F9),
                                      ),
                                      onPressed: _addCategory,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                ).animate().fadeIn(delay: 200.ms).slideX(),
                                const SizedBox(height: 16),

                                // Selected Categories (Chips)
                                if (_selectedCategories.isNotEmpty)
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: _selectedCategories.map((
                                      category,
                                    ) {
                                      final isFavorite = profile
                                          .favoriteCategories
                                          .contains(category);
                                      return InputChip(
                                        backgroundColor: const Color(
                                          0xFF252538,
                                        ),
                                        side: BorderSide(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        label: Text(
                                          category,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onDeleted: () =>
                                            _removeCategory(category),
                                        deleteIcon: const Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.white70,
                                        ),
                                        onPressed: () {
                                          final newFavorites =
                                              List<String>.from(
                                                profile.favoriteCategories,
                                              );
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
                                          isFavorite
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: isFavorite
                                              ? Colors.amber
                                              : Colors.grey,
                                          size: 18,
                                        ),
                                      ).animate().scale();
                                    }).toList(),
                                  ),
                                const SizedBox(height: 24),

                                // Recommendations Section
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.suggestionsTitle.toUpperCase(),
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    color: const Color(0xFF00E5FF),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ).animate().fadeIn(delay: 300.ms),
                                const SizedBox(height: 8),

                                CategorySuggestionCarousel(
                                  suggestions: _generalSuggestions,
                                  onCategorySelected: _addCategoryWithName,
                                  speed: 30.0,
                                ).animate().fadeIn(delay: 400.ms),
                                CategorySuggestionCarousel(
                                  suggestions: _specializedSuggestions,
                                  onCategorySelected: _addCategoryWithName,
                                  speed: 45.0,
                                ).animate().fadeIn(delay: 500.ms),
                                CategorySuggestionCarousel(
                                  suggestions: _quirkySuggestions,
                                  onCategorySelected: _addCategoryWithName,
                                  speed: 35.0,
                                ).animate().fadeIn(delay: 600.ms),
                                const SizedBox(height: 24),

                                // Favorites Section
                                if (profile.favoriteCategories.isNotEmpty) ...[
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.favorites.toUpperCase(),
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      color: const Color(0xFFFF2B5E),
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ).animate().fadeIn(delay: 700.ms),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 50,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount:
                                          profile.favoriteCategories.length,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(width: 8),
                                      itemBuilder: (context, index) {
                                        final cat =
                                            profile.favoriteCategories[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF252538),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: Colors.white12,
                                            ),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              onTap: () {
                                                if (!_selectedCategories
                                                    .contains(cat)) {
                                                  setState(() {
                                                    _selectedCategories.add(
                                                      cat,
                                                    );
                                                  });
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 8.0,
                                                    ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        final newFavorites =
                                                            List<String>.from(
                                                              profile
                                                                  .favoriteCategories,
                                                            )..remove(cat);
                                                        context
                                                            .read<ProfileBloc>()
                                                            .add(
                                                              UpdateFavoriteCategories(
                                                                userId: profile
                                                                    .userId,
                                                                categories:
                                                                    newFavorites,
                                                              ),
                                                            );
                                                      },
                                                      child: const Icon(
                                                        Icons.star,
                                                        size: 18,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      cat,
                                                      style: GoogleFonts.outfit(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ).animate().fadeIn(delay: 800.ms),
                                ],

                                const SizedBox(height: 24),

                                // Round Selector
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.numberOfRounds.toUpperCase(),
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                      children: [5, 10, 15, 20].map((rounds) {
                                        final isSelected = _rounds == rounds;
                                        return Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _rounds = rounds;
                                                });
                                              },
                                              child: AnimatedContainer(
                                                duration: 200.ms,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? const Color(0xFF6200EA)
                                                      : const Color(0xFF252538),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: isSelected
                                                      ? Border.all(
                                                          color: const Color(
                                                            0xFFD300F9,
                                                          ),
                                                          width: 2,
                                                        )
                                                      : Border.all(
                                                          color: Colors.white12,
                                                        ),
                                                  boxShadow: isSelected
                                                      ? [
                                                          BoxShadow(
                                                            color:
                                                                const Color(
                                                                  0xFFD300F9,
                                                                ).withValues(
                                                                  alpha: 0.4,
                                                                ),
                                                            blurRadius: 8,
                                                            spreadRadius: 1,
                                                          ),
                                                        ]
                                                      : [],
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '$rounds',
                                                  style: GoogleFonts.outfit(
                                                    color: Colors.white,
                                                    fontWeight: isSelected
                                                        ? FontWeight.w900
                                                        : FontWeight.normal,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    )
                                    .animate()
                                    .fadeIn(delay: 900.ms)
                                    .slideY(begin: 0.1, end: 0),

                                const SizedBox(
                                  height: 128,
                                ), // Spacing for floating button
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Floating Start Game Button
                    Positioned(
                      bottom: 24,
                      left: 24,
                      right: 24,
                      child:
                          ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6200EA),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
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
                                onPressed: () => _startGame(
                                  context,
                                  profile.tokens,
                                  profile.userId,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.startGame.toUpperCase(),
                                        style: AppTheme.gameFont.copyWith(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.costDisplay(
                                          GameCostCalculator.calculateCost(
                                            _rounds,
                                          ),
                                        ),
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF00E5FF),
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
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
              } else if (state is ProfileError) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.errorProfile(state.message),
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
              return const Center(
                child: Text(
                  'Loading Profile...',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHUD(BuildContext context, dynamic profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tokens Display (HUD Style)
          Container(
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
                const Icon(Icons.bolt, color: Color(0xFF00E5FF), size: 20),
                const SizedBox(width: 8),
                Text(
                  '${profile.tokens}',
                  style: AppTheme.gameFont.copyWith(
                    fontSize: 20,
                    color: const Color(0xFF00E5FF),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideX(begin: -0.5, end: 0),

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
    );
  }
}
