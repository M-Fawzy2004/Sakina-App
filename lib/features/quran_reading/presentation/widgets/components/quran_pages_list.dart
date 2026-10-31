import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

/// Slivers of Quran pages (1 to 604) for jumping directly to any manuscript page.
class QuranPagesList extends StatelessWidget {
  final List<SurahEntity> allSurahs;
  final ValueChanged<int> onPageTap;

  const QuranPagesList({
    super.key,
    required this.allSurahs,
    required this.onPageTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final pageNum = index + 1;
          final surah = allSurahs.lastWhere(
            (s) => s.pageNumber <= pageNum,
            orElse: () => allSurahs.first,
          );

          return _PageTile(
            pageNumber: pageNum,
            surahName: surah.nameArabic,
            juzNumber: surah.juzNumber,
            onTap: () => onPageTap(pageNum),
          );
        },
        childCount: 604,
      ),
    );
  }
}

class _PageTile extends StatelessWidget {
  final int pageNumber;
  final String surahName;
  final int juzNumber;
  final VoidCallback onTap;

  const _PageTile({
    required this.pageNumber,
    required this.surahName,
    required this.juzNumber,
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
                      color: colors.accentGold,
                      width: 1.r,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$pageNumber',
                      style: AppTextStyles.caption.copyWith(
                        color: colors.accentGold,
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
                        'الصَّفْحَةُ $pageNumber',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'سُورَةُ $surahName • الجُزْءُ $juzNumber',
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

