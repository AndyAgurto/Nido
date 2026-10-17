import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'app_colors.dart';

/// Configuración de temas Material 3 cálidos, proporcionales y accesibles para Móviles y Tablets.
class AppTheme {
  AppTheme._();

  static const _mobileTextTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5),
    headlineMedium: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, letterSpacing: -0.5),
    headlineSmall: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 13.5),
    bodyMedium: TextStyle(fontSize: 12.5),
    bodySmall: TextStyle(fontSize: 11),
    labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    labelMedium: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 10),
  );

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      error: AppColors.terracotta,
      onError: AppColors.onTerracotta,
      errorContainer: AppColors.terracottaContainer,
      onErrorContainer: AppColors.onTerracottaContainer,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.onSurfaceLight,
      onSurfaceVariant: AppColors.onSurfaceLightVariant,
      outline: AppColors.outlineLight,
      outlineVariant: AppColors.outlineVariantLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: _mobileTextTheme,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          side: const BorderSide(color: AppColors.outlineVariantLight, width: 1),
        ),
        color: AppColors.surfaceLightContainer,
        margin: EdgeInsets.zero,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.surfaceLightContainer,
        selectedIconTheme: const IconThemeData(color: AppColors.primary, size: 26),
        unselectedIconTheme: const IconThemeData(color: AppColors.onSurfaceLightVariant, size: 22),
        selectedLabelTextStyle: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: AppColors.onSurfaceLightVariant,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        indicatorColor: AppColors.primaryContainer,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
          borderSide: const BorderSide(color: AppColors.outlineVariantLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
          borderSide: const BorderSide(color: AppColors.outlineVariantLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
          ),
          textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
          ),
          side: const BorderSide(color: AppColors.outlineLight),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariantLight,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: const Color(0xFF00391F),
      primaryContainer: AppColors.primaryDarkContainer,
      onPrimaryContainer: const Color(0xFF8FF9BA),
      secondary: const Color(0xFFB1CCB9),
      onSecondary: const Color(0xFF1D3527),
      secondaryContainer: const Color(0xFF344C3D),
      onSecondaryContainer: const Color(0xFFCDE7D5),
      error: const Color(0xFFFFB4A4),
      onError: const Color(0xFF631200),
      errorContainer: const Color(0xFF8B250B),
      onErrorContainer: const Color(0xFFFFDAD3),
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      onSurfaceVariant: AppColors.onSurfaceDarkVariant,
      outline: AppColors.outlineDark,
      outlineVariant: AppColors.outlineVariantDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _mobileTextTheme,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          side: const BorderSide(color: AppColors.outlineVariantDark, width: 1),
        ),
        color: AppColors.surfaceDarkContainer,
        margin: EdgeInsets.zero,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.surfaceDarkContainer,
        selectedIconTheme: const IconThemeData(color: AppColors.primaryDark, size: 26),
        unselectedIconTheme: const IconThemeData(color: AppColors.onSurfaceDarkVariant, size: 22),
        selectedLabelTextStyle: const TextStyle(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: AppColors.onSurfaceDarkVariant,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        indicatorColor: AppColors.primaryDarkContainer,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDarkHigh,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
          borderSide: const BorderSide(color: AppColors.outlineVariantDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
          borderSide: const BorderSide(color: AppColors.outlineVariantDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
          borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
          ),
          textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariantDark,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
