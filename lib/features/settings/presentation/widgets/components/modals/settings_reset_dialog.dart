import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Confirmation dialog for resetting all application preferences to factory defaults.
abstract final class SettingsResetDialog {
  static Future<bool?> show(BuildContext context) {
    final colors = context.colors;

    return showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: colors.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
            side: BorderSide(
              color: colors.borderHairline.withValues(alpha: 0.8),
              width: 1.r,
            ),
          ),
          title: Row(
            children: [
              Icon(Iconsax.refresh_2, color: colors.accentGold, size: 22.r),
              SizedBox(width: 8.w),
              Text(
                'استعادة الإعدادات الافتراضية',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            'هل تود إعادة تعيين الثيم، لون التمييز الأساسي، وكافة الإعدادات إلى الضبط الأولي للمصنع؟',
            style: GoogleFonts.cairo(
              fontSize: 13.sp,
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(
                  color: colors.textSecondary,
                  fontSize: 13.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentGold,
                foregroundColor: colors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'استعادة الآن',
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
