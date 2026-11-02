import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

/// Ornate Calligraphic Basmalah Banner with Star Divider.
class QuranBasmalahHeader extends StatelessWidget {
  final double fontSizeDelta;
  final Color accentColor;

  const QuranBasmalahHeader({
    super.key,
    required this.fontSizeDelta,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text(
            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            textAlign: TextAlign.center,
            style: AppTextStyles.quranIlluminatedAyah.copyWith(
              fontSize: 25.sp + fontSizeDelta,
              color: accentColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50.w,
              height: 0.8.h,
              color: AppColors.goldBorderStroke.withValues(alpha: 0.4),
            ),
            SizedBox(width: 8.w),
            Icon(
              Iconsax.star_1,
              size: 13.r,
              color: accentColor,
            ),
            SizedBox(width: 8.w),
            Container(
              width: 50.w,
              height: 0.8.h,
              color: AppColors.goldBorderStroke.withValues(alpha: 0.4),
            ),
          ],
        ),
      ],
    );
  }
}

/// Seamless illuminated footer guiding reader to the next page or next Surah.
class QuranNextSectionFooter extends StatelessWidget {
  final bool isLastPageOfSurah;
  final String? nextSurahName;
  final int nextPageNumber;
  final int totalPages;
  final Color accentColor;
  final Color cardColor;
  final Color textColor;
  final VoidCallback onTap;

  const QuranNextSectionFooter({
    super.key,
    required this.isLastPageOfSurah,
    this.nextSurahName,
    required this.nextPageNumber,
    required this.totalPages,
    required this.accentColor,
    required this.cardColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = (isLastPageOfSurah && nextSurahName != null)
        ? 'السُّورَةُ التَّالِيَة: سُورَةُ $nextSurahName'
        : 'الصَّفْحَةُ التَّالِيَة ($nextPageNumber مِنْ $totalPages)';

    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: accentColor.withValues(alpha: 0.15),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.45),
                width: 1.r,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: accentColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Iconsax.arrow_left_2,
                  size: 16.r,
                  color: accentColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

