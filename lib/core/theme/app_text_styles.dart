import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Standard Typography Tokens for Sakina Sanctuary.
/// Quranic verses strictly use height >= 2.1 to prevent Tashkeel collision.
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

  // Calligraphic Headings & Surah Titles (Amiri)
  static TextStyle get headlineLarge => GoogleFonts.amiri(
        fontSize: 26.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.champagneGold,
        height: 1.4,
      );

  static TextStyle get headlineMedium => GoogleFonts.amiri(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.champagneGold,
        height: 1.4,
      );

  // Modern Arabic UI Body & Subtitles (Cairo)
  static TextStyle get titleLarge => GoogleFonts.cairo(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.pureChalk,
        height: 1.3,
      );

  static TextStyle get titleMedium => GoogleFonts.cairo(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.pureChalk,
        height: 1.3,
      );

  static TextStyle get bodyLarge => GoogleFonts.cairo(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.pureChalk,
        height: 1.4,
      );

  static TextStyle get bodyMedium => GoogleFonts.cairo(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedSilver,
        height: 1.4,
      );

  static TextStyle get caption => GoogleFonts.cairo(
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedSilver,
        height: 1.2,
      );

  static TextStyle get button => GoogleFonts.cairo(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.obsidianCore,
        height: 1.2,
      );
}

