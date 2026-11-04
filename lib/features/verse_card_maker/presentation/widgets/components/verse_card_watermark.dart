import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Luxury subtle branding watermark for exported cards in Sakina.
/// Placed on the corner without drop shadows.
class VerseCardWatermark extends StatelessWidget {
  final Color? color;

  const VerseCardWatermark({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final brandColor = color ?? colors.accentGold;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: brandColor.withValues(alpha: 0.35),
          width: 0.7.r,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FlutterIslamicIcons.solidCrescentMoon,
            size: 11.r,
            color: brandColor,
          ),
          SizedBox(width: 5.w),
          Text(
            'تطبيق سَكِينَة',
            style: GoogleFonts.cairo(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              color: brandColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

