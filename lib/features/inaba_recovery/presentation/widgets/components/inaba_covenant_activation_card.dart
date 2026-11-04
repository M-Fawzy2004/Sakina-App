import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Sacred activation covenant card displayed before starting the Inaba journey.
class InabaCovenantActivationCard extends StatelessWidget {
  final VoidCallback onActivate;

  const InabaCovenantActivationCard({
    super.key,
    required this.onActivate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: colors.accentGold.withValues(alpha: 0.35),
            width: 1.2.r,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Emblem & Header Badge
            const _ActivationHeaderBadge(),
            SizedBox(height: 14.h),

            // Quranic Ayah of Repentance
            const _ActivationAyahBox(),
            SizedBox(height: 14.h),

            // Explanation / Spiritual Intention
            Text(
              'مسار متدرج يوماً بيوم لتطهير النفس، مجاهدة الهوى، وبناء حصانة إيمانية دائمة، مع تجديد العهد مع أرحم الراحمين.',
              textAlign: TextAlign.center,
              style: GoogleFonts.almarai(
                fontSize: 12.sp,
                color: colors.textSecondary,
                height: 1.6,
              ),
            ),
            SizedBox(height: 18.h),

            // Main Activation Button
            _ActivationButton(onActivate: onActivate),
          ],
        ),
      ),
    );
  }
}

class _ActivationHeaderBadge extends StatelessWidget {
  const _ActivationHeaderBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        Container(
          width: 52.r,
          height: 52.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.accentGold.withValues(alpha: 0.12),
            border: Border.all(
              color: colors.accentGold.withValues(alpha: 0.3),
              width: 1.r,
            ),
          ),
          child: Center(
            child: Icon(
              Iconsax.shield_security,
              size: 26.r,
              color: colors.accentGold,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'عَقْدُ العَزْمِ وَبِدَايَةُ المَسَار',
          style: GoogleFonts.almarai(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _ActivationAyahBox extends StatelessWidget {
  const _ActivationAyahBox();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.surfaceElevated.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.5),
          width: 0.8.r,
        ),
      ),
      child: Column(
        children: [
          Text(
            '«وَتُوبُوا إِلَى اللَّهِ جَمِيعًا أَيُّهَا الْمُؤْمِنُونَ لَعَلَّكُمْ تُفْلِحُونَ»',
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: colors.accentGold,
              height: 1.6,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'سورة النور • آية ٣١',
            style: GoogleFonts.almarai(
              fontSize: 10.sp,
              color: colors.textSecondary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivationButton extends StatelessWidget {
  final VoidCallback onActivate;

  const _ActivationButton({required this.onActivate});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 46.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.accentGold,
          foregroundColor: colors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        onPressed: () {
          HapticFeedback.mediumImpact();
          onActivate();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.flash_1, size: 18.r),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                'اعْقِدِ العَزْمَ وَابْدَأِ المَسَارَ الآن',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
