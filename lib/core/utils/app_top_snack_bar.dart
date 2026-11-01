import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

/// Top-anchored floating notification snackbar utility for Sakina.
/// Positions feedback messages gracefully at the top of the viewport (below status bar/notch),
/// avoiding any obstruction of bottom navigation bars or modal sheets.
abstract final class AppTopSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final screenHeight = mediaQuery.size.height;

    // Calculate bottom clearance margin so the floating bar rests comfortably below the status bar
    final topOffset = topPadding + 14.h;
    final bottomMargin = (screenHeight - topOffset - 64.h).clamp(0.0, screenHeight);

    final bg = backgroundColor ?? AppColors.carbonSlate;
    final stroke = borderColor ?? AppColors.champagneGold;
    final fg = textColor ?? AppColors.pureChalk;
    final ico = iconColor ?? stroke;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        backgroundColor: bg,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: EdgeInsets.only(
          bottom: bottomMargin,
          left: 16.w,
          right: 16.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: stroke.withValues(alpha: 0.85), width: 1.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: ico, size: 20.r),
              SizedBox(width: 10.w),
            ],
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.caption.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

