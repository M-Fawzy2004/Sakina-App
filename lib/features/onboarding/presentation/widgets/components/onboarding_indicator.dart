import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 26.w : 7.w,
          height: 7.h,
          decoration: BoxDecoration(
            color: isActive ? AppColors.champagneGold : AppColors.carbonSlate,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isActive
                  ? AppColors.paleRadiance
                  : AppColors.goldBorderStroke,
              width: 1.r,
            ),
          ),
        );
      }),
    );
  }
}

