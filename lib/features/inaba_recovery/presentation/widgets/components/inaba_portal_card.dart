import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

class InabaPortalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? badgeText;
  final VoidCallback onTap;

  const InabaPortalCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: colors.borderHairline,
                width: 1.r,
              ),
            ),
            child: Row(
              children: [
                // Icon Box
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: colors.accentGold.withValues(alpha: 0.3),
                      width: 1.r,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 22.r,
                      color: colors.accentGold,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  AppTextStyles.titleMediumOf(context).copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          if (badgeText != null) ...[
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: colors.surfaceElevated,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color:
                                      colors.accentGold.withValues(alpha: 0.5),
                                  width: 0.8.r,
                                ),
                              ),
                              child: Text(
                                badgeText!,
                                style: AppTextStyles.captionOf(context).copyWith(
                                  fontSize: 9.sp,
                                  color: colors.accentGold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.captionOf(context).copyWith(
                          color: colors.textSecondary,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // Trailing Arrow
                Icon(
                  Iconsax.arrow_left_2,
                  size: 16.r,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
