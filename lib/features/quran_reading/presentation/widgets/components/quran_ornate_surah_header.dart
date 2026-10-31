import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

/// Compact and elegant Surah Name Header:
/// Refined, proportional single-tier header with subtle Islamic star flourishes.
class QuranOrnateSurahHeader extends StatelessWidget {
  final SurahEntity surah;

  const QuranOrnateSurahHeader({
    super.key,
    required this.surah,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.goldBorderStroke,
          width: 0.9.r,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '۞',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.champagneGold,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            'سُورَةُ ${surah.nameArabic}',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.champagneGold,
              fontSize: 15.5.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            '۞',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.champagneGold,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
