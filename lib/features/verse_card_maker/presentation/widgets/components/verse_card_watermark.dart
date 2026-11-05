import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Luxury subtle, light branding watermark for exported cards and video reels in Sakina.
/// Designed borderless with soft shadow and delicate opacity for professional reel aesthetic.
class VerseCardWatermark extends StatelessWidget {
  final Color? color;

  const VerseCardWatermark({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final brandColor = (color ?? colors.accentGold).withValues(alpha: 0.75);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
            'سَكِينَة',
            style: GoogleFonts.cairo(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              color: brandColor,
              letterSpacing: 0.4,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.8),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

