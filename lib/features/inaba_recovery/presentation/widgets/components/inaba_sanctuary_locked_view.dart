import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

/// Locked state view for the Inaba Confession Sanctuary with unlock biometric/action trigger.
class InabaSanctuaryLockedView extends StatelessWidget {
  final VoidCallback onUnlock;

  const InabaSanctuaryLockedView({
    super.key,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88.r,
            height: 88.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surfaceElevated,
              border: Border.all(
                color: colors.accentGold,
                width: 2.r,
              ),
            ),
            child: Center(
              child: Icon(
                Iconsax.lock,
                size: 40.r,
                color: colors.accentGold,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'محرابك محمي ومشفّر',
            style: AppTextStyles.titleMediumOf(context).copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 17.sp,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'هنا مساحتك الخاصة لتفريغ ما في صدرك، ومحاسبة النفس بصدق بين يدي خالقك.',
              textAlign: TextAlign.center,
              style: AppTextStyles.captionOf(context).copyWith(
                color: colors.textSecondary,
                fontSize: 12.sp,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Unlock Button
          SizedBox(
            width: 220.w,
            height: 48.h,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentGold,
                foregroundColor: colors.background,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                onUnlock();
              },
              icon: Icon(
                Iconsax.finger_scan,
                size: 20.r,
                color: colors.background,
              ),
              label: Text(
                'فَتْحُ المِحْرَابِ',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.background,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Reassurance Verse
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colors.borderHairline,
                width: 1.r,
              ),
            ),
            child: Text(
              '﴿ وَمَا كَانَ اللَّهُ مُعَذِّبَهُمْ وَهُمْ يَسْتَغْفِرُونَ ﴾',
              style: AppTextStyles.quranAyahOf(context).copyWith(
                color: colors.accentGold,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

