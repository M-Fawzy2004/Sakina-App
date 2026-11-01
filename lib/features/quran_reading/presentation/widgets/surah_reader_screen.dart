import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_cubit.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_state.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_view.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_shimmer.dart';

/// Dedicated Full-Screen Surah Reader Sanctuary Screen.
/// Pushed on the Root Navigator above the bottom navigation bar to provide
/// a completely immersive 100% full-screen reading experience with 3D page curl physics.
class SurahReaderScreen extends StatefulWidget {
  final SurahEntity surah;
  final int? initialAyahNumber;
  final int? initialPageNumber;

  const SurahReaderScreen({
    super.key,
    required this.surah,
    this.initialAyahNumber,
    this.initialPageNumber,
  });

  /// Opens the Surah reader as a full-screen route covering the bottom navigation bar.
  static Future<void> open(
    BuildContext context,
    SurahEntity surah, {
    int? initialAyahNumber,
    int? initialPageNumber,
    QuranCubit? cubit,
  }) {
    QuranCubit effectiveCubit;
    try {
      effectiveCubit = cubit ?? context.read<QuranCubit>();
    } catch (_) {
      effectiveCubit = sl<QuranCubit>();
    }
    effectiveCubit.openSurahReader(surah);

    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (navContext) => BlocProvider<QuranCubit>.value(
          value: effectiveCubit,
          child: SurahReaderScreen(
            surah: surah,
            initialAyahNumber: initialAyahNumber,
            initialPageNumber: initialPageNumber,
          ),
        ),
      ),
    );
  }

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<QuranCubit>().openSurahReader(widget.surah);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuranCubit>();

    return Scaffold(
      backgroundColor: AppColors.obsidianCore,
      body: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          if (state is! QuranLoaded) {
            return const QuranShimmer();
          }

          final activeSurah = state.activeReadingSurah ?? widget.surah;
          final verses = state.activeVerses;

          return QuranReaderView(
            surah: activeSurah,
            verses: verses,
            allSurahs: state.allSurahs,
            initialAyahNumber: widget.initialAyahNumber,
            initialPageNumber: widget.initialPageNumber,
            recitingAyahNumber: state.recitingAyahNumber,
            isAyahAudioPlaying: state.isAyahAudioPlaying,
            isAyahAudioBuffering: state.isAyahAudioBuffering,
            onPlayAyah: (ayahNumber) {
              cubit.toggleAyahAudio(
                surahNumber: activeSurah.id,
                ayahNumber: ayahNumber,
              );
            },
            onStopAyah: () => cubit.stopAyahAudio(),
            onSurahChanged: (newSurah) => cubit.openSurahReader(newSurah),
            onClose: () {
              cubit.closeSurahReader();
              Navigator.of(context).pop();
            },
            onBookmarkSaved: (bookmark) => cubit.saveBookmark(bookmark),
          );
        },
      ),
    );
  }
}
