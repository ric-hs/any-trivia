import 'package:flutter/material.dart';

class SelectedCategoryChip extends StatelessWidget {
  final String category;
  final bool isFavorite;
  final Function(String) removeCategory;
  final Function(String, bool) toggleFavorite;
  final Color color;
  const SelectedCategoryChip({
    super.key,
    required this.category,
    required this.isFavorite,
    required this.removeCategory,
    required this.toggleFavorite,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InputChip(
      backgroundColor: color.withValues(alpha: 0.2),
      side: BorderSide(color: color),
      label: Text(category, style: const TextStyle(color: Colors.white)),
      onDeleted: () => removeCategory(category),
      deleteIcon: const Icon(Icons.close, size: 18, color: Colors.white70),
      onPressed: () {
        toggleFavorite(category, isFavorite);
      },
      avatar: Icon(
        isFavorite ? Icons.star : Icons.star_border,
        color: isFavorite ? Colors.amber : Colors.grey,
        size: 18,
      ),
    );
  }
}
