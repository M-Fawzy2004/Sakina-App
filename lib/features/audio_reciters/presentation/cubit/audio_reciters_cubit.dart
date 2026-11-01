import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sakina_app/core/services/audio/audio_player_handler.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/usecases/get_featured_reciter_usecase.dart';
import 'package:sakina_app/features/audio_reciters/domain/usecases/get_reciter_tracks_usecase.dart';
import 'package:sakina_app/features/audio_reciters/domain/usecases/get_reciters_usecase.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_state.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/live_stream_channels_card.dart';

class AudioRecitersCubit extends Cubit<AudioRecitersState> {
  final GetRecitersUseCase getRecitersUseCase;
  final GetFeaturedReciterUseCase getFeaturedReciterUseCase;
  final GetReciterTracksUseCase getReciterTracksUseCase;
  final AudioPlayerHandler audioPlayerHandler;

  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  Timer? _sleepTimer;

  AudioRecitersCubit({
    required this.getRecitersUseCase,
    required this.getFeaturedReciterUseCase,
    required this.getReciterTracksUseCase,
    required this.audioPlayerHandler,
  }) : super(const AudioRecitersState()) {
    _initAudioStreams();
  }

  void _initAudioStreams() {
    _playerStateSubscription = audioPlayerHandler.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final isBuffering = playerState.processingState == ProcessingState.buffering ||
          playerState.processingState == ProcessingState.loading;
      final isCompleted = playerState.processingState == ProcessingState.completed;

      if (isCompleted) {
        if (state.isRepeating) {
          seekTo(Duration.zero);
          play();
        } else {
          nextTrack();
        }
      }

      emit(state.copyWith(
        isPlaying: isPlaying,
        isBuffering: isBuffering,
      ));
    });

    _positionSubscription = audioPlayerHandler.positionStream.listen((pos) {
      emit(state.copyWith(position: pos));
    });

    _durationSubscription = audioPlayerHandler.durationStream.listen((dur) {
      if (dur != null) {
        emit(state.copyWith(duration: dur));
      }
    });
  }

  Future<void> loadCatalog() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final recitersResult = await getRecitersUseCase(
      GetRecitersParams(
        category: state.selectedCategory,
        query: state.searchQuery,
      ),
    );

    final featuredResult = await getFeaturedReciterUseCase(const NoParams());

    recitersResult.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (reciters) {
        featuredResult.fold(
          (failure) => emit(state.copyWith(
            isLoading: false,
            reciters: reciters,
            errorMessage: failure.message,
          )),
          (featuredList) {
            emit(state.copyWith(
              isLoading: false,
              reciters: reciters,
              featuredReciters: featuredList,
              featuredReciter: featuredList.isNotEmpty ? featuredList.first : null,
              activeFeaturedIndex: 0,
            ));
          },
        );
      },
    );
  }

  void setFeaturedIndex(int index) {
    if (index >= 0 && index < state.featuredReciters.length) {
      emit(state.copyWith(
        activeFeaturedIndex: index,
        featuredReciter: state.featuredReciters[index],
      ));
    }
  }

  Future<void> selectCategory(String category) async {
    if (state.selectedCategory == category) return;
    emit(state.copyWith(selectedCategory: category, isLoading: true));

    final result = await getRecitersUseCase(
      GetRecitersParams(
        category: category,
        query: state.searchQuery,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (reciters) => emit(state.copyWith(isLoading: false, reciters: reciters)),
    );
  }

  Future<void> search(String query) async {
    emit(state.copyWith(searchQuery: query, isLoading: true));

    final result = await getRecitersUseCase(
      GetRecitersParams(
        category: state.selectedCategory,
        query: query,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (reciters) => emit(state.copyWith(isLoading: false, reciters: reciters)),
    );
  }

  Future<void> loadReciterTracks(ReciterEntity reciter) async {
    emit(state.copyWith(
      selectedReciter: reciter,
      isLoadingTracks: true,
      errorMessage: null,
    ));

    final result = await getReciterTracksUseCase(
      GetReciterTracksParams(reciterId: reciter.id),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingTracks: false,
        errorMessage: failure.message,
      )),
      (tracks) => emit(state.copyWith(
        isLoadingTracks: false,
        reciterTracks: tracks,
      )),
    );
  }

  Future<void> playTrack(RecitationTrackEntity track) async {
    try {
      emit(state.copyWith(
        currentTrack: track,
        isBuffering: true,
        duration: track.duration,
        position: Duration.zero,
      ));

      await audioPlayerHandler.setAudioUrl(track.audioUrl);
      if (state.playbackSpeed != 1.0) {
        await audioPlayerHandler.setSpeed(state.playbackSpeed);
      }
      await audioPlayerHandler.play();
    } catch (e) {
      emit(state.copyWith(
        isBuffering: false,
        errorMessage: 'تعذر تشغيل التلاوة: $e',
      ));
    }
  }

  Future<void> playReciterFeaturedTrack(ReciterEntity reciter) async {
    final tracksResult = await getReciterTracksUseCase(
      GetReciterTracksParams(reciterId: reciter.id),
    );

    tracksResult.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (tracks) {
        if (tracks.isNotEmpty) {
          playTrack(tracks.first);
        }
      },
    );
  }

  Future<void> togglePlayPause() async {
    if (state.currentTrack == null) {
      if (state.featuredReciter != null) {
        await playReciterFeaturedTrack(state.featuredReciter!);
      }
      return;
    }

    if (state.isPlaying) {
      await audioPlayerHandler.pause();
    } else {
      await audioPlayerHandler.play();
    }
  }

  Future<void> play() async {
    await audioPlayerHandler.play();
  }

  Future<void> pause() async {
    await audioPlayerHandler.pause();
  }

  Future<void> stopAndDismissTrack() async {
    try {
      await audioPlayerHandler.stop();
    } catch (_) {
      try {
        await audioPlayerHandler.pause();
      } catch (_) {}
    }
    emit(state.copyWith(
      clearCurrentTrack: true,
      isPlaying: false,
      position: Duration.zero,
    ));
  }

  Future<void> seekTo(Duration position) async {
    await audioPlayerHandler.seek(position);
  }

  Future<void> nextTrack() async {
    if (state.currentTrack == null) return;

    if (state.currentTrack!.reciterId == 999) {
      final isMakkah = state.currentTrack!.audioUrl.contains('quran');
      final target = isMakkah ? kSanctuaryLiveChannels[1] : kSanctuaryLiveChannels[0];
      await playTrack(target.toTrack());
      return;
    }

    if (state.reciterTracks.isNotEmpty) {
      final currentIndex = state.reciterTracks.indexWhere(
        (t) => t.surahId == state.currentTrack!.surahId && t.reciterId == state.currentTrack!.reciterId,
      );
      if (currentIndex != -1) {
        final nextIndex = (currentIndex + 1) % state.reciterTracks.length;
        playTrack(state.reciterTracks[nextIndex]);
        return;
      }
    }

    final nextReciterId = (state.currentTrack!.reciterId % 8) + 1;
    final tracksResult = await getReciterTracksUseCase(
      GetReciterTracksParams(reciterId: nextReciterId),
    );
    tracksResult.fold(
      (_) {},
      (tracks) {
        if (tracks.isNotEmpty) {
          playTrack(tracks.first);
        }
      },
    );
  }

  Future<void> previousTrack() async {
    if (state.currentTrack != null && state.currentTrack!.reciterId == 999) {
      final isMakkah = state.currentTrack!.audioUrl.contains('quran');
      final target = isMakkah ? kSanctuaryLiveChannels[1] : kSanctuaryLiveChannels[0];
      await playTrack(target.toTrack());
      return;
    }

    if (state.position.inSeconds > 4) {
      await seekTo(Duration.zero);
      return;
    }
    if (state.currentTrack == null) return;

    if (state.reciterTracks.isNotEmpty) {
      final currentIndex = state.reciterTracks.indexWhere(
        (t) => t.surahId == state.currentTrack!.surahId && t.reciterId == state.currentTrack!.reciterId,
      );
      if (currentIndex != -1) {
        final prevIndex = currentIndex <= 0 ? state.reciterTracks.length - 1 : currentIndex - 1;
        playTrack(state.reciterTracks[prevIndex]);
        return;
      }
    }

    final prevReciterId = state.currentTrack!.reciterId <= 1 ? 8 : state.currentTrack!.reciterId - 1;
    final tracksResult = await getReciterTracksUseCase(
      GetReciterTracksParams(reciterId: prevReciterId),
    );
    tracksResult.fold(
      (_) {},
      (tracks) {
        if (tracks.isNotEmpty) {
          playTrack(tracks.first);
        }
      },
    );
  }

  void toggleRepeat() {
    emit(state.copyWith(isRepeating: !state.isRepeating));
  }

  void toggleShuffle() {
    emit(state.copyWith(isShuffling: !state.isShuffling));
  }

  void toggleFavorite() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  Future<void> setPlaybackSpeed(double speed) async {
    emit(state.copyWith(playbackSpeed: speed));
    try {
      await audioPlayerHandler.setSpeed(speed);
    } catch (_) {}
  }

  void setSleepTimer(int? minutes) {
    _sleepTimer?.cancel();
    if (minutes == null) {
      emit(state.copyWith(clearSleepTimer: true));
      return;
    }

    emit(state.copyWith(sleepTimerMinutes: minutes));
    _sleepTimer = Timer(Duration(minutes: minutes), () {
      pause();
      emit(state.copyWith(clearSleepTimer: true));
    });
  }

  @override
  Future<void> close() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _sleepTimer?.cancel();
    return super.close();
  }
}
