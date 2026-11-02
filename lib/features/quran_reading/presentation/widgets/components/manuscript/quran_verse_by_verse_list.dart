import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_islamic_rosette_badge.dart';

/// Line-by-line verse representation with direct Per-Ayah play button and recitation glow.
class QuranVerseByVerseList extends StatelessWidget {
  final List<AyahEntity> verses;
  final QuranReaderPreferences preferences;
  final int? selectedAyahNumber;
  final int? recitingAyahNumber;
  final bool isAyahAudioPlaying;
  final bool isAyahAudioBuffering;
  final ValueChanged<int> onAyahTap;
  final ValueChanged<int>? onPlayAyah;

  const QuranVerseByVerseList({
    super.key,
    required this.verses,
    required this.preferences,
    required this.selectedAyahNumber,
    required this.recitingAyahNumber,
    required this.isAyahAudioPlaying,
    required this.isAyahAudioBuffering,
    required this.onAyahTap,
    this.onPlayAyah,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final ayah in verses) ...[
          _AyahRow(
            ayah: ayah,
            preferences: preferences,
            isSelected: selectedAyahNumber == ayah.numberInSurah,
            isReciting: recitingAyahNumber == ayah.numberInSurah,
            isRecitingPlaying:
                recitingAyahNumber == ayah.numberInSurah && isAyahAudioPlaying,
            isRecitingBuffering: recitingAyahNumber == ayah.numberInSurah &&
                isAyahAudioBuffering,
            onTap: () => onAyahTap(ayah.numberInSurah),
            onPlay: onPlayAyah != null
                ? () => onPlayAyah!(ayah.numberInSurah)
                : null,
          ),
          if (preferences.showDividers)
            Divider(
              color: AppColors.goldBorderStroke.withValues(alpha: 0.22),
              height: 1.h,
              thickness: 0.6.r,
              indent: 10.w,
              endIndent: 10.w,
            ),
        ],
      ],
    );
  }
}

/// Single Verse row in line-by-line mode featuring dedicated Per-Ayah audio player.
class _AyahRow extends StatelessWidget {
  final AyahEntity ayah;
  final QuranReaderPreferences preferences;
  final bool isSelected;
  final bool isReciting;
  final bool isRecitingPlaying;
  final bool isRecitingBuffering;
  final VoidCallback onTap;
  final VoidCallback? onPlay;

  const _AyahRow({
    required this.ayah,
    required this.preferences,
    required this.isSelected,
    required this.isReciting,
    required this.isRecitingPlaying,
    required this.isRecitingBuffering,
    required this.onTap,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = preferences.theme;

    final badgeSize =
        (36.r + preferences.fontSize.scaleDelta * 0.9).clamp(30.r, 48.r);

    return Material(
      color: isReciting
          ? theme.accentColor.withValues(alpha: 0.22)
          : (isSelected
              ? theme.accentColor.withValues(alpha: 0.14)
              : Colors.transparent),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        splashColor: AppColors.goldGlowSoft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Ornate Golden 8-Pointed Star Badge («①»)
                QuranIslamicRosetteBadge(
                  number: ayah.numberInSurah,
                  isHighlighted: isSelected || isReciting,
                  color: (isSelected || isReciting)
                      ? theme.accentColor
                      : theme.accentColor.withValues(alpha: 0.9),
                  backgroundColor: theme.cardColor,
                  size: badgeSize,
                ),

                SizedBox(width: 8.w),

                // 2. Direct Per-Ayah Audio Play/Pause Button
                if (onPlay != null) ...[
                  _AyahAudioButton(
                    isReciting: isReciting,
                    isPlaying: isRecitingPlaying,
                    isBuffering: isRecitingBuffering,
                    accentColor: theme.accentColor,
                    onPlay: onPlay!,
                  ),
                  SizedBox(width: 8.w),
                ],

                // 3. Illuminated Calligraphic Arabic Scripture
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      ayah.textForStyle(preferences.scriptStyle),
                      textAlign: TextAlign.right,
                      style: AppTextStyles.quranScriptStyleOf(
                              preferences.scriptStyle)
                          .copyWith(
                        fontSize: 22.sp + preferences.fontSize.scaleDelta,
                        color: (isSelected || isReciting)
                            ? theme.accentColor
                            : theme.textColor,
                        fontWeight: (isSelected || isReciting)
                            ? FontWeight.w800
                            : FontWeight.w700,
                        height: preferences.lineSpacing.height,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tactile circular play button for individual verses.
class _AyahAudioButton extends StatelessWidget {
  final bool isReciting;
  final bool isPlaying;
  final bool isBuffering;
  final Color accentColor;
  final VoidCallback onPlay;

  const _AyahAudioButton({
    required this.isReciting,
    required this.isPlaying,
    required this.isBuffering,
    required this.accentColor,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isPlaying ? 'إيقاف مؤقت للتلاوة' : 'تشغيل تلاوة الآية',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticService.selectionClick();
            onPlay();
          },
          customBorder: const CircleBorder(),
          splashColor: accentColor.withValues(alpha: 0.2),
          child: Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isReciting
                  ? accentColor.withValues(alpha: 0.18)
                  : Colors.transparent,
              border: Border.all(
                color: isReciting
                    ? accentColor
                    : accentColor.withValues(alpha: 0.35),
                width: 1.r,
              ),
            ),
            child: Center(
              child: isBuffering
                  ? SizedBox(
                      width: 14.r,
                      height: 14.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.6.r,
                        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                      ),
                    )
                  : Icon(
                      isPlaying ? Iconsax.pause : Iconsax.play,
                      size: 15.r,
                      color: isReciting
                          ? accentColor
                          : accentColor.withValues(alpha: 0.8),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

