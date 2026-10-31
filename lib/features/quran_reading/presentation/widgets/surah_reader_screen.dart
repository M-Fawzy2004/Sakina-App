import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  const SurahReaderScreen({
    super.key,
    required this.surah,
  });

  /// Opens the Surah reader as a full-screen route covering the bottom navigation bar.
  static Future<void> open(BuildContext context, SurahEntity surah) {
    final cubit = context.read<QuranCubit>();
    cubit.openSurahReader(surah);

    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (navContext) => BlocProvider.value(
          value: cubit,
          child: SurahReaderScreen(surah: surah),
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

          final verses = state.activeVerses;

          return QuranReaderView(
            surah: widget.surah,
            verses: verses,
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
