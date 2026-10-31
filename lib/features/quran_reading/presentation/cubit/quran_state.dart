import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/juz_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

enum QuranTab { page, surahs, juzs, hizbs, bookmarks }

/// Dart 3 sealed class hierarchy for Quran presentation state.
sealed class QuranState extends Equatable {
  const QuranState();

  @override
  List<Object?> get props => [];
}

final class QuranInitial extends QuranState {
  const QuranInitial();
}

final class QuranLoading extends QuranState {
  const QuranLoading();
}

final class QuranLoaded extends QuranState {
  final List<SurahEntity> allSurahs;
  final List<SurahEntity> filteredSurahs;
  final List<JuzEntity> juzs;
  final QuranBookmarkEntity? lastReadBookmark;
  final QuranTab selectedTab;
  final String searchQuery;
  final SurahEntity? activeReadingSurah;
  final List<AyahEntity> activeVerses;

  const QuranLoaded({
    required this.allSurahs,
    required this.filteredSurahs,
    required this.juzs,
    this.lastReadBookmark,
    this.selectedTab = QuranTab.surahs,
    this.searchQuery = '',
    this.activeReadingSurah,
    this.activeVerses = const [],
  });

  QuranLoaded copyWith({
    List<SurahEntity>? allSurahs,
    List<SurahEntity>? filteredSurahs,
    List<JuzEntity>? juzs,
    QuranBookmarkEntity? lastReadBookmark,
    QuranTab? selectedTab,
    String? searchQuery,
    SurahEntity? activeReadingSurah,
    List<AyahEntity>? activeVerses,
    bool clearActiveSurah = false,
  }) {
    return QuranLoaded(
      allSurahs: allSurahs ?? this.allSurahs,
      filteredSurahs: filteredSurahs ?? this.filteredSurahs,
      juzs: juzs ?? this.juzs,
      lastReadBookmark: lastReadBookmark ?? this.lastReadBookmark,
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
      activeReadingSurah: clearActiveSurah ? null : (activeReadingSurah ?? this.activeReadingSurah),
      activeVerses: clearActiveSurah ? const [] : (activeVerses ?? this.activeVerses),
    );
  }

  @override
  List<Object?> get props => [
        allSurahs,
        filteredSurahs,
        juzs,
        lastReadBookmark,
        selectedTab,
        searchQuery,
        activeReadingSurah,
        activeVerses,
      ];
}

final class QuranError extends QuranState {
  final String message;

  const QuranError({required this.message});

  @override
  List<Object?> get props => [message];
}

