import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static TextStyle get gameFont => GoogleFonts.michroma();

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF6200EA), // Deep Purple
    scaffoldBackgroundColor: const Color(0xFF100F1F), // Deep Blue/Black (Cyberpunk bg)
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFD300F9), // Neon Purple
      secondary: Color(0xFF00E5FF), // Cyan/Electric Blue
      surface: Color(0xFF1E1E2C), // Dark Blue-Grey Surface
      error: Color(0xFFFF2B5E), // Vibrant Red/Pink
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: gameFont.copyWith(fontSize: 48, color: Colors.white), // Game Titles
      headlineMedium: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.outfit(fontSize: 16),
    ),
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6200EA),
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFD300F9), width: 2), // Neon border
        ),
        elevation: 8,
        shadowColor: const Color(0xFFD300F9).withValues(alpha:0.5),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF00E5FF),
          side: const BorderSide(color: Color(0xFF00E5FF), width: 2),
          textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        )
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF252538),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD300F9), width: 2),
      ),
      hintStyle: GoogleFonts.outfit(color: Colors.white38),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: gameFont.copyWith(fontSize: 28, color: Colors.white),
    ),
    /* cardTheme: CardTheme(
      color: const Color(0xFF252538),
      elevation: 4,
      shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(16),
         side: const BorderSide(color: Colors.white12, width: 1),
      ),
    ), */
  );
}
