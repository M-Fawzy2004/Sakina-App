import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Interactive tactile pill displaying the user's continuous spiritual streak
/// with authentic Eastern Arabic numerals without blurry drop shadows.
class MaladhStreakBadge extends StatelessWidget {
  final int streakDays;
  final VoidCallback? onTap;

  const MaladhStreakBadge({
    super.key,
    required this.streakDays,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.selectionClick();
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(20.r),
        splashColor: AppColors.goldGlowSoft,
        highlightColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.frostedGlass,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.goldBorderStroke,
              width: 1.r,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedSparkles,
                color: AppColors.champagneGold,
                size: 15.r,
              ),
              SizedBox(width: 5.w),
              Text(
                '$streakDays أَيَّامٍ',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.paleRadiance,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
