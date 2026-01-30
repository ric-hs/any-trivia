import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CategorySuggestionCarousel extends StatefulWidget {
  final List<String> suggestions;
  final Function(String) onCategorySelected;
  final double speed;

  const CategorySuggestionCarousel({
    super.key,
    required this.suggestions,
    required this.onCategorySelected,
    this.speed = 40.0,
  });

  @override
  State<CategorySuggestionCarousel> createState() => _CategorySuggestionCarouselState();
}

class _CategorySuggestionCarouselState extends State<CategorySuggestionCarousel> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late Ticker _ticker;
  bool _userInteracting = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _ticker = createTicker(_onTick);
    
    // Start after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _ticker.start();
      }
    });
  }

  void _onTick(Duration elapsed) {
    if (!_scrollController.hasClients || _userInteracting) return;

    final double maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    // Calculate displacement since last tick would be better, 
    // but for 60fps marquee, a small constant works well too.
    // However, to be precise:
    double offset = _scrollController.offset + (widget.speed / 60.0);
    
    if (offset >= maxScroll) {
      offset = 0;
    }
    
    _scrollController.jumpTo(offset);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.suggestions.isEmpty) return const SizedBox.shrink();

    // Multiply suggestions for a better loop effect
    final extendedSuggestions = [
      ...widget.suggestions,
      ...widget.suggestions,
      ...widget.suggestions,
    ];

    return Listener(
      onPointerDown: (_) => setState(() => _userInteracting = true),
      onPointerUp: (_) => setState(() => _userInteracting = false),
      onPointerCancel: (_) => setState(() => _userInteracting = false),
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          // Disable default drag physics if it conflicts, 
          // but usually it's fine to let the user swipe.
          itemCount: extendedSuggestions.length,
          itemBuilder: (context, index) {
            final category = extendedSuggestions[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ActionChip(
                label: Text(category),
                onPressed: () => widget.onCategorySelected(category),
                backgroundColor: const Color(0xFF2C2C2C),
                labelStyle: const TextStyle(color: Colors.white, fontSize: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.deepPurpleAccent.withValues(alpha: 0.3),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
