import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  AppTheme._();

  // Harmony palette: navy, lavender, gold (from premium packaging style)
  static const Color primary = Color(0xFF152046);        // Deep navy – main brand
  static const Color primaryDark = Color(0xFF0F1A38);  // Darker navy – gradients
  static const Color primaryContainer = Color(0xFFE8EBF5); // Light lavender tint – surfaces
  static const Color onPrimaryContainer = Color(0xFF152046);

  static const Color accent = Color(0xFF96A4D3);        // Lavender-blue – soft accent
  static const Color gold = Color(0xFFAA8F76);         // Muted gold/beige – warm accent
  static const Color secondary = Color(0xFFAA8F76);   // Gold as secondary
  static const Color secondaryContainer = Color(0xFFF5F2EE); // Light warm tint
  static const Color surface = Color(0xFFFAFAFA);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFD97706);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: AppConstants.fontFamily,
        colorScheme: ColorScheme.light(
          primary: primary,
          onPrimary: Colors.white,
          primaryContainer: primaryContainer,
          onPrimaryContainer: onPrimaryContainer,
          secondary: secondary,
          onSecondary: Colors.white,
          secondaryContainer: secondaryContainer,
          onSecondaryContainer: const Color(0xFF1E293B),
          surface: surface,
          onSurface: const Color(0xFF1E293B),
          surfaceContainerHighest: const Color(0xFFE2E8F0),
          error: error,
          onError: Colors.white,
          outline: const Color(0xFF94A3B8),
          outlineVariant: const Color(0xFFE2E8F0),
          shadow: Colors.black26,
          scrim: Colors.black54,
          inverseSurface: const Color(0xFF334155),
          onSurfaceVariant: const Color(0xFF64748B),
        ),
        scaffoldBackgroundColor: surface,
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 2,
          centerTitle: true,
          backgroundColor: surface,
          foregroundColor: const Color(0xFF1E293B),
          titleTextStyle: const TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
            letterSpacing: -0.3,
          ),
          iconTheme: const IconThemeData(size: 20, color: Color(0xFF152046)),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            minimumSize: const Size(double.infinity, 44),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: primary,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontFamily: AppConstants.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          extendedTextStyle: const TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 44),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: error),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintStyle: const TextStyle(
            fontFamily: AppConstants.fontFamily,
            color: Color(0xFF94A3B8),
            fontSize: 14,
          ),
          labelStyle: const TextStyle(
            fontFamily: AppConstants.fontFamily,
            color: Color(0xFF64748B),
          ),
        ),
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          minLeadingWidth: 40,
        ),
        textTheme: TextTheme(
          headlineMedium: const TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: -0.5,
            color: Color(0xFF1E293B),
          ),
          titleLarge: const TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xFF1E293B),
          ),
          titleMedium: const TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
          titleSmall: const TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: Color(0xFF475569),
          ),
          bodyLarge: const TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontSize: 14,
            color: Color(0xFF334155),
          ),
          bodyMedium: const TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontSize: 13,
            color: Color(0xFF475569),
          ),
          bodySmall: const TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontSize: 11,
            color: Color(0xFF94A3B8),
          ),
          labelLarge: const TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      );
}
