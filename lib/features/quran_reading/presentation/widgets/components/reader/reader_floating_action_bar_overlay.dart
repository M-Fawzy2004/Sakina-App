import 'package:flutter/material.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_floating_bar.dart';

/// Animated floating stadium action bar overlay that animates into view when an Ayah is selected.
class ReaderFloatingActionBarOverlay extends StatelessWidget {
  final int? selectedAyahNumber;
  final SurahEntity surah;
  final String pageLabel;
  final AyahEntity activeAyahEntity;
  final QuranReaderTheme activeTheme;
  final bool isAudioPlaying;
  final bool isAudioBuffering;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final VoidCallback onPlay;
  final VoidCallback onTafsir;
  final VoidCallback onCopy;
  final VoidCallback onBookmark;

  const ReaderFloatingActionBarOverlay({
    super.key,
    required this.selectedAyahNumber,
    required this.surah,
    required this.pageLabel,
    required this.activeAyahEntity,
    required this.activeTheme,
    required this.isAudioPlaying,
    required this.isAudioBuffering,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onPlay,
    required this.onTafsir,
    required this.onCopy,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.4),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: selectedAyahNumber != null
          ? QuranReaderFloatingBar(
              key: const ValueKey('floating_bar_visible'),
              pageNumber: surah.pageNumber,
              juzNumber: surah.juzNumber,
              pageLabel: pageLabel,
              selectedAyahNumber: selectedAyahNumber,
              onPreviousPage: onPreviousPage,
              onNextPage: onNextPage,
              onPlay: onPlay,
              isAudioPlaying: isAudioPlaying,
              isAudioBuffering: isAudioBuffering,
              onTafsir: onTafsir,
              onCopy: onCopy,
              onBookmark: onBookmark,
              accentColor: activeTheme.accentColor,
              cardColor: activeTheme.cardColor,
            )
          : const SizedBox.shrink(
              key: ValueKey('floating_bar_hidden'),
            ),
    );
  }
}

