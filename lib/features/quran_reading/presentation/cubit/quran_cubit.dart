import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sakina_app/core/services/audio/audio_player_handler.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/core/utils/arabic_text_utils.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/services/everyayah_audio_url_builder.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_juzs_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_last_read_bookmark_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_surah_verses_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_surahs_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/save_last_read_bookmark_usecase.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_state.dart';

/// Cubit managing state transitions for Quran catalog and reader views,
/// as well as Per-Ayah audio streaming via the EveryAyah CDN.
class QuranCubit extends Cubit<QuranState> {
  final GetSurahsUseCase getSurahsUseCase;
  final GetJuzsUseCase getJuzsUseCase;
  final GetSurahVersesUseCase getSurahVersesUseCase;
  final GetLastReadBookmarkUseCase getLastReadBookmarkUseCase;
  final SaveLastReadBookmarkUseCase saveLastReadBookmarkUseCase;
  final AudioPlayerHandler audioPlayerHandler;

  StreamSubscription<PlayerState>? _playerStateSubscription;

  QuranCubit({
    required this.getSurahsUseCase,
    required this.getJuzsUseCase,
    required this.getSurahVersesUseCase,
    required this.getLastReadBookmarkUseCase,
    required this.saveLastReadBookmarkUseCase,
    required this.audioPlayerHandler,
  }) : super(const QuranInitial()) {
    _initAudioStreams();
  }

  void _initAudioStreams() {
    _playerStateSubscription =
        audioPlayerHandler.playerStateStream.listen((playerState) {
      final currentState = state;
      if (currentState is! QuranLoaded) return;
      if (currentState.recitingAyahNumber == null) return;

      final isPlaying = playerState.playing;
      final isBuffering =
          playerState.processingState == ProcessingState.buffering ||
              playerState.processingState == ProcessingState.loading;
      final isCompleted =
          playerState.processingState == ProcessingState.completed;

      if (isCompleted) {
        _onAyahAudioCompleted();
      } else {
        emit(currentState.copyWith(
          isAyahAudioPlaying: isPlaying,
          isAyahAudioBuffering: isBuffering,
        ));
      }
    });
  }

  void _onAyahAudioCompleted() {
    final currentState = state;
    if (currentState is! QuranLoaded) return;
    final activeSurah = currentState.activeReadingSurah;
    final currentAyah = currentState.recitingAyahNumber;

    if (activeSurah != null &&
        currentAyah != null &&
        currentState.activeVerses.isNotEmpty) {
      // Find the next consecutive Ayah in the active Surah
      final nextAyahIndex = currentState.activeVerses.indexWhere(
        (a) => a.numberInSurah == currentAyah + 1,
      );

      if (nextAyahIndex != -1) {
        final nextAyah = currentState.activeVerses[nextAyahIndex];
        playAyahAudio(
          surahNumber: activeSurah.id,
          ayahNumber: nextAyah.numberInSurah,
        );
        return;
      }
    }

    // Finished last verse of the active Surah
    stopAyahAudio();
  }

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

    if (currentState.activeReadingSurah?.id == surah.id &&
        currentState.activeVerses.isNotEmpty) {
      return;
    }

    // Stop any ongoing recitation when switching/opening Surahs
    if (currentState.recitingAyahNumber != null) {
      await stopAyahAudio();
    }

    final versesResult = await getSurahVersesUseCase(
      GetSurahVersesParams(surahId: surah.id),
    );

    final latestState = state;
    if (latestState is! QuranLoaded) return;

    versesResult.fold(
      (_) {
        // Fallback with empty verses
        emit(latestState.copyWith(
          activeReadingSurah: surah,
          activeVerses: const [],
        ));
      },
      (verses) {
        emit(latestState.copyWith(
          activeReadingSurah: surah,
          activeVerses: verses,
        ));
      },
    );
  }

  /// Closes the reader view, returning to the catalog index and halting audio.
  void closeSurahReader() {
    stopAyahAudio();
    final currentState = state;
    if (currentState is! QuranLoaded) return;
    emit(currentState.copyWith(
      clearActiveSurah: true,
      clearRecitingAyah: true,
    ));
  }

  /// Plays the direct EveryAyah CDN audio stream for the given Ayah.
  Future<void> playAyahAudio({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final currentState = state;
    if (currentState is! QuranLoaded) return;

    final url = EveryAyahAudioUrlBuilder.buildUrl(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: currentState.activeReciterId,
    );

    emit(currentState.copyWith(
      recitingAyahNumber: ayahNumber,
      isAyahAudioPlaying: true,
      isAyahAudioBuffering: true,
    ));

    try {
      await audioPlayerHandler.stop();
      await audioPlayerHandler.setAudioUrl(url);
      await audioPlayerHandler.play();
    } catch (_) {
      final updatedState = state;
      if (updatedState is QuranLoaded) {
        emit(updatedState.copyWith(
          clearRecitingAyah: true,
          isAyahAudioPlaying: false,
          isAyahAudioBuffering: false,
        ));
      }
    }
  }

  /// Toggles playback: plays if stopped/different ayah, pauses if playing, resumes if paused.
  Future<void> toggleAyahAudio({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final currentState = state;
    if (currentState is! QuranLoaded) return;

    if (currentState.recitingAyahNumber == ayahNumber) {
      if (currentState.isAyahAudioPlaying) {
        await pauseAyahAudio();
      } else {
        await resumeAyahAudio();
      }
    } else {
      await playAyahAudio(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
      );
    }
  }

  /// Pauses the current Ayah recitation without losing position.
  Future<void> pauseAyahAudio() async {
    final currentState = state;
    if (currentState is! QuranLoaded) return;

    try {
      await audioPlayerHandler.pause();
    } catch (_) {}

    emit(currentState.copyWith(isAyahAudioPlaying: false));
  }

  /// Resumes the paused Ayah recitation.
  Future<void> resumeAyahAudio() async {
    final currentState = state;
    if (currentState is! QuranLoaded) return;

    try {
      await audioPlayerHandler.play();
      emit(currentState.copyWith(isAyahAudioPlaying: true));
    } catch (_) {
      if (currentState.activeReadingSurah != null &&
          currentState.recitingAyahNumber != null) {
        await playAyahAudio(
          surahNumber: currentState.activeReadingSurah!.id,
          ayahNumber: currentState.recitingAyahNumber!,
        );
      }
    }
  }

  /// Halts the Ayah audio stream and clears the reciting Ayah highlight.
  Future<void> stopAyahAudio() async {
    final currentState = state;
    if (currentState is! QuranLoaded) return;

    try {
      await audioPlayerHandler.stop();
    } catch (_) {}

    emit(currentState.copyWith(
      clearRecitingAyah: true,
      isAyahAudioPlaying: false,
      isAyahAudioBuffering: false,
    ));
  }

  /// Sets the active EveryAyah reciter identifier.
  void setReciter(String reciterId) {
    final currentState = state;
    if (currentState is! QuranLoaded) return;

    final isCurrentlyPlaying = currentState.isAyahAudioPlaying;
    final currentAyah = currentState.recitingAyahNumber;
    final currentSurah = currentState.activeReadingSurah;

    emit(currentState.copyWith(activeReciterId: reciterId));

    if (isCurrentlyPlaying && currentAyah != null && currentSurah != null) {
      playAyahAudio(
        surahNumber: currentSurah.id,
        ayahNumber: currentAyah,
      );
    }
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

  @override
  Future<void> close() {
    _playerStateSubscription?.cancel();
    audioPlayerHandler.stop();
    return super.close();
  }
}
