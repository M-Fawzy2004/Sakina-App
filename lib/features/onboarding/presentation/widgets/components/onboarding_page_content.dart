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
        // 1. Luxury Floating Arched Artwork Card
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            height: imageHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.obsidianCore,
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(
                color: AppColors.goldBorderStroke,
                width: 1.2.r,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26.8.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    item.imageAsset,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.high,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 50.h,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.obsidianCore.withValues(alpha: 0.60),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 2. Centered Sacred Typography
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
                    fontSize: 24.sp,
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.pureChalk.withValues(alpha: 0.88),
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
