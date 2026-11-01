import 'package:flutter/material.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Semantic Theme Extension encapsulating Sakina's dynamic color system.
/// Allows any present or future widget to resolve theme-aware tokens cleanly
/// without branching on `isDark` manually.
@immutable
class AppColorsScheme extends ThemeExtension<AppColorsScheme> {
  final Color background;
  final Color cardSurface;
  final Color surfaceElevated;
  final Color frostedSurface;
  final Color borderHairline;
  final Color textPrimary;
  final Color textSecondary;
  final Color accentGold;
  final Color accentEmerald;
  final bool isDark;

  const AppColorsScheme({
    required this.background,
    required this.cardSurface,
    required this.surfaceElevated,
    required this.frostedSurface,
    required this.borderHairline,
    required this.textPrimary,
    required this.textSecondary,
    required this.accentGold,
    required this.accentEmerald,
    required this.isDark,
  });

  /// Calibrated Modern Charcoal Slate Palette (Primary Default Theme from User Specifications)
  static const AppColorsScheme charcoal = AppColorsScheme(
    background: AppColors.charcoalCore,
    cardSurface: AppColors.charcoalCard,
    surfaceElevated: AppColors.charcoalElevated,
    frostedSurface: AppColors.charcoalGlass,
    borderHairline: AppColors.charcoalBorder,
    textPrimary: AppColors.pureChalk,
    textSecondary: AppColors.charcoalMuted,
    accentGold: AppColors.champagneGold,
    accentEmerald: AppColors.emeraldGlow,
    isDark: true,
  );

  /// Calibrated OLED Luxury Dark Palette
  static const AppColorsScheme dark = AppColorsScheme(
    background: AppColors.obsidianCore,
    cardSurface: AppColors.carbonSlate,
    surfaceElevated: AppColors.surfaceElevated,
    frostedSurface: AppColors.frostedGlass,
    borderHairline: AppColors.goldBorderStroke,
    textPrimary: AppColors.pureChalk,
    textSecondary: AppColors.mutedSilver,
    accentGold: AppColors.champagneGold,
    accentEmerald: AppColors.emeraldGlow,
    isDark: true,
  );

  /// Calibrated Soothing Sacred Parchment Light Palette (Zero Eye-Strain)
  static const AppColorsScheme light = AppColorsScheme(
    background: AppColors.parchmentCore,
    cardSurface: AppColors.parchmentCard,
    surfaceElevated: AppColors.parchmentElevated,
    frostedSurface: AppColors.parchmentGlass,
    borderHairline: AppColors.parchmentBorder,
    textPrimary: AppColors.inkDeep,
    textSecondary: AppColors.inkMuted,
    accentGold: AppColors.warmGold,
    accentEmerald: AppColors.forestEmerald,
    isDark: false,
  );

  /// Calibrated Royal Emerald Sanctuary Palette (Chic 4th Regal Serenity Theme)
  static const AppColorsScheme emerald = AppColorsScheme(
    background: AppColors.emeraldSanctuaryCore,
    cardSurface: AppColors.emeraldSanctuaryCard,
    surfaceElevated: AppColors.emeraldSanctuaryElevated,
    frostedSurface: AppColors.emeraldSanctuaryGlass,
    borderHairline: AppColors.emeraldSanctuaryBorder,
    textPrimary: AppColors.pureChalk,
    textSecondary: AppColors.emeraldSanctuaryMuted,
    accentGold: AppColors.champagneGold,
    accentEmerald: AppColors.emeraldGlow,
    isDark: true,
  );

  @override
  AppColorsScheme copyWith({
    Color? background,
    Color? cardSurface,
    Color? surfaceElevated,
    Color? frostedSurface,
    Color? borderHairline,
    Color? textPrimary,
    Color? textSecondary,
    Color? accentGold,
    Color? accentEmerald,
    bool? isDark,
  }) {
    return AppColorsScheme(
      background: background ?? this.background,
      cardSurface: cardSurface ?? this.cardSurface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      frostedSurface: frostedSurface ?? this.frostedSurface,
      borderHairline: borderHairline ?? this.borderHairline,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      accentGold: accentGold ?? this.accentGold,
      accentEmerald: accentEmerald ?? this.accentEmerald,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppColorsScheme lerp(ThemeExtension<AppColorsScheme>? other, double t) {
    if (other is! AppColorsScheme) return this;
    return AppColorsScheme(
      background: Color.lerp(background, other.background, t) ?? background,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t) ?? cardSurface,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t) ?? surfaceElevated,
      frostedSurface: Color.lerp(frostedSurface, other.frostedSurface, t) ?? frostedSurface,
      borderHairline: Color.lerp(borderHairline, other.borderHairline, t) ?? borderHairline,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      accentGold: Color.lerp(accentGold, other.accentGold, t) ?? accentGold,
      accentEmerald: Color.lerp(accentEmerald, other.accentEmerald, t) ?? accentEmerald,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}

/// Syntactic sugar for effortless, zero-boilerplate theme access in widgets:
/// `context.colors.background` or `context.isDark`
extension SakinaThemeContextExtension on BuildContext {
  AppColorsScheme get colors {
    final extension = Theme.of(this).extension<AppColorsScheme>();
    if (extension != null) return extension;
    return Theme.of(this).brightness == Brightness.dark
        ? AppColorsScheme.dark
        : AppColorsScheme.light;
  }

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

