import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

class InabaQuranicHopeCard extends StatelessWidget {
  const InabaQuranicHopeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: colors.borderHairline,
              width: 1.r,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top rosette accent
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32.w,
                    height: 1.h,
                    color: colors.accentGold.withValues(alpha: 0.4),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    FlutterIslamicIcons.quran2,
                    size: 16.r,
                    color: colors.accentGold,
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 32.w,
                    height: 1.h,
                    color: colors.accentGold.withValues(alpha: 0.4),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // The Sacred Verse (Centered & Clear)
              Text(
                '﴿ قُلْ يَا عِبَادِيَ الَّذِينَ أَسْرَفُوا عَلَىٰ أَنفُسِهِمْ لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ ۚ إِنَّ اللَّهَ يَغْفِرُ الذُّنُوبَ جَمِيعًا ۚ إِنَّهُ هُوَ الْغَفُورُ الرَّحِيمُ ﴾',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: AppTextStyles.quranAyahOf(context).copyWith(
                  fontSize: 19.sp,
                  height: 2.1,
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.h),

              // Surah reference
              Text(
                'سُورَةُ الزُّمَرِ • الآيَةُ ٥٣',
                textAlign: TextAlign.center,
                style: AppTextStyles.captionOf(context).copyWith(
                  color: colors.accentGold,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
