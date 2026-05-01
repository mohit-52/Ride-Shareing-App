import 'package:flutter/material.dart' show Color;


/// Color palette definitions for the theme.
class ColorPalette {

  final Color white;
  final Color black;

  final Color primary;
  final Color primary50;
  final Color primary100;
  final Color primary200;
  final Color primary300;
  final Color primary400;
  final Color primary500;
  final Color primary600;
  final Color primary700;
  final Color primary800;
  final Color primary900;

  final Color secondary;
  final Color secondary50;
  final Color secondary100;
  final Color secondary200;
  final Color secondary300;
  final Color secondary400;
  final Color secondary500;
  final Color secondary600;
  final Color secondary700;
  final Color secondary800;
  final Color secondary900;

  final Color tertiary;
  final Color tertiary50;
  final Color tertiary100;
  final Color tertiary200;
  final Color tertiary300;
  final Color tertiary400;
  final Color tertiary500;
  final Color tertiary600;
  final Color tertiary700;
  final Color tertiary800;
  final Color tertiary900;

  final Color neutral;
  final Color neutral50;
  final Color neutral100;
  final Color neutral200;
  final Color neutral300;
  final Color neutral400;
  final Color neutral500;
  final Color neutral600;
  final Color neutral700;
  final Color neutral800;
  final Color neutral900;


  ColorPalette({
    required this.white,
    required this.black,
    required this.primary,
    required this.primary50,
    required this.primary100,
    required this.primary200,
    required this.primary300,
    required this.primary400,
    required this.primary500,
    required this.primary600,
    required this.primary700,
    required this.primary800,
    required this.primary900,
    required this.secondary,
    required this.secondary50,
    required this.secondary100,
    required this.secondary200,
    required this.secondary300,
    required this.secondary400,
    required this.secondary500,
    required this.secondary600,
    required this.secondary700,
    required this.secondary800,
    required this.secondary900,
    required this.tertiary,
    required this.tertiary50,
    required this.tertiary100,
    required this.tertiary200,
    required this.tertiary300,
    required this.tertiary400,
    required this.tertiary500,
    required this.tertiary600,
    required this.tertiary700,
    required this.tertiary800,
    required this.tertiary900,
    required this.neutral,
    required this.neutral50,
    required this.neutral100,
    required this.neutral200,
    required this.neutral300,
    required this.neutral400,
    required this.neutral500,
    required this.neutral600,
    required this.neutral700,
    required this.neutral800,
    required this.neutral900
  });
}

/// Color palette for the application.
abstract class ColorPalettes {

  static final petroleumModernismLightTheme = ColorPalette(
    white: Color(0xFFFFFFFF),
    black: Color(0xFF000000),
    primary: Color(0xFF0D9488),
    primary50: Color(0xFFB3FFF3),
    primary100: Color(0xFF89F5E7),
    primary200: Color(0xFF6BD8CB),
    primary300: Color(0xFF4CBCAF),
    primary400: Color(0xFF29A195),
    primary500: Color(0xFF00867B),
    primary600: Color(0xFF006A61),
    primary700: Color(0xFF005049),
    primary800: Color(0xFF003732),
    primary900: Color(0xFF00201D),
    secondary: Color(0xFF0F172A),
    secondary50: Color(0xFFEEF0FF),
    secondary100: Color(0xFFDAE2FD),
    secondary200: Color(0xFFBEC6E0),
    secondary300: Color(0xFFA3ABC4),
    secondary400: Color(0xFF8990A8),
    secondary500: Color(0xFF6F778E),
    secondary600: Color(0xFF565E74),
    secondary700: Color(0xFF3F465C),
    secondary800: Color(0xFF283044),
    secondary900: Color(0xFF131B2E),
    tertiary: Color(0xFFF0FDFA),
    tertiary50: Color(0xFFE6F3F1),
    tertiary100: Color(0xFFD8E5E2),
    tertiary200: Color(0xFFBCC9C6),
    tertiary300: Color(0xFFA1AEAB),
    tertiary400: Color(0xFF879391),
    tertiary500: Color(0xFF6D7A77),
    tertiary600: Color(0xFF55615F),
    tertiary700: Color(0xFF3D4947),
    tertiary800: Color(0xFF273331),
    tertiary900: Color(0xFF121E1C),
    neutral: Color(0xFF64748B),
    neutral50: Color(0xFFEAF1FF),
    neutral100: Color(0xFFD3E4FE),
    neutral200: Color(0xFFB7C8E1),
    neutral300: Color(0xFF9CACC5),
    neutral400: Color(0xFF8292AA),
    neutral500: Color(0xFF68788F),
    neutral600: Color(0xFF505F76),
    neutral700: Color(0xFF38485D),
    neutral800: Color(0xFF213145),
    neutral900: Color(0xFF0B1C30),
  );
}
