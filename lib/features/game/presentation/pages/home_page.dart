import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:endless_trivia/core/theme/app_theme.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';

import 'package:endless_trivia/core/presentation/widgets/gradient_background.dart';
import 'package:endless_trivia/core/presentation/widgets/primary_button.dart';
import 'package:endless_trivia/core/presentation/widgets/glass_container.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_event.dart';
import 'package:endless_trivia/features/profile/presentation/bloc/profile_state.dart';
import 'package:endless_trivia/features/game/presentation/pages/game_page.dart';
import 'package:endless_trivia/features/settings/presentation/pages/settings_page.dart';
import 'package:endless_trivia/features/game/presentation/widgets/category_suggestion_carousel.dart';
import 'package:endless_trivia/features/game/presentation/constants/category_suggestions.dart';
import 'package:endless_trivia/features/game/presentation/utils/game_cost_calculator.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _categoryController = TextEditingController();
  final _scrollController = ScrollController();
  final _favoriteController = ScrollController();
  final List<String> _selectedCategories = [];
  int _rounds = 10;

  // Cached suggestions to prevent reshuffling on state changes
  List<String> _generalSuggestions = [];
  List<String> _specializedSuggestions = [];
  List<String> _quirkySuggestions = [];
  String? _currentLanguageCode;

  final Map<String, Color> _categoryColors = {};

  // Cyberpunk Palette
  final List<Color> _palette = const [
    Color(0xFF00E5FF), // Cyan
    Color(0xFFFF2B5E), // Neon Red/Pink
    Color(0xFF00C853), // Neon Green
    Color(0xFFAA00FF), // Neon Purple
    Color(0xFFFFD600), // Neon Yellow
    Color(0xFFFF9100), // Neon Orange
    Color(0xFFD500F9), // Neon Magenta
  ];

  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _categoryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
        _categoryColors[category] = _palette[Random().nextInt(_palette.length)];
      });
      // Scroll to the end after the frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _removeCategory(String category) {
    setState(() {
      _selectedCategories.remove(category);
      _categoryColors.remove(category);
    });
  }

  void _startGame(BuildContext context, int currentTokens, String userId) {
    if (_selectedCategories.isEmpty) {
      _shakeController.forward(from: 0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xFF00E5FF), width: 3),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFF00E5FF),
                  size: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.pleaseEnterCategory,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: const Color(0xFF2A0045),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFD300F9), width: 1),
          ),
          margin: const EdgeInsets.all(16),
          elevation: 10,
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
          categoryColors: Map.from(_categoryColors),
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
      body: GradientBackground(
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
                                vertical: 8.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // const SizedBox(height: 16),
                                  // // Hero Title or Welcome
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //     horizontal: 24.0,
                                  //   ),
                                  //   child: Text(
                                  //     "PREPARE FOR BATTLE",
                                  //     style: AppTheme.gameFont.copyWith(
                                  //       fontSize: 32,
                                  //       color: Colors.white.withValues(
                                  //         alpha: 0.9,
                                  //       ),
                                  //       letterSpacing: 2,
                                  //     ),
                                  //     textAlign: TextAlign.center,
                                  //   )
                                  //   .animate()
                                  //   .fadeIn(duration: 600.ms)
                                  //   .slideY(begin: -0.2, end: 0),
                                  // ),

                                  // const SizedBox(height: 24),

                                  // Categories Subtitle
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                    ),
                                    child: Text(
                                      '${AppLocalizations.of(context)!.categories.toUpperCase()} (${_selectedCategories.length})',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                        letterSpacing: 1.2,
                                      ),
                                    ).animate().fadeIn(delay: 100.ms),
                                  ),
                                  const SizedBox(height: 12),

                                  // Category Input
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                    ),
                                    child:
                                        GlassContainer(
                                          borderRadius: BorderRadius.circular(16),
                                          color: const Color(0xFF252538).withValues(alpha: 0.5),
                                          border: Border.all(color: Colors.white10),
                                          child: TextField(
                                                controller: _categoryController,
                                                maxLength: 64,
                                                onSubmitted: (_) =>
                                                    _addCategory(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                  hintText: AppLocalizations.of(
                                                    context,
                                                  )!.enterTopic,
                                                  filled: false,
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  enabledBorder: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder.none,
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: Color(0xFF00E5FF),
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      Icons.add_circle,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                    ),
                                                    onPressed: _addCategory,
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 14,
                                                      ),
                                                ),
                                              ),
                                        )
                                            .animate(
                                              autoPlay: false,
                                              controller: _shakeController,
                                            )
                                            .shake(
                                              duration: 500.ms,
                                              hz: 4,
                                              offset: const Offset(10, 0),
                                            )
                                            .animate()
                                            .fadeIn(delay: 200.ms)
                                            .slideX(),
                                  ),
                                  const SizedBox(height: 16),

                                  // Selected Categories (Chips) or Empty State
                                  _selectedCategories.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24.0,
                                          ),
                                          child: Center(
                                            child:
                                                Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.emptyCategoriesMessage,
                                                  style: GoogleFonts.outfit(
                                                    color: Colors.white70,
                                                    fontSize: 16,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ).animate().fadeIn(
                                                  duration: 500.ms,
                                                ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 50,
                                          child: ListView.separated(
                                            controller: _scrollController,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24.0,
                                            ),
                                            itemCount:
                                                _selectedCategories.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(width: 8),
                                            itemBuilder: (context, index) {
                                              final category =
                                                  _selectedCategories[index];
                                              final isFavorite = profile
                                                  .favoriteCategories
                                                  .contains(category);
                                              final color =
                                                  _categoryColors[category] ??
                                                  const Color(0xFF252538);

                                              return InputChip(
                                                backgroundColor: color
                                                    .withValues(alpha: 0.2),
                                                side: BorderSide(color: color),
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
                                                        profile
                                                            .favoriteCategories,
                                                      );
                                                  if (isFavorite) {
                                                    newFavorites.remove(
                                                      category,
                                                    );
                                                  } else {
                                                    newFavorites.add(category);
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback((
                                                          _,
                                                        ) {
                                                          if (_favoriteController
                                                              .hasClients) {
                                                            _favoriteController.animateTo(
                                                              _favoriteController
                                                                  .position
                                                                  .maxScrollExtent,
                                                              duration:
                                                                  const Duration(
                                                                    milliseconds:
                                                                        300,
                                                                  ),
                                                              curve: Curves
                                                                  .easeOut,
                                                            );
                                                          }
                                                        });
                                                  }
                                                  context
                                                      .read<ProfileBloc>()
                                                      .add(
                                                        UpdateFavoriteCategories(
                                                          userId:
                                                              profile.userId,
                                                          categories:
                                                              newFavorites,
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
                                            },
                                          ),
                                        ),
                                  const SizedBox(height: 24),

                                  // Recommendations Section
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                    ),
                                    child: Text(
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
                                  ),
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

                                  // Favorites Section
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                    ),
                                    child: Text(
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
                                  ),
                                  const SizedBox(height: 8),

                                  profile.favoriteCategories.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24.0,
                                            vertical: 8.0,
                                          ),
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.emptyFavoritesMessage,
                                            style: GoogleFonts.outfit(
                                              color: Colors.white30,
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ).animate().fadeIn(delay: 800.ms),
                                        )
                                      : SizedBox(
                                          height: 50,
                                          child: ListView.separated(
                                            controller: _favoriteController,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24.0,
                                            ),
                                            itemCount: profile
                                                .favoriteCategories
                                                .length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(width: 8),
                                            itemBuilder: (context, index) {
                                              final cat = profile
                                                  .favoriteCategories[index];
                                              return GlassContainer(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: const Color(
                                                  0xFF252538,
                                                ).withValues(alpha: 0.3),
                                                border: Border.all(
                                                  color: Colors.white12,
                                                ),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    onTap: () {
                                                      if (!_selectedCategories
                                                          .contains(cat)) {
                                                        _addCategoryWithName(
                                                          cat,
                                                        );
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
                                                                  List<
                                                                      String
                                                                    >.from(
                                                                      profile
                                                                          .favoriteCategories,
                                                                    )
                                                                    ..remove(
                                                                      cat,
                                                                    );
                                                              context.read<ProfileBloc>().add(
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
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            cat,
                                                            style:
                                                                GoogleFonts.outfit(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
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

                                  const SizedBox(height: 24),

                                  // Round Selector
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                    ),
                                    child: Text(
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
                                  ),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                    ),
                                    child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF252538).withValues(alpha: 0.3),
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(
                                              color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                                              width: 1,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          child: Row(
                                            children: [5, 10, 15, 20].map((rounds) {
                                              final isSelected = _rounds == rounds;
                                              return Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _rounds = rounds;
                                                    });
                                                  },
                                                  child: Container(
                                                    // duration: const Duration(milliseconds: 300),
                                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(24),
                                                      gradient: isSelected
                                                          ? AppTheme.secondaryGradient
                                                          : null,
                                                      boxShadow: isSelected
                                                          ? [
                                                              BoxShadow(
                                                                color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                                                                blurRadius: 16,
                                                                spreadRadius: 1,
                                                              ),
                                                              BoxShadow(
                                                                color: const Color(0xFFD500F9).withValues(alpha: 0.5),
                                                                blurRadius: 16,
                                                                spreadRadius: 1,
                                                              ),
                                                            ]
                                                          : [],
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '$rounds',
                                                        style: GoogleFonts.outfit(
                                                          color: Colors.white,
                                                          fontWeight: isSelected
                                                              ? FontWeight.w900
                                                              : FontWeight.normal,
                                                          fontSize: 18,
                                                          shadows: isSelected
                                                              ? [
                                                                  Shadow(
                                                                    color: Colors.black26,
                                                                    blurRadius: 2,
                                                                    offset: const Offset(0, 1),
                                                                  ),
                                                                ]
                                                              : [],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.1, end: 0),
                                  ),

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
                        child: PrimaryButton(
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.startGame.toUpperCase(),
                                      style: AppTheme.gameFont.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.costDisplay(
                                    GameCostCalculator.calculateCost(_rounds),
                                  ),
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
