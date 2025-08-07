import 'package:flutter/material.dart'
    show
        Color,
        ThemeData,
        ColorScheme,
        Brightness,
        AppBarTheme,
        BottomNavigationBarThemeData,
        EdgeInsets,
        FloatingActionButtonThemeData,
        BorderSide,
        IconThemeData,
        TextTheme,
        TextStyle,
        FontWeight,
        BottomNavigationBarType,
        BorderRadius,
        RoundedRectangleBorder,
        CardThemeData,
        ElevatedButton,
        ElevatedButtonThemeData,
        OutlineInputBorder,
        InputDecorationTheme,
        ChipThemeData;

import '../styles/colors.dart';

/// Provides the application's theme configuration using Material 3.
///
/// This class defines a consistent theme with a light green color palette,
/// including configurations for colors, typography, and component styles.
class AppTheme {
  /// The light green color used as the primary color in the theme.
  static const Color _lightGreen = Color(0xFF81C784);

  /// The darker green color used for accents in the theme.
  static const Color _lightGreenDark = Color(0xFF519657);

  /// A very soft mint color used for cards and backgrounds.
  static const Color _mint = Color(0xFFE8F5E8); // Very soft mint for cards

  // Supporting Colors
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _black = Color(0xFF212121);
  static const Color _grey = Color(0xFF757575);
  static const Color _lightGrey = Color(0xFFF5F5F5);
  static const Color _error = Color(0xFFE57373);

  /// Light Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: _lightGreen,
        brightness: Brightness.light,
        primary: _lightGreen,
        onPrimary: _white,
        secondary: _lightGreenDark,
        onSecondary: _white,
        surface: _white,
        onSurface: _black,
        // background: _lightGrey,
        // onBackground: _black,
        error: _error,
        onError: _white,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightGreen,
        foregroundColor: _white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _white,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _white,
        selectedItemColor: _lightGreen,
        unselectedItemColor: _grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: _white,
        elevation: 2,
        shadowColor: _lightGreen.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightGreen,
          foregroundColor: _white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _lightGreen,
        foregroundColor: _white,
        elevation: 4,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _mint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _lightGreen.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightGreen, width: 2),
        ),
        prefixIconColor: _lightGreen,
        suffixIconColor: _lightGreen,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: _lightGreen, size: 24),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: _black,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: _black,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _black,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _black,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: _black),
        bodyMedium: TextStyle(fontSize: 14, color: _grey),
        bodySmall: TextStyle(fontSize: 12, color: _grey),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: _mint,
        labelStyle: const TextStyle(color: _lightGreenDark),
        side: BorderSide(color: _lightGreen.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Scaffold Background
      scaffoldBackgroundColor: _lightGrey,
    );
  }

  /// Custom colors for specific use cases in the application.
  ///
  /// **Includes:**
  /// - `favoriteRed`: Color for favorite items.
  /// - `ratingYellow`: Color for ratings.
  /// - `cardBackground`: Background color for cards.
  /// - `moviePosterBorder`: Border color for movie posters.
  static Color get favoriteRed => CustomColors.favoriteRed;
  static Color get ratingYellow => CustomColors.ratingYellow;
  static Color get cardBackground => CustomColors.cardBackground;
  static Color get moviePosterBorder => CustomColors.moviePosterBorder;

  /// Helper methods for skeleton loading and placeholder colors.
  ///
  /// **Includes:**
  /// - `posterPlaceholderColor`: Color for poster placeholders.
  /// - `skeletonBaseColor`: Base color for skeleton loading effects.
  /// - `skeletonHighlightColor`: Highlight color for skeleton loading effects.
  static Color get posterPlaceholderColor => _mint;
  static Color get skeletonBaseColor => CustomColors.shimmerBase;
  static Color get skeletonHighlightColor => CustomColors.shimmerHighlight;
}
