import 'package:flutter/material.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_ornate_manuscript_card.dart';

/// Full-height horizontal PageView carousel for flipping Quran pages with overscroll detection.
class ReaderPageCarousel extends StatelessWidget {
  final PageController pageController;
  final int totalPages;
  final int versesPerPage;
  final SurahEntity surah;
  final List<AyahEntity> verses;
  final List<SurahEntity> allSurahs;
  final QuranReaderPreferences preferences;
  final int? selectedAyahNumber;
  final int? recitingAyahNumber;
  final bool isAyahAudioPlaying;
  final bool isAyahAudioBuffering;
  final ScrollController Function(int pageIndex) getScrollController;
  final List<AyahEntity> Function(int pageIndex) getVersesForPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onAyahTap;
  final ValueChanged<int>? onPlayAyah;
  final VoidCallback onNextPage;
  final ValueChanged<bool> onTriggerSurahTransition;
  final ValueChanged<QuranBookmarkEntity> onBookmarkSaved;

  const ReaderPageCarousel({
    super.key,
    required this.pageController,
    required this.totalPages,
    required this.versesPerPage,
    required this.surah,
    required this.verses,
    required this.allSurahs,
    required this.preferences,
    required this.selectedAyahNumber,
    required this.recitingAyahNumber,
    required this.isAyahAudioPlaying,
    required this.isAyahAudioBuffering,
    required this.getScrollController,
    required this.getVersesForPage,
    required this.onPageChanged,
    required this.onAyahTap,
    required this.onPlayAyah,
    required this.onNextPage,
    required this.onTriggerSurahTransition,
    required this.onBookmarkSaved,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is OverscrollNotification) {
          if (notification.overscroll.abs() > 30) {
            if (pageController.page?.round() == totalPages - 1) {
              onTriggerSurahTransition(true);
              return true;
            } else if (pageController.page?.round() == 0) {
              onTriggerSurahTransition(false);
              return true;
            }
          }
        }
        return false;
      },
      child: PageView.builder(
        controller: pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: totalPages,
        onPageChanged: (newIndex) {
          HapticService.selectionClick();
          onPageChanged(newIndex);
          final pageVerses = getVersesForPage(newIndex);
          final activeAyah = pageVerses.isNotEmpty
              ? pageVerses.first.numberInSurah
              : (newIndex * versesPerPage + 1);
          onBookmarkSaved(
            QuranBookmarkEntity(
              surahId: surah.id,
              surahName: surah.nameArabic,
              ayahNumber: activeAyah,
              pageNumber: surah.pageNumber,
              timestamp: DateTime.now(),
            ),
          );
        },
        itemBuilder: (context, pageIndex) {
          final pageVerses = getVersesForPage(pageIndex);
          final isFirstPage = pageIndex == 0;
          final startVerseNum = pageIndex * versesPerPage + 1;
          final endVerseNum = (startVerseNum + pageVerses.length - 1).clamp(
            startVerseNum,
            verses.length,
          );

          final currentSurahIdx = allSurahs.indexWhere(
            (s) => s.id == surah.id,
          );
          final nextSurah = (currentSurahIdx >= 0 &&
                  currentSurahIdx < allSurahs.length - 1)
              ? allSurahs[currentSurahIdx + 1]
              : null;

          return QuranOrnateManuscriptCard(
            surah: surah,
            verses: pageVerses,
            preferences: preferences,
            selectedAyahNumber: selectedAyahNumber,
            onAyahTap: onAyahTap,
            scrollController: getScrollController(pageIndex),
            pageIndex: pageIndex,
            totalPages: totalPages,
            showBasmalahOnThisPage: isFirstPage,
            verseRangeLabel: totalPages > 1
                ? 'الآيَاتُ $startVerseNum - $endVerseNum'
                : null,
            nextSurahName: nextSurah?.nameArabic,
            onNextPage: onNextPage,
            recitingAyahNumber: recitingAyahNumber,
            isAyahAudioPlaying: isAyahAudioPlaying,
            isAyahAudioBuffering: isAyahAudioBuffering,
            onPlayAyah: onPlayAyah,
          );
        },
      ),
    );
  }
}

