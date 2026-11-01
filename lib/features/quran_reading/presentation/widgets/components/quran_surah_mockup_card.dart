import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/utils/surah_metadata_utils.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

/// Surah item grid card matching the user's design reference:
/// - Left: Details Column (Calligraphic Title, Revelation Type & Verse count, Page number)
/// - Right: Clean rounded square capsule containing Surah ID numeral (1, 2, 3...)
/// - Zero play icons as requested by user specifications.
/// - Tactile luxury dark surface with subtle 1px hairline border.
class QuranSurahMockupCard extends StatelessWidget {
  final SurahEntity surah;
  final VoidCallback onTap;

  const QuranSurahMockupCard({
    super.key,
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final calligraphicTitle =
        SurahMetadataUtils.getCalligraphicSurahName(surah.id, surah.nameArabic);

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
                // 1. Left: Surah Metadata Details
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Surah Calligraphic Title (Amiri)
                        Text(
                          calligraphicTitle,
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

                        // Revelation Type & Verses Count
                        Text(
                          '${surah.revelationType}, آياتها : ${surah.versesCount}',
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

                        // Page Number
                        Text(
                          'الصفحة ${surah.pageNumber}',
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

                // 2. Right: Surah Number Capsule (No Play Icon)
                _SurahNumberBox(
                  surahId: surah.id,
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

/// Clean, tactile number capsule for the Surah card.
class _SurahNumberBox extends StatelessWidget {
  final int surahId;
  final AppColorsScheme colors;

  const _SurahNumberBox({
    required this.surahId,
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
          '$surahId',
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
