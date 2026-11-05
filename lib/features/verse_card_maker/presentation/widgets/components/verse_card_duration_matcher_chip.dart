import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/verse_card_maker/domain/entities/verse_card_item.dart';

/// Interactive banner displayed when a video background is selected,
/// syncing the video's running duration with the reciter's ayah recitation (max 30 seconds).
class VerseCardDurationMatcherChip extends StatelessWidget {
  final int videoDurationSeconds;
  final VerseCardItem currentVerse;
  final VoidCallback onAutoMatchVerse;
  final VoidCallback? onPickAyahRange;

  const VerseCardDurationMatcherChip({
    super.key,
    required this.videoDurationSeconds,
    required this.currentVerse,
    required this.onAutoMatchVerse,
    this.onPickAyahRange,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveSec = videoDurationSeconds > 30 ? 30 : videoDurationSeconds;
    final diff = (effectiveSec - currentVerse.durationSeconds).abs();
    final isHarmonious = diff <= 4;
    final isOverLimit = videoDurationSeconds > 30;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isHarmonious
                ? colors.accentGold.withValues(alpha: 0.5)
                : colors.borderHairline,
            width: 1.r,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isHarmonious ? Iconsax.video_tick : Iconsax.video_time,
              size: 16.r,
              color: isHarmonious ? colors.accentGold : colors.textSecondary,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'فيديو ريلز: $effectiveSec ث',
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                      children: [
                        TextSpan(
                          text: isOverLimit
                              ? ' (مقتطع حتى 30ث) • '
                              : ' (أقصى 30ث) • ',
                          style: TextStyle(
                            color: isOverLimit
                                ? colors.accentGold
                                : colors.textSecondary,
                            fontSize: 9.5.sp,
                            fontWeight: isOverLimit
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          text: 'التلاوة: ~${currentVerse.durationSeconds}ث',
                          style: GoogleFonts.cairo(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.accentGold,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    isHarmonious
                        ? 'متطابق بامتياز مع ريلز وتيك توك (حتى 30 ثانية)'
                        : 'يمكنك توفيق الآية لتناسب طول الفيديو تلقائياً',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      fontSize: 10.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onPickAyahRange != null) ...[
                  GestureDetector(
                    onTap: () {
                      HapticService.selectionClick();
                      onPickAyahRange!();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: colors.accentGold,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'اخْتِيَارُ الآيَاتِ',
                        style: GoogleFonts.cairo(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          color: colors.background,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                ],
                GestureDetector(
                  onTap: () {
                    HapticService.selectionClick();
                    onAutoMatchVerse();
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: colors.accentGold.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: colors.accentGold.withValues(alpha: 0.6),
                        width: 0.8.r,
                      ),
                    ),
                    child: Text(
                      'تَوْفِيقُ الآيَة',
                      style: GoogleFonts.cairo(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: colors.accentGold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
