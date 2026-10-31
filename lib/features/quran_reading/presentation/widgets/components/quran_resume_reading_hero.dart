import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';

/// "Resume Reading / مواصلة القراءة" Hero Card:
/// Faithfully reproduces the exact visual design from the user's reference screenshot:
/// - Frosted charcoal/gold bordered card
/// - Left-aligned text: "Resume Reading", "مواصلة القراءة", and calligraphic Surah title
/// - Right-side swallowtail notched emerald ribbon hanging from the top edge
/// - Metallic gold progress ring positioned on the right directly below the ribbon
/// - No redundant carousel dots indicator (single card layout)
class QuranResumeReadingHero extends StatelessWidget {
  final QuranBookmarkEntity? bookmark;
  final VoidCallback onResumeTap;

  const QuranResumeReadingHero({
    super.key,
    required this.bookmark,
    required this.onResumeTap,
  });

  @override
  Widget build(BuildContext context) {
    final surahName = bookmark?.surahName ?? 'سُورَةُ الكَهْفِ';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // The Frosted Hero Card
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticService.selectionClick();
                  onResumeTap();
                },
                borderRadius: BorderRadius.circular(22.r),
                splashColor: AppColors.goldGlowSoft,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20.w, 18.h, 24.w, 18.h),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(
                      color: AppColors.goldBorderStroke,
                      width: 1.2.r,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Left Column: Resume Reading, مواصلة القراءة, سورة الكهف
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Resume Reading',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.paleRadiance,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5.sp,
                                letterSpacing: 0.4,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'مُوَاصَلَةُ القِرَاءَةِ',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.mutedSilver,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              surahName,
                              style: AppTextStyles.headlineLarge.copyWith(
                                color: AppColors.pureChalk,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right Column: Metallic Gold Progress Ring (directly below the ribbon)
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h, right: 4.w),
                        child: const _MetallicProgressRing(progress: 0.72),
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

/// Metallic gold circular progress ring matching the reference mockup.
class _MetallicProgressRing extends StatelessWidget {
  final double progress;

  const _MetallicProgressRing({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.r,
      height: 48.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 3.2.r,
            backgroundColor: AppColors.carbonSlate,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.champagneGold,
            ),
          ),
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: AppColors.carbonSlate.withValues(alpha: 0.4),
              shape: BoxShape.circle,
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
    final ribbonWidth = 32.w;
    final ribbonHeight = 54.h;

    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _RibbonBorderPainter(
          borderColor: AppColors.champagneGold,
          borderWidth: 1.r,
          notchDepth: 10.h,
        ),
        child: ClipPath(
          clipper: _RibbonClipper(notchDepth: 10.h),
          child: Container(
            width: ribbonWidth,
            height: ribbonHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.emeraldGlow,
                  AppColors.deepSanctuary,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom clipper to cut an inverted V (swallowtail) into the ribbon base.
class _RibbonClipper extends CustomClipper<Path> {
  final double notchDepth;

  const _RibbonClipper({required this.notchDepth});

  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width / 2, size.height - notchDepth)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant _RibbonClipper oldClipper) =>
      oldClipper.notchDepth != notchDepth;
}

/// Custom painter to draw the gold perimeter border around the swallowtail ribbon.
class _RibbonBorderPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final double notchDepth;

  const _RibbonBorderPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.notchDepth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width / 2, size.height - notchDepth)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RibbonBorderPainter oldDelegate) =>
      oldDelegate.borderColor != borderColor ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.notchDepth != notchDepth;
}
