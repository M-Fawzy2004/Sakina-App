import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/juz_entity.dart';

/// Quranic Juz grid card matching the 2-column Surah mockup style:
/// - Left: Details Column (Juz Title in Amiri, Start Surah & Ayah, Page span)
/// - Right: Clean rounded square capsule containing Juz ID numeral (1 to 30)
/// - Zero play icons, luxury dark surface with subtle 1px hairline border.
class JuzTile extends StatelessWidget {
  final JuzEntity juz;
  final VoidCallback onTap;

  const JuzTile({
    super.key,
    required this.juz,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(16.r),
        highlightColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: colors.borderHairline.withValues(alpha: 0.65),
              width: 1.r,
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                // 1. Left: Juz Metadata Details
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Juz Title (Amiri Calligraphy)
                        Text(
                          juz.nameArabic,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.amiri(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                            height: 1.25,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Starting Surah & Ayah
                        Text(
                          'سُورَةُ ${juz.startSurahName} • آية ${juz.startVerseNumber}',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 2.h),

                        // Page Span
                        Text(
                          'الصفحة ${juz.startPageNumber} - ${juz.endPageNumber}',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary.withValues(alpha: 0.85),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 8.w),

                // 2. Right: Juz Number Capsule (No Play Icon)
                _JuzNumberBox(
                  juzId: juz.id,
                  colors: colors,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Clean, tactile number capsule for the Juz card.
class _JuzNumberBox extends StatelessWidget {
  final int juzId;
  final AppColorsScheme colors;

  const _JuzNumberBox({
    required this.juzId,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.5),
          width: 0.8.r,
        ),
      ),
      child: Center(
        child: Text(
          '$juzId',
          style: GoogleFonts.cairo(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 12.5.sp,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
