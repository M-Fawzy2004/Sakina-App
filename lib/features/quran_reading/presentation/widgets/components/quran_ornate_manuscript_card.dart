import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_islamic_rosette_badge.dart';

/// Ornate Illuminated Islamic Manuscript Card supporting both:
/// 1. [QuranReadingStyle.verseByVerse]: Classical line-by-line verses with side star rosettes
/// 2. [QuranReadingStyle.continuous]: Flowing uninterrupted Mushaf text with inline star badges
class QuranOrnateManuscriptCard extends StatelessWidget {
  final SurahEntity surah;
  final List<AyahEntity> verses;
  final QuranReaderPreferences preferences;
  final int? selectedAyahNumber;
  final ValueChanged<int> onAyahTap;
  final ScrollController? scrollController;

  const QuranOrnateManuscriptCard({
    super.key,
    required this.surah,
    required this.verses,
    required this.preferences,
    required this.selectedAyahNumber,
    required this.onAyahTap,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final showBasmalah = surah.id != 9 && surah.id != 1;
    final theme = preferences.theme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: theme.accentColor.withValues(alpha: 0.75),
          width: 1.2.r,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.goldBorderStroke.withValues(alpha: 0.35),
            width: 0.8.r,
          ),
        ),
        child: ListView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          children: [
            // Classical Basmalah Banner with Star Divider
            if (showBasmalah || surah.id == 1) ...[
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
                onAyahTap: onAyahTap,
              )
            else
              _ContinuousManuscriptFlow(
                verses: verses,
                preferences: preferences,
                selectedAyahNumber: selectedAyahNumber,
                onAyahTap: onAyahTap,
              ),

            SizedBox(height: 12.h),
          ],
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

/// Line-by-line verse representation matching the initial layout screenshot.
class _VerseByVerseList extends StatelessWidget {
  final List<AyahEntity> verses;
  final QuranReaderPreferences preferences;
  final int? selectedAyahNumber;
  final ValueChanged<int> onAyahTap;

  const _VerseByVerseList({
    required this.verses,
    required this.preferences,
    required this.selectedAyahNumber,
    required this.onAyahTap,
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
            onTap: () => onAyahTap(ayah.numberInSurah),
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

/// Single Verse row in line-by-line mode.
class _AyahRow extends StatelessWidget {
  final AyahEntity ayah;
  final QuranReaderPreferences preferences;
  final bool isSelected;
  final VoidCallback onTap;

  const _AyahRow({
    required this.ayah,
    required this.preferences,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = preferences.theme;

    return Material(
      color: isSelected
          ? theme.accentColor.withValues(alpha: 0.16)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        splashColor: AppColors.goldGlowSoft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ornate Golden 8-Pointed Star Badge («①»)
                QuranIslamicRosetteBadge(
                  number: ayah.numberInSurah,
                  isHighlighted: isSelected,
                  color: isSelected ? theme.accentColor : theme.accentColor.withValues(alpha: 0.9),
                  backgroundColor: theme.cardColor,
                  size: 38.r,
                ),

                // Illuminated Calligraphic Arabic Scripture
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      ayah.text,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.quranIlluminatedAyah.copyWith(
                        fontSize: 22.sp + preferences.fontSize.scaleDelta,
                        color: isSelected
                            ? theme.accentColor
                            : theme.textColor,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
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

/// Continuous flowing Mushaf scripture with inline Islamic rosette badges.
/// Manages gesture recognizer lifecycle cleanly to prevent any memory leaks.
class _ContinuousManuscriptFlow extends StatefulWidget {
  final List<AyahEntity> verses;
  final QuranReaderPreferences preferences;
  final int? selectedAyahNumber;
  final ValueChanged<int> onAyahTap;

  const _ContinuousManuscriptFlow({
    required this.verses,
    required this.preferences,
    required this.selectedAyahNumber,
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

    final spans = <InlineSpan>[];

    for (final ayah in widget.verses) {
      final isSelected = widget.selectedAyahNumber == ayah.numberInSurah;
      final recognizer = _recognizers[ayah.numberInSurah];

      // Ayah Text
      spans.add(
        TextSpan(
          text: '${ayah.text} ',
          recognizer: recognizer,
          style: AppTextStyles.quranIlluminatedAyah.copyWith(
            fontSize: fontSize,
            height: lineSpacing,
            color: isSelected ? theme.accentColor : theme.textColor,
            backgroundColor: isSelected
                ? theme.accentColor.withValues(alpha: 0.22)
                : Colors.transparent,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
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
                isHighlighted: isSelected,
                color: isSelected ? theme.accentColor : theme.accentColor.withValues(alpha: 0.9),
                backgroundColor: theme.cardColor,
                size: 26.r,
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
