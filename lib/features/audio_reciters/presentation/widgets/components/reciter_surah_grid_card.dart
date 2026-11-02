import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/quran_local_data_source.dart';

/// 2-Column Responsive Card for Surahs matching the user's Quran section mockup:
/// - Left: Details Column (Calligraphic Surah Title, Revelation type & Verse count, Page number)
/// - Right: Rounded Square Capsule with Surah ID number on top + Play/Pause icon underneath
/// - Direct audio listening with tactile feedback and zero drop-shadows
class ReciterSurahGridCard extends StatelessWidget {
  final RecitationTrackEntity track;
  final bool isCurrentlyPlaying;
  final VoidCallback onTap;

  const ReciterSurahGridCard({
    super.key,
    required this.track,
    required this.isCurrentlyPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surahMetadata = (track.surahId >= 1 && track.surahId <= 114)
        ? QuranLocalDataSourceImpl.allSurahs[track.surahId - 1]
        : null;

    final revelationType = surahMetadata?.revelationType ?? 'مكية';
    final versesCount = surahMetadata?.versesCount ?? 0;
    final pageNumber = surahMetadata?.pageNumber ?? 1;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isCurrentlyPlaying
                ? colors.surfaceElevated
                : colors.cardSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isCurrentlyPlaying
                  ? colors.accentGold
                  : colors.borderHairline.withValues(alpha: 0.65),
              width: isCurrentlyPlaying ? 1.5.r : 1.r,
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                // 1. Left: Details Column (Calligraphic Title, Revelation Type & Verse Count, Page Number)
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
                          track.surahNameArabic,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.amiri(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: isCurrentlyPlaying
                                ? colors.accentGold
                                : colors.textPrimary,
                            height: 1.25,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Revelation Type & Verses Count
                        Text(
                          '$revelationType، آياتها : $versesCount',
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
                          'الصفحة $pageNumber',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary.withValues(alpha: 0.8),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 8.w),

                // 2. Right: Surah ID number capsule + Audio Play/Pause indicator
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: isCurrentlyPlaying
                            ? colors.accentGold.withValues(alpha: 0.2)
                            : colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isCurrentlyPlaying
                              ? colors.accentGold
                              : colors.borderHairline.withValues(alpha: 0.6),
                          width: 1.r,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${track.surahId}',
                        style: GoogleFonts.cairo(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                          color: isCurrentlyPlaying
                              ? colors.accentGold
                              : colors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Icon(
                      isCurrentlyPlaying ? Iconsax.pause5 : Iconsax.play5,
                      size: 13.r,
                      color: isCurrentlyPlaying
                          ? colors.accentGold
                          : colors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

