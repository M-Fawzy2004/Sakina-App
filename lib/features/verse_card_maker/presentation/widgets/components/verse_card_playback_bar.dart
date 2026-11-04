import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/services/everyayah_audio_url_builder.dart';

/// Playback and recitation control bar for the Verse Card Maker.
/// Allows instant switching between the 5 official reciters and navigating verses.
class VerseCardPlaybackBar extends StatelessWidget {
  final EveryAyahReciter selectedReciter;
  final bool isPlaying;
  final bool isLoadingAudio;
  final VoidCallback onTogglePlay;
  final VoidCallback onNextAyah;
  final VoidCallback onPreviousAyah;
  final ValueChanged<EveryAyahReciter> onReciterChanged;

  const VerseCardPlaybackBar({
    super.key,
    required this.selectedReciter,
    required this.isPlaying,
    required this.isLoadingAudio,
    required this.onTogglePlay,
    required this.onNextAyah,
    required this.onPreviousAyah,
    required this.onReciterChanged,
  });

  void _showReciterPicker(BuildContext context) {
    HapticService.selectionClick();
    final colors = context.colors;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: colors.borderHairline,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'اختر قارئ التلاوة للبطاقة:',
                  style: GoogleFonts.cairo(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                ...EveryAyahReciter.availableReciters.map((reciter) {
                  final isSelected = reciter.id == selectedReciter.id;
                  return InkWell(
                    onTap: () {
                      HapticService.selectionClick();
                      onReciterChanged(reciter);
                      Navigator.of(ctx).pop();
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 11.h,
                      ),
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.accentGold.withValues(alpha: 0.12)
                            : colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? colors.accentGold
                              : colors.borderHairline.withValues(alpha: 0.5),
                          width: isSelected ? 1.4.r : 0.8.r,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                size: 16.r,
                                color: isSelected
                                    ? colors.accentGold
                                    : colors.textSecondary,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                reciter.nameArabic,
                                style: GoogleFonts.cairo(
                                  fontSize: 12.5.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? colors.accentGold
                                      : colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            reciter.englishName,
                            style: GoogleFonts.cairo(
                              fontSize: 10.sp,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.7),
          width: 0.8.r,
        ),
      ),
      child: Row(
        children: [
          // Previous Ayah button
          IconButton(
            tooltip: 'الآية السابقة',
            onPressed: () {
              HapticService.selectionClick();
              onPreviousAyah();
            },
            icon: Icon(
              Iconsax.arrow_right_3,
              size: 18.r,
              color: colors.textPrimary,
            ),
          ),

          // Play / Pause recitation button
          InkWell(
            onTap: () {
              HapticService.selectionClick();
              onTogglePlay();
            },
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: colors.accentGold,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isLoadingAudio
                    ? SizedBox(
                        width: 16.r,
                        height: 16.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.r,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colors.background,
                          ),
                        ),
                      )
                    : Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        size: 22.r,
                        color: colors.background,
                      ),
              ),
            ),
          ),

          // Next Ayah button
          IconButton(
            tooltip: 'الآية التالية',
            onPressed: () {
              HapticService.selectionClick();
              onNextAyah();
            },
            icon: Icon(
              Iconsax.arrow_left_2,
              size: 18.r,
              color: colors.textPrimary,
            ),
          ),

          const Spacer(),

          // Reciter selection chip
          InkWell(
            onTap: () => _showReciterPicker(context),
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: colors.accentGold.withValues(alpha: 0.45),
                  width: 0.8.r,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.user_tag,
                    size: 13.r,
                    color: colors.accentGold,
                  ),
                  SizedBox(width: 5.w),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 110.w),
                    child: Text(
                      selectedReciter.nameArabic,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 14.r,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

