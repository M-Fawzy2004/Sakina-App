import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

/// Slivers of 60 Hizbs for Quran reading.
class QuranHizbsList extends StatelessWidget {
  final List<SurahEntity> allSurahs;
  final ValueChanged<int> onHizbTap;

  const QuranHizbsList({
    super.key,
    required this.allSurahs,
    required this.onHizbTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final hizbNum = index + 1;
          final juzIndex = ((hizbNum - 1) ~/ 2) + 1;
          final surah = allSurahs.firstWhere(
            (s) => s.juzNumber >= juzIndex,
            orElse: () => allSurahs.first,
          );

          return _HizbTile(
            hizbNumber: hizbNum,
            juzNumber: juzIndex,
            surahName: surah.nameArabic,
            onTap: () => onHizbTap(hizbNum),
          );
        },
        childCount: 60,
      ),
    );
  }
}

class _HizbTile extends StatelessWidget {
  final int hizbNumber;
  final int juzNumber;
  final String surahName;
  final VoidCallback onTap;

  const _HizbTile({
    required this.hizbNumber,
    required this.juzNumber,
    required this.surahName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticService.selectionClick();
            onTap();
          },
          borderRadius: BorderRadius.circular(16.r),
          splashColor: AppColors.goldGlowSoft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.goldBorderStroke.withValues(alpha: 0.25),
                width: 1.r,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: AppColors.carbonSlate,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.emeraldGlow,
                      width: 1.r,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$hizbNumber',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.emeraldGlow,
                        fontWeight: FontWeight.w800,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'الحِزْبُ $hizbNumber',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.pureChalk,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'الجُزْءُ $juzNumber • سُورَةُ $surahName',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.mutedSilver,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Iconsax.arrow_left_2,
                  color: AppColors.champagneGold,
                  size: 16.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

