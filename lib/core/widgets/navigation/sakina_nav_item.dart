import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
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
    final colors = context.colors;

    return InkWell(
      onTap: () {
        HapticService.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(20.r),
      splashColor: colors.accentGold.withValues(alpha: 0.1),
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon presentation without blurry shadows
              AnimatedScale(
                scale: isSelected ? 1.06 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: iconWidget,
              ),

              SizedBox(height: 2.h),

              // Typography with full Tashkeel, auto scaling down cleanly
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: GoogleFonts.cairo(
                  fontSize: isSelected ? 10.5.sp : 10.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? colors.accentGold : colors.textSecondary,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
