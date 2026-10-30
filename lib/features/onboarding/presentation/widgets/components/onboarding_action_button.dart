import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

class OnboardingActionButton extends StatelessWidget {
  final String text;
  final bool isLastPage;
  final VoidCallback onPressed;

  const OnboardingActionButton({
    super.key,
    required this.text,
    required this.isLastPage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        height: 54.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE8C86A),
              AppColors.champagneGold,
              Color(0xFFB88E23),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // boxShadow: const [
          //   BoxShadow(
          //     color: AppColors.goldGlowSoft,
          //     blurRadius: 18,
          //     offset: Offset(0, 6),
          //   ),
          // ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (isLastPage) {
                HapticService.heavyImpact();
              } else {
                HapticService.lightImpact();
              }
              onPressed();
            },
            borderRadius: BorderRadius.circular(28.r),
            splashColor: AppColors.paleRadiance.withValues(alpha: 0.3),
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.obsidianCore,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
