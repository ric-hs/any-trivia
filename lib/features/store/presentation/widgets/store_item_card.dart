import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:endless_trivia/core/presentation/widgets/glass_container.dart';

class StoreItemCard extends StatelessWidget {
  final Package package;
  final VoidCallback onBuy;
  final int index;

  const StoreItemCard({
    super.key,
    required this.package,
    required this.onBuy,
    required this.index,
  });

  String _getImagePath(String identifier) {
    switch (identifier) {
      case 'anytrivia_anytokens_20_v1':
        return 'assets/store_icons/xs_pack.png';
      case 'anytrivia_anytokens_50_v1':
        return 'assets/store_icons/s_pack.png';
      case 'anytrivia_anytokens_100_v1':
        return 'assets/store_icons/m_pack.png';
      case 'anytrivia_anytokens_200_v1':
        return 'assets/store_icons/l_pack.png';
      default:
        return 'assets/store_icons/fallback_icon.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset(
              _getImagePath(package.storeProduct.identifier),
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.storeProduct.title.replaceAll(
                      RegExp('\\(.*?\\)'),
                      '',
                    ),
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    package.storeProduct.description,
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                package.storeProduct.priceString,
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1, end: 0),
    );
  }
}
