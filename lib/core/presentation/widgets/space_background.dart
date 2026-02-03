import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SpaceBackground extends StatelessWidget {
  const SpaceBackground({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Deep Space Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.2), // Slightly above center, behind logo
              radius: 1.2,
              colors: [
                Color(0xFF1B2245), // Lighter midnight blue (glow)
                Color(0xFF0F1123), // Darker blue
                Color(0xFF050508), // Almost black
              ],
              stops: [0.0, 0.4, 1.0],
            ),
          ),
        ),

        // 2. Stars
        ...List.generate(50, (index) => _buildStar(context)),

        // 3. Child content (optional overlay)
        if (child != null) child!,
      ],
    );
  }

  Widget _buildStar(BuildContext context) {
    final random = Random();
    final left = random.nextDouble() * MediaQuery.of(context).size.width;
    final top = random.nextDouble() * MediaQuery.of(context).size.height;
    final size = random.nextDouble() * 3 + 1; // 1 to 4 pixels
    final delay = Duration(milliseconds: random.nextInt(2000));
    final duration = Duration(milliseconds: 1000 + random.nextInt(2000));

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha:random.nextDouble() * 0.5 + 0.3),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha:0.5),
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
      )
      .animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      )
      .scale(
        begin: const Offset(0.5, 0.5),
        end: const Offset(1.2, 1.2),
        duration: duration,
        delay: delay,
        curve: Curves.easeInOut,
      )
      .fade(
        begin: 0.3,
        end: 1.0,
        duration: duration,
        delay: delay,
        curve: Curves.easeInOut,
      ),
    );
  }
}
