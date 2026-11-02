import 'package:flutter/material.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_top_bar.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/reader/reader_auto_scroll_control_bar.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/reader/reader_floating_action_bar_overlay.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/reader/reader_page_carousel.dart';

/// Top bar, PageView carousel, auto-scroll bar, and floating action bar container.
class ReaderScaffoldBody extends StatelessWidget {
  final SurahEntity surah;
  final List<AyahEntity> verses;
  final List<SurahEntity> allSurahs;
  final QuranReaderPreferences preferences;
  final PageController pageController;
  final int totalPages;
  final int versesPerPage;
  final int? selectedAyahNumber;
  final int? recitingAyahNumber;
  final bool isAyahAudioPlaying;
  final bool isAyahAudioBuffering;
  final bool isAutoScrollPaused;
  final String pageLabel;
  final AyahEntity activeAyahEntity;
  final ScrollController Function(int pageIndex) getScrollController;
  final List<AyahEntity> Function(int pageIndex) getVersesForPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onAyahTap;
  final ValueChanged<int>? onPlayAyah;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;
  final ValueChanged<bool> onTriggerSurahTransition;
  final ValueChanged<QuranBookmarkEntity> onBookmarkSaved;
  final VoidCallback onClose;
  final VoidCallback onOpenSurahSwitch;
  final VoidCallback onOpenSettings;
  final VoidCallback onToggleAutoScrollPause;
  final ValueChanged<double> onAutoScrollSpeedChanged;
  final VoidCallback onCloseAutoScroll;
  final VoidCallback onTafsir;
  final VoidCallback onCopy;
  final VoidCallback onBookmark;

  const ReaderScaffoldBody({
    super.key,
    required this.surah,
    required this.verses,
    required this.allSurahs,
    required this.preferences,
    required this.pageController,
    required this.totalPages,
    required this.versesPerPage,
    required this.selectedAyahNumber,
    required this.recitingAyahNumber,
    required this.isAyahAudioPlaying,
    required this.isAyahAudioBuffering,
    required this.isAutoScrollPaused,
    required this.pageLabel,
    required this.activeAyahEntity,
    required this.getScrollController,
    required this.getVersesForPage,
    required this.onPageChanged,
    required this.onAyahTap,
    required this.onPlayAyah,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.onTriggerSurahTransition,
    required this.onBookmarkSaved,
    required this.onClose,
    required this.onOpenSurahSwitch,
    required this.onOpenSettings,
    required this.onToggleAutoScrollPause,
    required this.onAutoScrollSpeedChanged,
    required this.onCloseAutoScroll,
    required this.onTafsir,
    required this.onCopy,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final activeTheme = preferences.theme;

    return SafeArea(
      child: Column(
        children: [
          QuranReaderTopBar(
            surah: surah,
            onClose: onClose,
            onOpenSurahSwitch: onOpenSurahSwitch,
            onOpenSettings: onOpenSettings,
            accentColor: activeTheme.accentColor,
            cardColor: activeTheme.cardColor,
          ),
          Expanded(
            child: ReaderPageCarousel(
              pageController: pageController,
              totalPages: totalPages,
              versesPerPage: versesPerPage,
              surah: surah,
              verses: verses,
              allSurahs: allSurahs,
              preferences: preferences,
              selectedAyahNumber: selectedAyahNumber,
              recitingAyahNumber: recitingAyahNumber,
              isAyahAudioPlaying: isAyahAudioPlaying,
              isAyahAudioBuffering: isAyahAudioBuffering,
              getScrollController: getScrollController,
              getVersesForPage: getVersesForPage,
              onPageChanged: onPageChanged,
              onAyahTap: onAyahTap,
              onPlayAyah: onPlayAyah,
              onNextPage: onNextPage,
              onTriggerSurahTransition: onTriggerSurahTransition,
              onBookmarkSaved: onBookmarkSaved,
            ),
          ),
          if (preferences.isAutoScrollEnabled)
            ReaderAutoScrollControlBar(
              isPaused: isAutoScrollPaused,
              accentColor: activeTheme.accentColor,
              cardColor: activeTheme.cardColor,
              textColor: activeTheme.textColor,
              speed: preferences.autoScrollSpeed,
              onTogglePause: onToggleAutoScrollPause,
              onSpeedChanged: onAutoScrollSpeedChanged,
              onClose: onCloseAutoScroll,
            ),
          ReaderFloatingActionBarOverlay(
            selectedAyahNumber: selectedAyahNumber,
            surah: surah,
            pageLabel: pageLabel,
            activeAyahEntity: activeAyahEntity,
            activeTheme: activeTheme,
            isAudioPlaying:
                recitingAyahNumber == activeAyahEntity.numberInSurah &&
                    isAyahAudioPlaying,
            isAudioBuffering:
                recitingAyahNumber == activeAyahEntity.numberInSurah &&
                    isAyahAudioBuffering,
            onPreviousPage: onPreviousPage,
            onNextPage: onNextPage,
            onPlay: () {
              onPlayAyah?.call(activeAyahEntity.numberInSurah);
            },
            onTafsir: onTafsir,
            onCopy: onCopy,
            onBookmark: onBookmark,
          ),
        ],
      ),
    );
  }
}

