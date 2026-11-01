import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Top header bar for Athkar sanctuary with back action, title, and reset.
class AthkarHeader extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onResetCategoryTap;

  const AthkarHeader({
    super.key,
    required this.onBackTap,
    required this.onResetCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button (RTL Start)
          GestureDetector(
            onTap: () {
              HapticService.selectionClick();
              onBackTap();
            },
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: colors.cardSurface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.borderHairline,
                  width: 1.r,
                ),
              ),
              child: Center(
                child: Icon(
                  Iconsax.arrow_right_3,
                  size: 18.r,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),

          // Central Sacred Title
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'الأَذْكَارُ وَالمَسَابِحُ',
                style: GoogleFonts.cairo(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: colors.accentGold,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'حِصْنُ المُسْلِمِ وَأَوْرَادُ السَّكِينَةِ',
                style: GoogleFonts.cairo(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),

          // Reset Category Action
          GestureDetector(
            onTap: () {
              HapticService.selectionClick();
              onResetCategoryTap();
            },
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: colors.cardSurface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.borderHairline,
                  width: 1.r,
                ),
              ),
              child: Center(
                child: Icon(
                  Iconsax.rotate_left,
                  size: 18.r,
                  color: colors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

