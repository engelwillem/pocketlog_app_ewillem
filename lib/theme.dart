
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Light Theme Color Scheme
const _lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF006874),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF97F0FF),
  onPrimaryContainer: Color(0xFF001F24),
  secondary: Color(0xFF4A6267),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFCDE7EC),
  onSecondaryContainer: Color(0xFF051F23),
  tertiary: Color(0xFF525E7D),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFDAE2FF),
  onTertiaryContainer: Color(0xFF0E1A37),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFFAFDFD),
  onSurface: Color(0xFF191C1D),
  surfaceContainerHighest: Color(0xFFDBE4E6),
  onSurfaceVariant: Color(0xFF3F484A),
  outline: Color(0xFF6F797B),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFF2E3132),
  onInverseSurface: Color(0xFFEFF1F1),
  inversePrimary: Color(0xFF4FD8EB),
  surfaceTint: Color(0xFF006874),
);

// Dark Theme Color Scheme
const _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF4FD8EB),
  onPrimary: Color(0xFF00363D),
  primaryContainer: Color(0xFF004F58),
  onPrimaryContainer: Color(0xFF97F0FF),
  secondary: Color(0xFFB1CBD0),
  onSecondary: Color(0xFF1C3438),
  secondaryContainer: Color(0xFF334B4F),
  onSecondaryContainer: Color(0xFFCDE7EC),
  tertiary: Color(0xFFBAC6EA),
  onTertiary: Color(0xFF24304D),
  tertiaryContainer: Color(0xFF3B4664),
  onTertiaryContainer: Color(0xFFDAE2FF),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: Color(0xFF191C1D),
  onSurface: Color(0xFFE1E3E3),
  surfaceContainerHighest: Color(0xFF3F484A),
  onSurfaceVariant: Color(0xFFBFC8CA),
  outline: Color(0xFF899294),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFFE1E3E3),
  onInverseSurface: Color(0xFF191C1D),
  inversePrimary: Color(0xFF006874),
  surfaceTint: Color(0xFF4FD8EB),
);

final _textTheme = GoogleFonts.interTextTheme();

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _lightColorScheme,
  textTheme: _textTheme.apply(
    bodyColor: _lightColorScheme.onSurface,
    displayColor: _lightColorScheme.onSurface,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: _lightColorScheme.primary,
    foregroundColor: _lightColorScheme.onPrimary,
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _darkColorScheme,
  textTheme: _textTheme.apply(
    bodyColor: _darkColorScheme.onSurface,
    displayColor: _darkColorScheme.onSurface,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: _darkColorScheme.primary,
    foregroundColor: _darkColorScheme.onPrimary,
  ),
);
