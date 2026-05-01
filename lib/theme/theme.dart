import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/// Application theme definitions.
abstract class AppTheme {

  static final petroleumModernismLightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.manrope().fontFamily,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,

      primary: Color(0xFF00685F),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF008378),
      onPrimaryContainer: Color(0xFFF4FFFC),

      secondary: Color(0xFF565E74),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFDAE2FD),
      onSecondaryContainer: Color(0xFF5C647A),

      tertiary: Color(0xFF525E5C),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF6B7775),
      onTertiaryContainer: Color(0xFFF3FFFC),

      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),

      surface: Color(0xFFF8F9FF),
      onSurface: Color(0xFF0B1C30),

      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFEFF4FF),
      surfaceContainer: Color(0xFFE5EEFF),
      surfaceContainerHigh: Color(0xFFDCE9FF),
      surfaceContainerHighest: Color(0xFFD3E4FE),

      onSurfaceVariant: Color(0xFF3D4947),
      outline: Color(0xFF6D7A77),
      outlineVariant: Color(0xFFBCC9C6),

      inverseSurface: Color(0xFF213145),
      onInverseSurface: Color(0xFFEAF1FF),
      inversePrimary: Color(0xFF6BD8CB),

      shadow: Colors.black,
      scrim: Colors.black,
      surfaceTint: Color(0xFF006A61),
    ),

    scaffoldBackgroundColor: const Color(0xFFF8F9FF),

    textTheme: TextTheme(
      headlineLarge: GoogleFonts.manrope(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 38 / 30,
        letterSpacing: -0.6,
      ),
      headlineMedium: GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        letterSpacing: -0.24,
      ),
      headlineSmall: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.14,
      ),
      labelMedium: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
      ),
      labelSmall: GoogleFonts.manrope(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 14 / 10,
      ),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFFE5EEFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF8F9FF),
      foregroundColor: Color(0xFF0B1C30),
      elevation: 5.0,
      surfaceTintColor: Colors.transparent,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00685F),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFEFF4FF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
