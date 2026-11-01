import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';

abstract final class AppTheme {
  /// Modern Charcoal Slate Luxury Theme (Primary Default Theme from user specifications)
  static ThemeData get charcoalLuxury {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: GoogleFonts.cairoTextTheme().apply(
        bodyColor: AppColors.pureChalk,
        displayColor: AppColors.pureChalk,
      ),
      scaffoldBackgroundColor: AppColors.charcoalCore,
      canvasColor: AppColors.charcoalCore,
      cardColor: AppColors.charcoalCard,
      primaryColor: AppColors.charcoalAccent,
      extensions: const [AppColorsScheme.charcoal],
      colorScheme: const ColorScheme.dark(
        primary: AppColors.charcoalAccent,
        onPrimary: AppColors.charcoalCore,
        secondary: AppColors.emeraldGlow,
        onSecondary: AppColors.pureChalk,
        surface: AppColors.charcoalCard,
        onSurface: AppColors.pureChalk,
        error: AppColors.errorRed,
        onError: AppColors.pureChalk,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.pureChalk),
        titleTextStyle: AppTextStyles.headlineMedium,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.charcoalBorder,
        thickness: 0.8,
        space: 1,
      ),
    );
  }

  /// OLED Tactile Luxury Dark Theme (Obsidian & Pure Gold)
  static ThemeData get darkLuxury {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: GoogleFonts.cairoTextTheme().apply(
        bodyColor: AppColors.pureChalk,
        displayColor: AppColors.pureChalk,
      ),
      scaffoldBackgroundColor: AppColors.obsidianCore,
      canvasColor: AppColors.obsidianCore,
      cardColor: AppColors.carbonSlate,
      primaryColor: AppColors.champagneGold,
      extensions: const [AppColorsScheme.dark],
      colorScheme: const ColorScheme.dark(
        primary: AppColors.champagneGold,
        onPrimary: AppColors.obsidianCore,
        secondary: AppColors.emeraldGlow,
        onSecondary: AppColors.pureChalk,
        surface: AppColors.carbonSlate,
        onSurface: AppColors.pureChalk,
        error: AppColors.errorRed,
        onError: AppColors.pureChalk,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.pureChalk),
        titleTextStyle: AppTextStyles.headlineMedium,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.goldBorderStroke,
        thickness: 0.8,
        space: 1,
      ),
    );
  }

  /// Calming Sacred Parchment Light Theme (Zero Eye-Strain Cream Canvas)
  static ThemeData get lightLuxury {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: GoogleFonts.cairoTextTheme().apply(
        bodyColor: AppColors.inkDeep,
        displayColor: AppColors.inkDeep,
      ),
      scaffoldBackgroundColor: AppColors.parchmentCore,
      canvasColor: AppColors.parchmentCore,
      cardColor: AppColors.parchmentCard,
      primaryColor: AppColors.warmGold,
      extensions: const [AppColorsScheme.light],
      colorScheme: const ColorScheme.light(
        primary: AppColors.warmGold,
        onPrimary: AppColors.parchmentCore,
        secondary: AppColors.forestEmerald,
        onSecondary: AppColors.parchmentCore,
        surface: AppColors.parchmentCard,
        onSurface: AppColors.inkDeep,
        error: AppColors.errorRed,
        onError: AppColors.pureChalk,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.inkDeep),
        titleTextStyle: AppTextStyles.headlineMedium.copyWith(color: AppColors.warmGold),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.parchmentBorder,
        thickness: 0.8,
        space: 1,
      ),
    );
  }

  /// Royal Emerald Sanctuary Theme (Chic 4th Regal Serenity Theme)
  static ThemeData get emeraldLuxury {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: GoogleFonts.cairoTextTheme().apply(
        bodyColor: AppColors.pureChalk,
        displayColor: AppColors.pureChalk,
      ),
      scaffoldBackgroundColor: AppColors.emeraldSanctuaryCore,
      canvasColor: AppColors.emeraldSanctuaryCore,
      cardColor: AppColors.emeraldSanctuaryCard,
      primaryColor: AppColors.emeraldGlow,
      extensions: const [AppColorsScheme.emerald],
      colorScheme: const ColorScheme.dark(
        primary: AppColors.emeraldGlow,
        onPrimary: AppColors.emeraldSanctuaryCore,
        secondary: AppColors.champagneGold,
        onSecondary: AppColors.pureChalk,
        surface: AppColors.emeraldSanctuaryCard,
        onSurface: AppColors.pureChalk,
        error: AppColors.errorRed,
        onError: AppColors.pureChalk,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.pureChalk),
        titleTextStyle: AppTextStyles.headlineMedium.copyWith(color: AppColors.emeraldGlow),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.emeraldSanctuaryBorder,
        thickness: 0.8,
        space: 1,
      ),
    );
  }

  /// Resolves the corresponding ThemeData for any [AppThemeMode].
  static ThemeData themeFor(AppThemeMode mode, {bool isSystemDark = true}) {
    return switch (mode) {
      AppThemeMode.charcoal => charcoalLuxury,
      AppThemeMode.dark => darkLuxury,
      AppThemeMode.light => lightLuxury,
      AppThemeMode.emerald => emeraldLuxury,
      AppThemeMode.system => isSystemDark ? charcoalLuxury : lightLuxury,
    };
  }
}
