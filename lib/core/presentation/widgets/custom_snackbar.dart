import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    super.key,
    required String message,
    required BuildContext context,
    IconData? icon,
    Color? iconColor,
    Color backgroundColor = const Color(0xFF323232),
    super.duration = const Duration(seconds: 4),
  }) : super(
          content: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? Colors.white),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Colors.white24,
              width: 1,
            ),
          ),
        );

  factory CustomSnackBar.success({
    required String message,
    required BuildContext context,
  }) {
    return CustomSnackBar(
      message: message,
      context: context,
      icon: Icons.check_circle_outline,
      iconColor: Colors.greenAccent,
      backgroundColor: const Color(0xFF323232), // Keeping dark background for consistency
      duration: const Duration(seconds: 4),
    );
  }

  factory CustomSnackBar.error({
    required String message,
    required BuildContext context,
  }) {
    return CustomSnackBar(
      message: message,
      context: context,
      icon: Icons.error_outline,
      iconColor: const Color(0xFFFF5252),
      backgroundColor: const Color(0xFF323232),
      duration: const Duration(seconds: 8),
    );
  }
  
    factory CustomSnackBar.info({
    required String message,
    required BuildContext context,
  }) {
    return CustomSnackBar(
      message: message,
      context: context,
      icon: Icons.info_outline,
      iconColor: Colors.blueAccent,
      backgroundColor: const Color(0xFF323232),
      duration: const Duration(seconds: 4),
    );
  }

  factory CustomSnackBar.warning({
    required String message,
    required BuildContext context,
  }) {
    return CustomSnackBar(
      message: message,
      context: context,
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orangeAccent,
      backgroundColor: const Color(0xFF323232),
      duration: const Duration(seconds: 5),
    );
  }

}
