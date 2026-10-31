import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Physical 3D Silk Bookmark Ribbon matching Screen 2 in the user's mockup:
/// Protrudes from the right page margin with rich emerald fabric gradient,
/// gold stitched hairline border, and stacked calligraphic text without overflow.
class QuranHangingRibbon extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onToggle;

  const QuranHangingRibbon({
    super.key,
    required this.isBookmarked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.heavyImpact();
        onToggle();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 44.w,
        height: 52.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isBookmarked
                ? const [
                    AppColors.deepSanctuary,
                    AppColors.emeraldGlow,
                    AppColors.deepSanctuary,
                  ]
                : const [
                    AppColors.carbonSlate,
                    AppColors.surfaceElevated,
                    AppColors.carbonSlate,
                  ],
          ),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(8.r),
            right: Radius.circular(4.r),
          ),
          border: Border.all(
            color: isBookmarked
                ? AppColors.champagneGold
                : AppColors.goldBorderStroke,
            width: 1.2.r,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'عَلَامَةُ',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: isBookmarked
                      ? AppColors.pureChalk
                      : AppColors.mutedSilver,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'الحِفْظِ',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: isBookmarked
                      ? AppColors.paleRadiance
                      : AppColors.mutedSilver,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
