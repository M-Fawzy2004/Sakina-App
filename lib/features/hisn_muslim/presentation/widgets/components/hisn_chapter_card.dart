import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_chapter_entity.dart';

class HisnChapterCard extends StatelessWidget {
  final HisnChapterEntity chapter;
  final VoidCallback onTap;

  const HisnChapterCard({
    super.key,
    required this.chapter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TactileGlassCard(
      onTap: () {
        HapticService.selectionClick();
        onTap();
      },
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colors.accentGold.withValues(alpha: 0.3),
                width: 1.r,
              ),
            ),
            child: Center(
              child: Text(
                '${chapter.id}',
                style: AppTextStyles.captionOf(context).copyWith(
                  color: colors.accentGold,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapter.titleAr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMediumOf(context).copyWith(
                    color: colors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: colors.borderHairline,
                          width: 0.8.r,
                        ),
                      ),
                      child: Text(
                        chapter.category,
                        style: AppTextStyles.captionOf(context).copyWith(
                          color: colors.textSecondary,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${chapter.itemCount} ${chapter.itemCount == 1 ? "ذكر" : "أدعية"}',
                      style: AppTextStyles.captionOf(context).copyWith(
                        color: colors.accentGold,
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Iconsax.arrow_left_2,
            size: 16.r,
            color: colors.textSecondary,
          ),
        ],
      ),
    );
  }
}

