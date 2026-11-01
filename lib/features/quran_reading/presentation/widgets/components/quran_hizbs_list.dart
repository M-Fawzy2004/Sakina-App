import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/hizb_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

/// Slivers of 60 Hizbs for Quran reading with authentic start verses and pages.
class QuranHizbsList extends StatelessWidget {
  final List<SurahEntity> allSurahs;
  final ValueChanged<HizbEntity> onHizbTap;

  const QuranHizbsList({
    super.key,
    required this.allSurahs,
    required this.onHizbTap,
  });

  @override
  Widget build(BuildContext context) {
    const hizbs = HizbEntity.allHizbs;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final hizb = hizbs[index];

          return _HizbTile(
            hizb: hizb,
            onTap: () => onHizbTap(hizb),
          );
        },
        childCount: hizbs.length,
      ),
    );
  }
}

class _HizbTile extends StatelessWidget {
  final HizbEntity hizb;
  final VoidCallback onTap;

  const _HizbTile({
    required this.hizb,
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
                      '${hizb.number}',
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
                      Row(
                        children: [
                          Text(
                            'الحِزْبُ ${hizb.number}',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surfaceElevated,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: colors.borderHairline,
                                width: 0.8.r,
                              ),
                            ),
                            child: Text(
                              'ص ${hizb.startPageNumber}',
                              style: AppTextStyles.caption.copyWith(
                                color: colors.accentGold,
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'الجُزْءُ ${hizb.juzNumber} • سُورَةُ ${hizb.surahName} • الآيَةُ ${hizb.startVerseNumber}',
                        style: AppTextStyles.caption.copyWith(
                          color: colors.textSecondary,
                          fontSize: 11.sp,
                        ),
                      ),
                      if (hizb.quarterTitle.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Text(
                          '«${hizb.quarterTitle}»',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: colors.accentEmerald.withValues(alpha: 0.85),
                            fontSize: 10.5.sp,
                            fontFamily: 'Amiri',
                          ),
                        ),
                      ],
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
