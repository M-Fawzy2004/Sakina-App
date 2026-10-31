import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/core/utils/arabic_text_utils.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_juzs_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_last_read_bookmark_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_surah_verses_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_surahs_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/save_last_read_bookmark_usecase.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_state.dart';

/// Cubit managing state transitions for Quran catalog and reader views.
class QuranCubit extends Cubit<QuranState> {
  final GetSurahsUseCase getSurahsUseCase;
  final GetJuzsUseCase getJuzsUseCase;
  final GetSurahVersesUseCase getSurahVersesUseCase;
  final GetLastReadBookmarkUseCase getLastReadBookmarkUseCase;
  final SaveLastReadBookmarkUseCase saveLastReadBookmarkUseCase;

  QuranCubit({
    required this.getSurahsUseCase,
    required this.getJuzsUseCase,
    required this.getSurahVersesUseCase,
    required this.getLastReadBookmarkUseCase,
    required this.saveLastReadBookmarkUseCase,
  }) : super(const QuranInitial());

  /// Loads the initial Quran dataset (all 114 Surahs, 30 Juzs, and last bookmark).
  Future<void> loadQuranData() async {
    emit(const QuranLoading());

    final surahsResult = await getSurahsUseCase(const NoParams());
    final juzsResult = await getJuzsUseCase(const NoParams());
    final bookmarkResult = await getLastReadBookmarkUseCase(const NoParams());

    surahsResult.fold(
      (failure) => emit(QuranError(message: failure.message)),
      (surahs) {
        final juzs = juzsResult.getOrElse((_) => const []);
        final bookmark = bookmarkResult.getOrElse((_) => null);

        emit(QuranLoaded(
          allSurahs: surahs,
          filteredSurahs: surahs,
          juzs: juzs,
          lastReadBookmark: bookmark,
        ));
      },
    );
  }

  /// Filters Surahs in real-time by Arabic name, English name, or Surah number.
  void searchSurahs(String query) {
    final currentState = state;
    if (currentState is! QuranLoaded) return;

    final trimmed = query.trim().toLowerCase();
    final normalizedQuery = ArabicTextUtils.normalize(query);

    if (trimmed.isEmpty) {
      emit(currentState.copyWith(
        filteredSurahs: currentState.allSurahs,
        searchQuery: '',
      ));
      return;
    }

    final filtered = currentState.allSurahs.where((surah) {
      final normalizedAr = ArabicTextUtils.normalize(surah.nameArabic);
      final nameArMatch = normalizedAr.contains(normalizedQuery);
      final nameEnMatch = surah.englishName.toLowerCase().contains(trimmed);
      final idMatch = surah.id.toString() == trimmed;
      return nameArMatch || nameEnMatch || idMatch;
    }).toList();

    emit(currentState.copyWith(
      filteredSurahs: filtered,
      searchQuery: query,
    ));
  }

  /// Switches active catalog tab (Surahs, Juzs, Bookmarks).
  void selectTab(QuranTab tab) {
    final currentState = state;
    if (currentState is! QuranLoaded) return;
    emit(currentState.copyWith(selectedTab: tab));
  }

  /// Opens the reader view for a chosen Surah, loading its verses.
  Future<void> openSurahReader(SurahEntity surah) async {
    final currentState = state;
    if (currentState is! QuranLoaded) return;

    final versesResult = await getSurahVersesUseCase(
      GetSurahVersesParams(surahId: surah.id),
    );

    versesResult.fold(
      (_) {
        // Fallback with empty verses
        emit(currentState.copyWith(
          activeReadingSurah: surah,
          activeVerses: const [],
        ));
      },
      (verses) {
        emit(currentState.copyWith(
          activeReadingSurah: surah,
          activeVerses: verses,
        ));
      },
    );
  }

  /// Closes the reader view, returning to the catalog index.
  void closeSurahReader() {
    final currentState = state;
    if (currentState is! QuranLoaded) return;
    emit(currentState.copyWith(clearActiveSurah: true));
  }

  /// Saves the current reading bookmark and updates state.
  Future<void> saveBookmark(QuranBookmarkEntity bookmark) async {
    final currentState = state;
    if (currentState is! QuranLoaded) return;

    await saveLastReadBookmarkUseCase(
      SaveLastReadBookmarkParams(bookmark: bookmark),
    );

    emit(currentState.copyWith(lastReadBookmark: bookmark));
  }
}
