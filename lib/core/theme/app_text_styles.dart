import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';

/// Standard Typography Tokens for Sakina Sanctuary.
/// Universally powered by GoogleFonts.cairo for modern, crisp, bold Arabic aesthetics,
/// while Quranic verses preserve venerable classical script with safe line height.
/// Supports static dark defaults and dynamic context-aware resolution for light & dark themes.
abstract final class AppTextStyles {
  // ---------------------------------------------------------------------------
  // Context-Aware Dynamic Text Styles (Theme Adaptive)
  // ---------------------------------------------------------------------------
  /// Resolves the sacred scripture font family and baseline style based on selected [QuranScriptStyle].
  static TextStyle quranScriptStyleOf(QuranScriptStyle style) {
    switch (style) {
      case QuranScriptStyle.uthmani:
        return GoogleFonts.amiri(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        );
      case QuranScriptStyle.amiri:
        return GoogleFonts.notoNaskhArabic(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        );
      case QuranScriptStyle.indopak:
        return GoogleFonts.scheherazadeNew(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        );
    }
  }
  static TextStyle quranAyahOf(BuildContext context) => GoogleFonts.amiri(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: context.colors.textPrimary,
        height: 2.1,
        letterSpacing: 0.3,
      );

  static TextStyle quranAyahLargeOf(BuildContext context) => GoogleFonts.amiri(
        fontSize: 29.sp,
        fontWeight: FontWeight.w700,
        color: context.colors.textPrimary,
        height: 2.2,
        letterSpacing: 0.4,
      );

  static TextStyle quranIlluminatedAyahOf(BuildContext context) => GoogleFonts.amiri(
        fontSize: 21.sp,
        fontWeight: FontWeight.w700,
        color: context.colors.accentGold,
        height: 2.1,
        letterSpacing: 0.3,
      );

  static TextStyle headlineLargeOf(BuildContext context) => GoogleFonts.almarai(
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
        color: context.colors.accentGold,
        height: 1.35,
        letterSpacing: 0.2,
      );

  static TextStyle headlineMediumOf(BuildContext context) => GoogleFonts.almarai(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: context.colors.accentGold,
        height: 1.35,
      );

  static TextStyle titleLargeOf(BuildContext context) => GoogleFonts.almarai(
        fontSize: 16.5.sp,
        fontWeight: FontWeight.w700,
        color: context.colors.textPrimary,
        height: 1.35,
      );

  static TextStyle titleMediumOf(BuildContext context) => GoogleFonts.almarai(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: context.colors.textPrimary,
        height: 1.35,
      );

  static TextStyle bodyLargeOf(BuildContext context) => GoogleFonts.almarai(
        fontSize: 13.5.sp,
        fontWeight: FontWeight.w700,
        color: context.colors.textPrimary,
        height: 1.5,
      );

  static TextStyle bodyMediumOf(BuildContext context) => GoogleFonts.almarai(
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w400,
        color: context.colors.textSecondary,
        height: 1.5,
      );

  static TextStyle captionOf(BuildContext context) => GoogleFonts.almarai(
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: context.colors.textSecondary,
        height: 1.3,
      );

  // ---------------------------------------------------------------------------
  // Static Default Typography Tokens (Maintained for Backwards Compatibility)
  // ---------------------------------------------------------------------------
  // Quranic Sacred Scripture (Classical Amiri Naskh)
  static TextStyle get quranAyah => GoogleFonts.amiri(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.pureChalk,
        height: 2.1,
        letterSpacing: 0.3,
      );

  static TextStyle get quranAyahLarge => GoogleFonts.amiri(
        fontSize: 29.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.pureChalk,
        height: 2.2,
        letterSpacing: 0.4,
      );

  // Traditional Illuminated Quran Scripture (Amiri Calligraphy - matching design mockup)
  static TextStyle get quranIlluminatedAyah => GoogleFonts.amiri(
        fontSize: 21.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.paleRadiance,
        height: 2.1,
        letterSpacing: 0.3,
      );

  // Modern Bold Headings & Surah Titles (Almarai - Clean, Elegant & Crisp)
  static TextStyle get headlineLarge => GoogleFonts.almarai(
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.champagneGold,
        height: 1.35,
        letterSpacing: 0.2,
      );

  static TextStyle get headlineMedium => GoogleFonts.almarai(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.champagneGold,
        height: 1.35,
      );

  // Modern Arabic UI Body & Subtitles (Almarai)
  static TextStyle get titleLarge => GoogleFonts.almarai(
        fontSize: 16.5.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.pureChalk,
        height: 1.35,
      );

  static TextStyle get titleMedium => GoogleFonts.almarai(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.pureChalk,
        height: 1.35,
      );

  static TextStyle get bodyLarge => GoogleFonts.almarai(
        fontSize: 13.5.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.pureChalk,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.almarai(
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedSilver,
        height: 1.5,
      );

  static TextStyle get caption => GoogleFonts.almarai(
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedSilver,
        height: 1.3,
      );

  static TextStyle get button => GoogleFonts.almarai(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.obsidianCore,
        height: 1.2,
      );

  // Modern Surah Card & TabBar Typography Tokens (matching image specifications)
  static TextStyle get surahCardEnglishTitle => GoogleFonts.almarai(
        fontSize: 14.5.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.emeraldGlow,
        height: 1.25,
      );

  static TextStyle get surahCardEnglishSubtitle => GoogleFonts.almarai(
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedSilver,
        height: 1.25,
      );

  static TextStyle get surahCardArabicTitle => GoogleFonts.amiri(
        fontSize: 18.5.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.champagneGold,
        height: 1.25,
      );

  static TextStyle get surahCardIndex => GoogleFonts.almarai(
        fontSize: 15.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.pureChalk,
        height: 1.2,
      );

  static TextStyle get tabActiveText => GoogleFonts.almarai(
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.obsidianCore,
        height: 1.2,
      );

  static TextStyle get tabInactiveText => GoogleFonts.almarai(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.mutedSilver,
        height: 1.2,
      );
}
