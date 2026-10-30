import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get darkLuxury {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.obsidianCore,
      canvasColor: AppColors.obsidianCore,
      cardColor: AppColors.carbonSlate,
      primaryColor: AppColors.champagneGold,
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
}

