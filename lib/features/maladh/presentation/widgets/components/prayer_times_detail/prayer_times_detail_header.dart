import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Top header for the prayer times detail screen following Sakina design standards.
class PrayerTimesDetailHeader extends StatelessWidget {
  final String cityName;
  final VoidCallback onBackTap;
  final VoidCallback onLocationTap;

  const PrayerTimesDetailHeader({
    super.key,
    required this.cityName,
    required this.onBackTap,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // 1. Back Button (Circular)
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              HapticService.selectionClick();
              onBackTap();
            },
            child: Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: colors.cardSurface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.borderHairline.withValues(alpha: 0.8),
                  width: 1.r,
                ),
              ),
              child: Center(
                child: Icon(
                  Iconsax.arrow_right_3,
                  size: 20.r,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // 2. City / Location Title
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.location5,
                  size: 18.r,
                  color: colors.accentGold,
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    cityName,
                    style: GoogleFonts.cairo(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // 3. Location Selector Action (Circular)
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              HapticService.selectionClick();
              onLocationTap();
            },
            child: Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: colors.cardSurface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.borderHairline.withValues(alpha: 0.8),
                  width: 1.r,
                ),
              ),
              child: Center(
                child: Icon(
                  Iconsax.global,
                  size: 20.r,
                  color: colors.accentGold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

