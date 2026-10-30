import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

/// Section header for "بَوَّابَاتُ السَّكِينَةِ" with compass emblem and direct access tag.
class MaladhPortalsHeader extends StatelessWidget {
  final VoidCallback? onDirectAccessTap;

  const MaladhPortalsHeader({
    super.key,
    this.onDirectAccessTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Right Side: Compass Navigation Icon + Section Title (RTL Start)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedCompass,
                color: AppColors.champagneGold,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'بَوَّابَاتُ السَّكِينَةِ',
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: 17.sp,
                  color: AppColors.champagneGold,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          // Left Side: "الوصول المباشر" Subtitle / Action (RTL End)
          InkWell(
            onTap: onDirectAccessTap,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Text(
                'الوصول المباشر',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.mutedSilver,
                  fontSize: 11.5.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

