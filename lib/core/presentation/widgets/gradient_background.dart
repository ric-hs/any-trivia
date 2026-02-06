import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Base Gradient (Deep Cyberpunk Space)
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1B0030), // Deepest Purple
                Color(0xFF0D0D15), // Darkest Grey/Black
                Color(0xFF001820), // Deepest Cyan
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        // 2. Purple Glow (Top Left)
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.8, -0.8),
              radius: 1.2,
              colors: [
                const Color(0xFFD500F9).withOpacity(0.15),
                Colors.transparent,
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
        // 3. Cyan Glow (Bottom Right)
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.8, 0.8),
              radius: 1.2,
              colors: [
                const Color(0xFF00E5FF).withOpacity(0.15),
                Colors.transparent,
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
        // 4. Content
        child,
      ],
    );
  }
}
