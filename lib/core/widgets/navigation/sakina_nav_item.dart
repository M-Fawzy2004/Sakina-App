import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

class SakinaNavItem extends StatelessWidget {
  final String label;
  final Widget iconWidget;
  final bool isSelected;
  final VoidCallback onTap;

  const SakinaNavItem({
    super.key,
    required this.label,
    required this.iconWidget,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticService.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(20.r),
      splashColor: AppColors.goldGlowSoft,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon presentation without blurry shadows
            AnimatedScale(
              scale: isSelected ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: iconWidget,
            ),

            SizedBox(height: 5.h),

            // Typography with full Tashkeel
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: isSelected ? 11.5.sp : 11.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.champagneGold : AppColors.mutedSilver,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
