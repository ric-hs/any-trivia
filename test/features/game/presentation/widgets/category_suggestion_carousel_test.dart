import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:endless_trivia/features/game/presentation/widgets/category_suggestion_carousel.dart';

void main() {
  testWidgets('CategorySuggestionCarousel renders correctly and handles taps', (WidgetTester tester) async {
    final suggestions = ['Category 1', 'Category 2', 'Category 3'];
    String? selectedCategory;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategorySuggestionCarousel(
            suggestions: suggestions,
            onCategorySelected: (category) {
              selectedCategory = category;
            },
          ),
        ),
      ),
    );

    // Verify chips are rendered
    expect(find.text('Category 1'), findsWidgets);
    expect(find.text('Category 2'), findsWidgets);
    expect(find.text('Category 3'), findsWidgets);

    // Tap on a chip
    await tester.tap(find.text('Category 1').first);
    await tester.pump();

    // Verify callback was called
    expect(selectedCategory, 'Category 1');
  });
}
