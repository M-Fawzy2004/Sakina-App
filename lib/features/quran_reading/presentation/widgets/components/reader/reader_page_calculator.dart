import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';

/// Pure algorithmic page partitioning and initial index calculations for Quran Reader.
abstract final class ReaderPageCalculator {
  static int calculateVersesPerPage(int versesCount) {
    if (versesCount <= 25) {
      return versesCount > 0 ? versesCount : 1;
    }
    return 20;
  }

  static int calculateTotalPages(int versesCount) {
    if (versesCount == 0) return 1;
    final perPage = calculateVersesPerPage(versesCount);
    return ((versesCount - 1) ~/ perPage) + 1;
  }

  static List<AyahEntity> getVersesForPage({
    required List<AyahEntity> verses,
    required int pageIndex,
    required int versesPerPage,
  }) {
    final start = pageIndex * versesPerPage;
    if (start >= verses.length) return const [];
    final end = (start + versesPerPage).clamp(0, verses.length);
    return verses.sublist(start, end);
  }

  static int calculateInitialPageIndex({
    required List<AyahEntity> verses,
    required int totalPages,
    required int versesPerPage,
    int? initialAyahNumber,
    int? initialPageNumber,
  }) {
    if (initialAyahNumber != null && initialAyahNumber > 1) {
      if (verses.isNotEmpty) {
        final index = verses.indexWhere(
          (v) => v.numberInSurah == initialAyahNumber,
        );
        if (index >= 0) {
          final target = index ~/ versesPerPage;
          final maxPages = totalPages > 0 ? totalPages - 1 : 0;
          return target.clamp(0, maxPages);
        }
      }
      final target = (initialAyahNumber - 1) ~/ versesPerPage;
      final maxPages = totalPages > 0 ? totalPages - 1 : 0;
      return target.clamp(0, maxPages);
    }

    if (initialPageNumber != null && verses.isNotEmpty) {
      final index = verses.indexWhere(
        (v) => v.page >= initialPageNumber,
      );
      if (index >= 0) {
        final target = index ~/ versesPerPage;
        final maxPages = totalPages > 0 ? totalPages - 1 : 0;
        return target.clamp(0, maxPages);
      }
    }

    return 0;
  }

  static QuranReaderTheme resolveDefaultTheme({
    required bool isDark,
    required bool isEmerald,
    required bool isObsidian,
  }) {
    if (!isDark) return QuranReaderTheme.parchment;
    if (isEmerald) return QuranReaderTheme.emerald;
    if (isObsidian) return QuranReaderTheme.obsidian;
    return QuranReaderTheme.charcoal;
  }
}
