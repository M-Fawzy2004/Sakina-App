import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/hizb_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

/// 2-Column Responsive Grid of 60 Hizbs for Quran reading with authentic start verses and pages:
/// - 2 columns per row matching the Surahs and Juzs card layout
/// - Responsive gutter spacing with ScreenUtil tokens
/// - Tactile luxury dark surface with subtle 1px hairline border
class QuranHizbsList extends StatelessWidget {
  final List<SurahEntity> allSurahs;
  final ValueChanged<HizbEntity> onHizbTap;

  const QuranHizbsList({
    super.key,
    required this.allSurahs,
    required this.onHizbTap,
  });

  @override
  Widget build(BuildContext context) {
    const hizbs = HizbEntity.allHizbs;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          mainAxisExtent: 96.h,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final hizb = hizbs[index];
            return _HizbTile(
              hizb: hizb,
              onTap: () => onHizbTap(hizb),
            );
          },
          childCount: hizbs.length,
        ),
      ),
    );
  }
}

class _HizbTile extends StatelessWidget {
  final HizbEntity hizb;
  final VoidCallback onTap;

  const _HizbTile({
    required this.hizb,
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
                // 1. Left: Hizb Metadata Details
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hizb Title (Amiri Calligraphy)
                        Text(
                          'الحِزْبُ ${hizb.number}',
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

                        // Surah & Verse
                        Text(
                          'سُورَةُ ${hizb.surahName} • آية ${hizb.startVerseNumber}',
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

                        // Juz & Page
                        Text(
                          'الجُزْءُ ${hizb.juzNumber} • الصفحة ${hizb.startPageNumber}',
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

                // 2. Right: Hizb Number Capsule (No Play Icon)
                _HizbNumberBox(
                  hizbNumber: hizb.number,
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

/// Clean, tactile number capsule for the Hizb card.
class _HizbNumberBox extends StatelessWidget {
  final int hizbNumber;
  final AppColorsScheme colors;

  const _HizbNumberBox({
    required this.hizbNumber,
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
          '$hizbNumber',
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
