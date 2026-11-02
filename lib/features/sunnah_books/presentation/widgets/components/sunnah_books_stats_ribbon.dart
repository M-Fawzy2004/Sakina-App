import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';

class SunnahBooksStatsRibbon extends StatelessWidget {
  final int totalBooks;
  final int totalChapters;
  final int totalHadiths;

  const SunnahBooksStatsRibbon({
    super.key,
    required this.totalBooks,
    required this.totalChapters,
    required this.totalHadiths,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TactileGlassCard(
        padding: EdgeInsets.all(14.r),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: colors.surfaceElevated.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: colors.borderHairline,
                  width: 0.8.r,
                ),
              ),
              child: Text(
                '« نَضَّرَ اللَّهُ امْرَأً سَمِعَ مِنَّا حَدِيثًا فَحَفِظَهُ حَتَّى يُبَلِّغَهُ »',
                textAlign: TextAlign.center,
                style: AppTextStyles.quranAyahOf(context).copyWith(
                  color: colors.accentGold,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    count: '$totalBooks',
                    label: 'أصول الكتب',
                    color: colors.accentGold,
                  ),
                ),
                Container(
                  width: 1.r,
                  height: 28.h,
                  color: colors.borderHairline,
                ),
                Expanded(
                  child: _StatItem(
                    count: '$totalChapters',
                    label: 'أبواباً وكتاباً',
                    color: colors.accentEmerald,
                  ),
                ),
                Container(
                  width: 1.r,
                  height: 28.h,
                  color: colors.borderHairline,
                ),
                Expanded(
                  child: _StatItem(
                    count: '$totalHadiths',
                    label: 'حديثاً شريفاً',
                    color: colors.accentGold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const _StatItem({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        Text(
          count,
          style: AppTextStyles.titleMediumOf(context).copyWith(
            color: color,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppTextStyles.captionOf(context).copyWith(
            color: colors.textSecondary,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}
