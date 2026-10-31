import 'package:flutter/material.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/juz_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/juz_tile.dart';

/// Slivers of 30 Juzs with smooth scroll.
class QuranJuzsList extends StatelessWidget {
  final List<JuzEntity> juzs;
  final List<SurahEntity> allSurahs;
  final ValueChanged<JuzEntity> onJuzTap;

  const QuranJuzsList({
    super.key,
    required this.juzs,
    required this.allSurahs,
    required this.onJuzTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final juz = juzs[index];
          return JuzTile(juz: juz, onTap: () => onJuzTap(juz));
        },
        childCount: juzs.length,
      ),
    );
  }
}

