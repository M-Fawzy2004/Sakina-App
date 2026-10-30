import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/features/onboarding/domain/entities/onboarding_item.dart';
import 'package:sakina_app/features/onboarding/presentation/widgets/components/onboarding_floating_artwork.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPageContent({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 1. Elegantly Sized 3D Levitating Artwork with Golden Pulse
        OnboardingFloatingArtwork(
          imageAsset: item.imageAsset,
        ),

        SizedBox(height: 28.h),

        // 2. High-Contrast Modern Arabic Title with Full Tashkeel (Enlarged & Bold)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            item.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 30.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.champagneGold,
              height: 1.35,
              letterSpacing: 0.3,
            ),
          ),
        ),

        SizedBox(height: 14.h),

        // 3. Subtitle Description (Enlarged by one degree for luxury readability)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.pureChalk.withValues(alpha: 0.88),
              height: 1.65,
            ),
          ),
        ),
      ],
    );
  }
}
