import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Bottom action buttons row for exporting, sharing, and copying the created verse card or video reel.
class VerseCardActionsRow extends StatelessWidget {
  final bool isExporting;
  final bool isVideoMode;
  final VoidCallback onSavePrimary;
  final VoidCallback? onSaveImageSecondary;
  final VoidCallback onShareCard;
  final VoidCallback onCopyText;

  const VerseCardActionsRow({
    super.key,
    required this.isExporting,
    this.isVideoMode = false,
    required this.onSavePrimary,
    this.onSaveImageSecondary,
    required this.onShareCard,
    required this.onCopyText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // 1. Primary Button: Video Export (if video mode) or 4K Image Save
              Expanded(
                flex: 4,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentGold,
                    foregroundColor: colors.background,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  onPressed: isExporting
                      ? null
                      : () {
                          HapticService.selectionClick();
                          onSavePrimary();
                        },
                  icon: isExporting
                      ? SizedBox(
                          width: 14.r,
                          height: 14.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.r,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colors.background,
                            ),
                          ),
                        )
                      : Icon(
                          isVideoMode
                              ? Iconsax.video_tick
                              : Iconsax.document_download,
                          size: 17.r,
                          color: colors.background,
                        ),
                  label: Text(
                    isExporting
                        ? (isVideoMode ? 'جاري إنتاج الفيديو...' : 'جاري التصدير...')
                        : (isVideoMode ? 'تَحْمِيلُ الفِيدْيُو (MP4)' : 'حفظ كصورة 4K'),
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.background,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              // 2. Share Button (Shares MP4 in video mode, PNG otherwise)
              Expanded(
                flex: 3,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.accentGold,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    side: BorderSide(
                      color: colors.accentGold.withValues(alpha: 0.7),
                      width: 1.r,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  onPressed: isExporting
                      ? null
                      : () {
                          HapticService.selectionClick();
                          onShareCard();
                        },
                  icon: Icon(
                    Iconsax.share,
                    size: 16.r,
                    color: colors.accentGold,
                  ),
                  label: Text(
                    isVideoMode ? 'مشاركة ريلز' : 'مشاركة',
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.accentGold,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              // 3. Copy Verse Text Button
              IconButton(
                tooltip: 'نسخ نص الآية',
                style: IconButton.styleFrom(
                  backgroundColor: colors.surfaceElevated,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    side: BorderSide(
                      color: colors.borderHairline,
                      width: 1.r,
                    ),
                  ),
                  padding: EdgeInsets.all(12.r),
                ),
                onPressed: () {
                  HapticService.selectionClick();
                  onCopyText();
                },
                icon: Icon(
                  Iconsax.copy,
                  size: 18.r,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),

          // In Video Mode: Secondary quick action to save frame as static 4K image
          if (isVideoMode && onSaveImageSecondary != null) ...[
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.center,
              child: TextButton.icon(
                onPressed: isExporting
                    ? null
                    : () {
                        HapticService.selectionClick();
                        onSaveImageSecondary!();
                      },
                icon: Icon(
                  Iconsax.image,
                  size: 14.r,
                  color: colors.accentGold,
                ),
                label: Text(
                  'أو حفظ الإطار الحالي كصورة ثابتة 4K',
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.accentGold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
