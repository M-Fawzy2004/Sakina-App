import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

class SplashSpiritualQuote extends StatelessWidget {
  final Animation<double> fadeAnimation;

  const SplashSpiritualQuote({
    super.key,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.pureChalk,
                height: 2.2,
                shadows: const [
                  Shadow(
                    color: AppColors.cardShadow,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'سورة الرعد — آية ٢٨',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.paleRadiance,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

