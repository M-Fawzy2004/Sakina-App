import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';

/// Standard 114 Surah verse counts (Hafs recitation)
const List<int> kQuranSurahVerseCounts = [
  7, 286, 200, 176, 120, 165, 206, 75, 129, 109, // 1-10
  123, 111, 43, 52, 99, 128, 111, 110, 98, 135, // 11-20
  112, 78, 118, 64, 77, 227, 93, 88, 69, 60, // 21-30
  34, 30, 73, 54, 45, 83, 182, 88, 75, 85, // 31-40
  54, 53, 89, 59, 37, 35, 38, 29, 18, 45, // 41-50
  60, 49, 62, 55, 78, 96, 29, 22, 24, 13, // 51-60
  14, 11, 11, 18, 12, 12, 30, 52, 52, 44, // 61-70
  28, 28, 20, 56, 40, 31, 50, 40, 46, 42, // 71-80
  29, 19, 36, 25, 22, 17, 19, 26, 30, 20, // 81-90
  15, 21, 11, 8, 8, 19, 5, 8, 8, 11, // 91-100
  11, 8, 3, 9, 5, 4, 7, 3, 6, 3, // 101-110
  5, 4, 5, 6 // 111-114
];

/// "Resume Reading / مواصلة القراءة" Hero Card:
/// Faithfully calculates and displays accurate reading progress relative to the Surah:
/// - Real-time progress percentage calculated as (ayahNumber / totalSurahVerses)
/// - Left-aligned metadata: "Resume Reading", "مواصلة القراءة", Surah title, and Ayah/Page position
/// - Right-side swallowtail notched emerald ribbon hanging from top edge
/// - Metallic gold progress ring showing the calculated arc and percentage
class QuranResumeReadingHero extends StatelessWidget {
  final QuranBookmarkEntity? bookmark;
  final VoidCallback onResumeTap;
  final int? totalSurahVerses;

  const QuranResumeReadingHero({
    super.key,
    required this.bookmark,
    required this.onResumeTap,
    this.totalSurahVerses,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surahName = bookmark?.surahName ?? 'سُورَةُ الكَهْفِ';

    // Calculate exact progress relative to the Surah
    final surahId = bookmark?.surahId ?? 18;
    final totalVerses = totalSurahVerses ??
        ((surahId >= 1 && surahId <= 114)
            ? kQuranSurahVerseCounts[surahId - 1]
            : 110);
    final currentAyah = (bookmark?.ayahNumber ?? 1).clamp(1, totalVerses);
    final progress = (currentAyah / totalVerses).clamp(0.01, 1.0);
    final percent = (progress * 100).round();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // The Tactile Hero Card
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticService.selectionClick();
                  onResumeTap();
                },
                borderRadius: BorderRadius.circular(22.r),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20.w, 18.h, 24.w, 18.h),
                  decoration: BoxDecoration(
                    color: colors.cardSurface,
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(
                      color: colors.borderHairline,
                      width: 1.2.r,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Left Column: Resume Reading, مواصلة القراءة, Surah name, Ayah metadata
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Resume Reading',
                              style: AppTextStyles.caption.copyWith(
                                color: colors.accentGold,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5.sp,
                                letterSpacing: 0.4,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'مُوَاصَلَةُ القِرَاءَةِ',
                              style: AppTextStyles.caption.copyWith(
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              surahName,
                              style: AppTextStyles.headlineLarge.copyWith(
                                color: colors.textPrimary,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'الآية $currentAyah من $totalVerses',
                                  style: GoogleFonts.cairo(
                                    color: colors.accentGold,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (bookmark != null && bookmark!.pageNumber > 0) ...[
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                                    child: Container(
                                      width: 3.5.r,
                                      height: 3.5.r,
                                      decoration: BoxDecoration(
                                        color: colors.textSecondary.withValues(alpha: 0.4),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'صفحة ${bookmark!.pageNumber}',
                                    style: GoogleFonts.cairo(
                                      color: colors.textSecondary,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Right Column: Metallic Gold Progress Ring (directly below the ribbon)
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h, right: 4.w),
                        child: _MetallicProgressRing(
                          progress: progress,
                          percentText: '$percent%',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Hanging Silk Bookmark Ribbon with Swallowtail Notch (top-right corner)
            Positioned(
              top: -8.h,
              right: 28.w,
              child: _SwallowtailRibbon(
                onTap: () {
                  HapticService.selectionClick();
                  onResumeTap();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Metallic gold circular progress ring with centered percentage text matching reference design.
class _MetallicProgressRing extends StatelessWidget {
  final double progress;
  final String percentText;

  const _MetallicProgressRing({
    required this.progress,
    required this.percentText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: 48.r,
      height: 48.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 3.2.r,
            backgroundColor: colors.surfaceElevated,
            valueColor: AlwaysStoppedAnimation<Color>(
              colors.accentGold,
            ),
          ),
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: colors.cardSurface,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              percentText,
              style: GoogleFonts.cairo(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: colors.accentGold,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hanging emerald silk ribbon with swallowtail V-notch cutout and gold hairline stitched border.
class _SwallowtailRibbon extends StatelessWidget {
  final VoidCallback onTap;

  const _SwallowtailRibbon({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ribbonWidth = 32.w;
    final ribbonHeight = 54.h;

    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _RibbonBorderPainter(
          ribbonColor: colors.accentEmerald,
          borderColor: colors.accentGold,
        ),
        size: Size(ribbonWidth, ribbonHeight),
      ),
    );
  }
}

/// Precise CustomPainter for swallowtail notched ribbon with gold border.
class _RibbonBorderPainter extends CustomPainter {
  final Color ribbonColor;
  final Color borderColor;

  const _RibbonBorderPainter({
    required this.ribbonColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final notchDepth = 12.h;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h)
      ..lineTo(w / 2, h - notchDepth)
      ..lineTo(0, h)
      ..close();

    // 1. Fill emerald silk ribbon
    final fillPaint = Paint()
      ..color = ribbonColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 2. Stroke gold hairline border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0.r;
    canvas.drawPath(path, borderPaint);

    // 3. Subtle vertical center crease highlight for silky depth
    final creasePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0.r;
    canvas.drawLine(
      Offset(w / 2, 2.h),
      Offset(w / 2, h - notchDepth),
      creasePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RibbonBorderPainter oldDelegate) {
    return oldDelegate.ribbonColor != ribbonColor ||
        oldDelegate.borderColor != borderColor;
  }
}
