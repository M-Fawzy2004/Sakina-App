import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Standard Typography Tokens for Sakina Sanctuary.
/// Universally powered by GoogleFonts.cairo for modern, crisp, bold Arabic aesthetics,
/// while Quranic verses preserve venerable classical script with safe line height.
abstract final class AppTextStyles {
  // Quranic Sacred Scripture (Uthmanic / Classical Calligraphic Hafez)
  static TextStyle get quranAyah => GoogleFonts.amiri(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.pureChalk,
        height: 2.2,
        letterSpacing: 0.5,
      );

  static TextStyle get quranAyahLarge => GoogleFonts.amiri(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.pureChalk,
        height: 2.3,
        letterSpacing: 0.6,
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
}
