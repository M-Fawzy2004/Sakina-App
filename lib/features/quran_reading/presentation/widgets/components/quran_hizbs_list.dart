import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
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
    final colors = context.colors;

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
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colors.borderHairline,
                width: 1.r,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.accentEmerald,
                      width: 1.r,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$hizbNumber',
                      style: AppTextStyles.caption.copyWith(
                        color: colors.accentEmerald,
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
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'الجُزْءُ $juzNumber • سُورَةُ $surahName',
                        style: AppTextStyles.caption.copyWith(
                          color: colors.textSecondary,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Iconsax.arrow_left_2,
                  color: colors.accentGold,
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

