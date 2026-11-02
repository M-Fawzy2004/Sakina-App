import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Dedicated Prominent Reset to Defaults Card.
class SettingsResetCard extends StatelessWidget {
  final VoidCallback onResetTap;

  const SettingsResetCard({
    super.key,
    required this.onResetTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.selectionClick();
          onResetTap();
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: colors.borderHairline.withValues(alpha: 0.65),
              width: 1.r,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.borderHairline,
                    width: 0.8.r,
                  ),
                ),
                child: Icon(
                  Iconsax.rotate_left,
                  color: colors.accentGold,
                  size: 20.r,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اسْتِعَادَةُ الإِعْدَادَاتِ الاِفْتِرَاضِيَّةِ',
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'إرجاع الثيم ولون التمييز وكافة التفضيلات إلى الضبط الأولي',
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: colors.borderHairline,
                    width: 0.8.r,
                  ),
                ),
                child: Text(
                  'اسْتِعَادَة',
                  style: GoogleFonts.cairo(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.accentGold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

