import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Standard Typography Tokens for Sakina Sanctuary.
/// Universally powered by GoogleFonts.cairo for modern, crisp, bold Arabic aesthetics,
/// while Quranic verses preserve venerable classical script with safe line height.
/// Supports static dark defaults and dynamic context-aware resolution for light & dark themes.
abstract final class AppTextStyles {
  // ---------------------------------------------------------------------------
  // Context-Aware Dynamic Text Styles (Theme Adaptive)
  // ---------------------------------------------------------------------------
  static TextStyle quranAyahOf(BuildContext context) => GoogleFonts.cairo(
        fontSize: 23.sp,
        fontWeight: FontWeight.w700,
        color: context.colors.textPrimary,
        height: 2.1,
        letterSpacing: 0.3,
      );

  static TextStyle quranAyahLargeOf(BuildContext context) => GoogleFonts.cairo(
        fontSize: 28.sp,
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

  static TextStyle headlineLargeOf(BuildContext context) => GoogleFonts.cairo(
        fontSize: 25.sp,
        fontWeight: FontWeight.w800,
        color: context.colors.accentGold,
        height: 1.35,
        letterSpacing: 0.2,
      );

  static TextStyle headlineMediumOf(BuildContext context) => GoogleFonts.cairo(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: context.colors.accentGold,
        height: 1.35,
      );

  static TextStyle titleLargeOf(BuildContext context) => GoogleFonts.cairo(
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        color: context.colors.textPrimary,
        height: 1.35,
      );

  static TextStyle titleMediumOf(BuildContext context) => GoogleFonts.cairo(
        fontSize: 14.5.sp,
        fontWeight: FontWeight.w700,
        color: context.colors.textPrimary,
        height: 1.35,
      );

  static TextStyle bodyLargeOf(BuildContext context) => GoogleFonts.cairo(
        fontSize: 13.5.sp,
        fontWeight: FontWeight.w600,
        color: context.colors.textPrimary,
        height: 1.45,
      );

  static TextStyle bodyMediumOf(BuildContext context) => GoogleFonts.cairo(
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w500,
        color: context.colors.textSecondary,
        height: 1.45,
      );

  static TextStyle captionOf(BuildContext context) => GoogleFonts.cairo(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: context.colors.textSecondary,
        height: 1.3,
      );

  // ---------------------------------------------------------------------------
  // Static Default Typography Tokens (Maintained for Backwards Compatibility)
  // ---------------------------------------------------------------------------
  // Quranic Sacred Scripture (Crisp, Straight & Highly Legible Cairo Script)
  static TextStyle get quranAyah => GoogleFonts.cairo(
        fontSize: 23.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.pureChalk,
        height: 2.1,
        letterSpacing: 0.3,
      );

  static TextStyle get quranAyahLarge => GoogleFonts.cairo(
        fontSize: 28.sp,
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

  // Modern Bold Headings & Surah Titles (Cairo - matching Onboarding)
  static TextStyle get headlineLarge => GoogleFonts.cairo(
        fontSize: 25.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.champagneGold,
        height: 1.35,
        letterSpacing: 0.2,
      );

  static TextStyle get headlineMedium => GoogleFonts.cairo(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.champagneGold,
        height: 1.35,
      );

  // Modern Arabic UI Body & Subtitles (Cairo)
  static TextStyle get titleLarge => GoogleFonts.cairo(
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.pureChalk,
        height: 1.35,
      );

  static TextStyle get titleMedium => GoogleFonts.cairo(
        fontSize: 14.5.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.pureChalk,
        height: 1.35,
      );

  static TextStyle get bodyLarge => GoogleFonts.cairo(
        fontSize: 13.5.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.pureChalk,
        height: 1.45,
      );

  static TextStyle get bodyMedium => GoogleFonts.cairo(
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.mutedSilver,
        height: 1.45,
      );

  static TextStyle get caption => GoogleFonts.cairo(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.mutedSilver,
        height: 1.3,
      );

  static TextStyle get button => GoogleFonts.cairo(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.obsidianCore,
        height: 1.2,
      );

  // Modern Surah Card & TabBar Typography Tokens (matching image specifications)
  static TextStyle get surahCardEnglishTitle => GoogleFonts.cairo(
        fontSize: 14.5.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.emeraldGlow,
        height: 1.25,
      );

  static TextStyle get surahCardEnglishSubtitle => GoogleFonts.cairo(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.mutedSilver,
        height: 1.25,
      );

  static TextStyle get surahCardArabicTitle => GoogleFonts.amiri(
        fontSize: 18.5.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.champagneGold,
        height: 1.25,
      );

  static TextStyle get surahCardIndex => GoogleFonts.cairo(
        fontSize: 15.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.pureChalk,
        height: 1.2,
      );

  static TextStyle get tabActiveText => GoogleFonts.cairo(
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.obsidianCore,
        height: 1.2,
      );

  static TextStyle get tabInactiveText => GoogleFonts.cairo(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.mutedSilver,
        height: 1.2,
      );
}
