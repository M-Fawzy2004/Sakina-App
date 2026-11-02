import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Draggable bar at the top of the modal player.
class PlayerTopDragBar extends StatelessWidget {
  final VoidCallback onTap;

  const PlayerTopDragBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.lightImpact();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        alignment: Alignment.center,
        child: Container(
          width: 38.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: AppColors.mutedSilver.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }
}

/// Top App Bar for audio player with back navigation, status title, and settings shortcut.
class PlayerTopAppBar extends StatelessWidget {
  final bool isLive;
  final VoidCallback onBackTap;
  final VoidCallback onSettingsTap;

  const PlayerTopAppBar({
    super.key,
    required this.isLive,
    required this.onBackTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              HapticService.lightImpact();
              onBackTap();
            },
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.cardSurface,
                border: Border.all(
                  color: colors.borderHairline,
                  width: 1.r,
                ),
              ),
              child: Icon(
                Iconsax.arrow_right_3,
                color: colors.accentGold,
                size: 20.r,
              ),
            ),
          ),
          if (isLive)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7.r,
                  height: 7.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.errorRed,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'بث مباشر • الحرمين الشريفين',
                  style: GoogleFonts.cairo(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'مشغل التلاوة',
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  '🌙',
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          GestureDetector(
            onTap: () {
              HapticService.lightImpact();
              onSettingsTap();
            },
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.cardSurface,
                border: Border.all(
                  color: colors.borderHairline,
                  width: 1.r,
                ),
              ),
              child: Icon(
                Iconsax.setting_2,
                color: colors.accentGold,
                size: 19.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

