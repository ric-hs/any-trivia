import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ParticleBurst extends StatelessWidget {
  final Color color;
  final int particleCount;
  
  const ParticleBurst({
    super.key, 
    required this.color,
    this.particleCount = 12,
  });

  @override
  Widget build(BuildContext context) {
    // Generate random angles and distances for unique burst feel
    final random = Random();
    
    return Stack(
      alignment: Alignment.center,
      children: List.generate(particleCount, (i) {
        // Distribute angles around circle
        final angle = (i * 360 / particleCount) + random.nextInt(20); 
        final radian = angle * pi / 180;
        
        // Randomize distance slightly
        final distance = 60.0 + random.nextInt(40);
        
        // Calculate move target
        final dx = cos(radian) * distance;
        final dy = sin(radian) * distance;
        
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        )
        .animate()
        .custom(
          duration: 600.ms,
          curve: Curves.easeOutQuad,
          builder: (context, value, child) {
            // value goes 0 -> 1
            return Transform.translate(
              offset: Offset(dx * value, dy * value),
              child: Opacity(
                opacity: 1 - value, // Fade out as it moves
                child: child,
              ),
            );
          },
        );
      }),
    );
  }
}
