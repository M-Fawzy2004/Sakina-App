import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/manuscript/quran_continuous_manuscript_flow.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/manuscript/quran_manuscript_header_footer.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/manuscript/quran_verse_by_verse_list.dart';

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
            QuranBasmalahHeader(
              fontSizeDelta: preferences.fontSize.scaleDelta,
              accentColor: theme.accentColor,
            ),
            AppSpacing.verticalMd,
          ],

          // Content switch based on selected reading style
          if (preferences.style == QuranReadingStyle.verseByVerse)
            QuranVerseByVerseList(
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
            QuranContinuousManuscriptFlow(
              verses: verses,
              preferences: preferences,
              selectedAyahNumber: selectedAyahNumber,
              recitingAyahNumber: recitingAyahNumber,
              onAyahTap: onAyahTap,
            ),

          // Next Section / Next Surah footer navigation banner
          if (onNextPage != null) ...[
            SizedBox(height: 18.h),
            QuranNextSectionFooter(
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
