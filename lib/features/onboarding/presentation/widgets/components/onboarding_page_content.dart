import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/features/onboarding/domain/entities/onboarding_item.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingItem item;
  final double imageHeight;

  const OnboardingPageContent({
    super.key,
    required this.item,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Full-Width & Extended Height Static Image (No animation, pure native resolution)
        ClipRect(
          child: SizedBox(
            width: double.infinity,
            height: imageHeight,
            child: Image.asset(
              item.imageAsset,
              fit: BoxFit.cover,
              width: double.infinity,
              height: imageHeight,
              alignment: Alignment.topCenter,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),

        // 2. Centered Sacred Typography (Dynamically fills remaining space)
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.champagneGold,
                    height: 1.3,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  item.subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.pureChalk.withValues(alpha: 0.90),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
