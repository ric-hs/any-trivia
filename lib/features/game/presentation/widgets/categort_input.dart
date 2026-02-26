import 'package:endless_trivia/core/presentation/widgets/glass_container.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CategoryInput extends StatelessWidget {
  final TextEditingController categoryController;
  final VoidCallback addCategory;
  const CategoryInput({
    super.key,
    required this.addCategory,
    required this.categoryController,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(16),
      color: const Color(0xFF252538).withValues(alpha: 0.5),
      border: Border.all(color: Colors.white10),
      child: TextField(
        controller: categoryController,
        maxLength: 64,
        onSubmitted: (_) => addCategory(),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          counterText: "",
          hintText: AppLocalizations.of(context)!.enterTopic,
          filled: false,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Color(0xFF00E5FF)),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: addCategory,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
