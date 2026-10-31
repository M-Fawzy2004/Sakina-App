import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

class InabaStreakProgressCard extends StatelessWidget {
  final int streakDays;
  final double progress;
  final String levelTitle;
  final String statusText;
  final VoidCallback onTreeTap;

  const InabaStreakProgressCard({
    super.key,
    required this.streakDays,
    required this.progress,
    required this.levelTitle,
    required this.statusText,
    required this.onTreeTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: colors.borderHairline,
              width: 1.r,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Title & Level Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(7.r),
                        decoration: BoxDecoration(
                          color: colors.surfaceElevated,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: colors.borderHairline,
                            width: 1.r,
                          ),
                        ),
                        child: Icon(
                          Iconsax.award,
                          size: 18.r,
                          color: colors.accentGold,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'مَسَارُ التَّعَافِي',
                        style: AppTextStyles.titleMediumOf(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),

                  // Spiritual level pill
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.r),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onTreeTap();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: colors.surfaceElevated,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: colors.accentGold.withValues(alpha: 0.6),
                            width: 1.r,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Iconsax.tree,
                              size: 13.r,
                              color: colors.accentGold,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              levelTitle,
                              style: AppTextStyles.captionOf(context).copyWith(
                                color: colors.accentGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),

              // Streak Days Metric
              Row(
                children: [
                  Text(
                    '$streakDays',
                    style: AppTextStyles.headlineLargeOf(context).copyWith(
                      color: colors.accentGold,
                      fontWeight: FontWeight.w900,
                      fontSize: 32.sp,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'يَوْماً',
                    style: AppTextStyles.titleMediumOf(context).copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      statusText,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.captionOf(context).copyWith(
                        color: colors.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: SizedBox(
                  height: 7.h,
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.05, 1.0),
                    backgroundColor: colors.surfaceElevated,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.accentGold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
