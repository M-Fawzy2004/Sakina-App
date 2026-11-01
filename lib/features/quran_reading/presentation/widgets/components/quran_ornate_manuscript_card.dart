import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_islamic_rosette_badge.dart';

/// Ornate Illuminated Islamic Manuscript Card supporting both:
/// 1. [QuranReadingStyle.verseByVerse]: Classical line-by-line verses with side star rosettes and audio play button
/// 2. [QuranReadingStyle.continuous]: Flowing uninterrupted Mushaf text with inline star badges and recitation glow
class QuranOrnateManuscriptCard extends StatelessWidget {
  final SurahEntity surah;
  final List<AyahEntity> verses;
  final QuranReaderPreferences preferences;
  final int? selectedAyahNumber;
  final ValueChanged<int> onAyahTap;
  final ScrollController? scrollController;
  final int pageIndex;
  final int totalPages;
  final bool showBasmalahOnThisPage;
  final String? verseRangeLabel;
  final String? nextSurahName;
  final VoidCallback? onNextPage;

  // Per-Ayah Audio Playback integration
  final int? recitingAyahNumber;
  final bool isAyahAudioPlaying;
  final bool isAyahAudioBuffering;
  final ValueChanged<int>? onPlayAyah;

  const QuranOrnateManuscriptCard({
    super.key,
    required this.surah,
    required this.verses,
    required this.preferences,
    required this.selectedAyahNumber,
    required this.onAyahTap,
    this.scrollController,
    this.pageIndex = 0,
    this.totalPages = 1,
    this.showBasmalahOnThisPage = true,
    this.verseRangeLabel,
    this.nextSurahName,
    this.onNextPage,
    this.recitingAyahNumber,
    this.isAyahAudioPlaying = false,
    this.isAyahAudioBuffering = false,
    this.onPlayAyah,
  });

  @override
  Widget build(BuildContext context) {
    final showBasmalah = showBasmalahOnThisPage && surah.id != 9;
    final theme = preferences.theme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: theme.accentColor.withValues(alpha: 0.45),
          width: 1.r,
        ),
      ),
      child: ListView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
        children: [
          // Page Indicator Pill (when totalPages > 1)
          if (totalPages > 1 && verseRangeLabel != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: theme.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: theme.accentColor.withValues(alpha: 0.35),
                      width: 0.8.r,
                    ),
                  ),
                  child: Text(
                    '$verseRangeLabel  •  صَفْحَةُ ${pageIndex + 1} مِنْ $totalPages',
                    style: AppTextStyles.caption.copyWith(
                      color: theme.accentColor,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

          // Classical Basmalah Banner with Star Divider
          if (showBasmalah) ...[
            _BasmalahHeader(
              fontSizeDelta: preferences.fontSize.scaleDelta,
              accentColor: theme.accentColor,
            ),
            AppSpacing.verticalMd,
          ],

          // Content switch based on selected reading style
          if (preferences.style == QuranReadingStyle.verseByVerse)
            _VerseByVerseList(
              verses: verses,
              preferences: preferences,
              selectedAyahNumber: selectedAyahNumber,
              recitingAyahNumber: recitingAyahNumber,
              isAyahAudioPlaying: isAyahAudioPlaying,
              isAyahAudioBuffering: isAyahAudioBuffering,
              onAyahTap: onAyahTap,
              onPlayAyah: onPlayAyah,
            )
          else
            _ContinuousManuscriptFlow(
              verses: verses,
              preferences: preferences,
              selectedAyahNumber: selectedAyahNumber,
              recitingAyahNumber: recitingAyahNumber,
              onAyahTap: onAyahTap,
            ),

          // Next Section / Next Surah footer navigation banner
          if (onNextPage != null) ...[
            SizedBox(height: 18.h),
            _NextSectionFooter(
              isLastPageOfSurah: pageIndex >= totalPages - 1,
              nextSurahName: nextSurahName,
              nextPageNumber: pageIndex + 2,
              totalPages: totalPages,
              accentColor: theme.accentColor,
              cardColor: theme.cardColor,
              textColor: theme.textColor,
              onTap: onNextPage!,
            ),
          ],

          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

/// Seamless illuminated footer guiding reader to the next page or next Surah.
class _NextSectionFooter extends StatelessWidget {
  final bool isLastPageOfSurah;
  final String? nextSurahName;
  final int nextPageNumber;
  final int totalPages;
  final Color accentColor;
  final Color cardColor;
  final Color textColor;
  final VoidCallback onTap;

  const _NextSectionFooter({
    required this.isLastPageOfSurah,
    this.nextSurahName,
    required this.nextPageNumber,
    required this.totalPages,
    required this.accentColor,
    required this.cardColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = (isLastPageOfSurah && nextSurahName != null)
        ? 'السُّورَةُ التَّالِيَة: سُورَةُ $nextSurahName'
        : 'الصَّفْحَةُ التَّالِيَة ($nextPageNumber مِنْ $totalPages)';

    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: accentColor.withValues(alpha: 0.15),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.45),
                width: 1.r,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: accentColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Iconsax.arrow_left_2,
                  size: 16.r,
                  color: accentColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Ornate Calligraphic Basmalah Banner with Star Divider.
class _BasmalahHeader extends StatelessWidget {
  final double fontSizeDelta;
  final Color accentColor;

  const _BasmalahHeader({
    required this.fontSizeDelta,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text(
            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            textAlign: TextAlign.center,
            style: AppTextStyles.quranIlluminatedAyah.copyWith(
              fontSize: 25.sp + fontSizeDelta,
              color: accentColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50.w,
              height: 0.8.h,
              color: AppColors.goldBorderStroke.withValues(alpha: 0.4),
            ),
            SizedBox(width: 8.w),
            Icon(
              Iconsax.star_1,
              size: 13.r,
              color: accentColor,
            ),
            SizedBox(width: 8.w),
            Container(
              width: 50.w,
              height: 0.8.h,
              color: AppColors.goldBorderStroke.withValues(alpha: 0.4),
            ),
          ],
        ),
      ],
    );
  }
}

/// Line-by-line verse representation with direct Per-Ayah play button and recitation glow.
class _VerseByVerseList extends StatelessWidget {
  final List<AyahEntity> verses;
  final QuranReaderPreferences preferences;
  final int? selectedAyahNumber;
  final int? recitingAyahNumber;
  final bool isAyahAudioPlaying;
  final bool isAyahAudioBuffering;
  final ValueChanged<int> onAyahTap;
  final ValueChanged<int>? onPlayAyah;

  const _VerseByVerseList({
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

/// Continuous flowing Mushaf scripture with inline Islamic rosette badges
/// and real-time active recitation highlighting ("تظليل الآية التي تُتلى حالياً").
class _ContinuousManuscriptFlow extends StatefulWidget {
  final List<AyahEntity> verses;
  final QuranReaderPreferences preferences;
  final int? selectedAyahNumber;
  final int? recitingAyahNumber;
  final ValueChanged<int> onAyahTap;

  const _ContinuousManuscriptFlow({
    required this.verses,
    required this.preferences,
    required this.selectedAyahNumber,
    required this.recitingAyahNumber,
    required this.onAyahTap,
  });

  @override
  State<_ContinuousManuscriptFlow> createState() =>
      _ContinuousManuscriptFlowState();
}

class _ContinuousManuscriptFlowState extends State<_ContinuousManuscriptFlow> {
  final Map<int, TapGestureRecognizer> _recognizers = {};

  @override
  void initState() {
    super.initState();
    _rebuildRecognizers();
  }

  @override
  void didUpdateWidget(covariant _ContinuousManuscriptFlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.verses != widget.verses ||
        oldWidget.onAyahTap != widget.onAyahTap) {
      _disposeRecognizers();
      _rebuildRecognizers();
    }
  }

  void _rebuildRecognizers() {
    for (final ayah in widget.verses) {
      _recognizers[ayah.numberInSurah] = TapGestureRecognizer()
        ..onTap = () => widget.onAyahTap(ayah.numberInSurah);
    }
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers.values) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.preferences.theme;
    final fontSize = 22.sp + widget.preferences.fontSize.scaleDelta;
    final lineSpacing = widget.preferences.lineSpacing.height;
    final badgeSize =
        (28.r + widget.preferences.fontSize.scaleDelta * 0.9).clamp(24.r, 44.r);

    final spans = <InlineSpan>[];

    for (final ayah in widget.verses) {
      final isSelected = widget.selectedAyahNumber == ayah.numberInSurah;
      final isReciting = widget.recitingAyahNumber == ayah.numberInSurah;
      final recognizer = _recognizers[ayah.numberInSurah];

      // Ayah Text with active recitation highlight
      spans.add(
        TextSpan(
          text: '${ayah.textForStyle(widget.preferences.scriptStyle)} ',
          recognizer: recognizer,
          style: AppTextStyles.quranScriptStyleOf(widget.preferences.scriptStyle)
              .copyWith(
            fontSize: fontSize,
            height: lineSpacing,
            color: (isSelected || isReciting)
                ? theme.accentColor
                : theme.textColor,
            backgroundColor: isReciting
                ? theme.accentColor.withValues(alpha: 0.25)
                : (isSelected
                    ? theme.accentColor.withValues(alpha: 0.18)
                    : Colors.transparent),
            fontWeight:
                (isSelected || isReciting) ? FontWeight.w800 : FontWeight.w700,
          ),
        ),
      );

      // Inline Rosette Badge
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () => widget.onAyahTap(ayah.numberInSurah),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: QuranIslamicRosetteBadge(
                number: ayah.numberInSurah,
                isHighlighted: isSelected || isReciting,
                color: (isSelected || isReciting)
                    ? theme.accentColor
                    : theme.accentColor.withValues(alpha: 0.9),
                backgroundColor: theme.cardColor,
                size: badgeSize,
              ),
            ),
          ),
        ),
      );

      spans.add(const TextSpan(text: ' '));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text.rich(
          TextSpan(children: spans),
          textAlign: TextAlign.justify,
          strutStyle: StrutStyle(
            fontSize: fontSize,
            height: lineSpacing,
            forceStrutHeight: true,
          ),
        ),
      ),
    );
  }
}
