import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Dignified Dialog displaying Developer contact details and collaboration inquiries.
abstract final class SettingsDeveloperContactDialog {
  static void show(BuildContext context) {
    HapticService.selectionClick();
    final colors = context.colors;

    showDialog<void>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: colors.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: BorderSide(
              color: colors.borderHairline.withValues(alpha: 0.8),
              width: 1.r,
            ),
          ),
          title: Row(
            children: [
              Icon(Iconsax.user_tag, color: colors.accentGold, size: 22.r),
              SizedBox(width: 8.w),
              Text(
                'مُطَوِّرُ التَّطْبِيقِ',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'المهندس محمد فوزي (Mohamed Fawzy)',
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.accentGold,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'متاح لاستقبال الاستفسارات والمقترحات والتعاون البرمجي في تطوير التطبيقات والمشاريع التقنية:',
                style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  color: colors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.borderHairline.withValues(alpha: 0.5),
                    width: 0.8.r,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Iconsax.sms, size: 16.r, color: colors.accentGold),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: SelectableText(
                            'mohamedfawzydev27@gmail.com',
                            style: GoogleFonts.cairo(
                              fontSize: 11.5.sp,
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Iconsax.call, size: 16.r, color: colors.accentGold),
                        SizedBox(width: 8.w),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: SelectableText(
                            '+20 106 880 5663',
                            style: GoogleFonts.cairo(
                              fontSize: 12.sp,
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'إِغْلَاق',
                style: GoogleFonts.cairo(
                  color: colors.textSecondary,
                  fontSize: 13.sp,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(
                  const ClipboardData(
                    text:
                        'المهندس محمد فوزي\nالبريد: mohamedfawzydev27@gmail.com\nهاتف/واتساب: +201068805663',
                  ),
                );
                Navigator.of(ctx).pop();
                AppTopSnackBar.showSuccess(
                  context: context,
                  message: 'تم نسخ بيانات التواصل بنجاح',
                );
              },
              icon: Icon(Iconsax.copy, size: 16.r),
              label: Text(
                'نَسْخُ البَيَانَاتِ',
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentGold,
                foregroundColor: colors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
