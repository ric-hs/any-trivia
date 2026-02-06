import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:endless_trivia/core/theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: AppTheme.primaryShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: child,
          ),
        ),
      ),
    )
    .animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    )
    .scale(
      begin: const Offset(1.0, 1.0),
      end: const Offset(1.05, 1.05),
      duration: 1500.ms,
      curve: Curves.easeInOut,
    );
  }
}
