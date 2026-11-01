import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';

class AudioRecitersState extends Equatable {
  final bool isLoading;
  final List<ReciterEntity> reciters;
  final List<ReciterEntity> featuredReciters;
  final ReciterEntity? featuredReciter;
  final int activeFeaturedIndex;
  final List<String> categories;
  final String selectedCategory;
  final String searchQuery;
  final RecitationTrackEntity? currentTrack;
  final bool isPlaying;
  final bool isBuffering;
  final Duration position;
  final Duration duration;
  final bool isRepeating;
  final bool isShuffling;
  final double playbackSpeed;
  final bool isFavorite;
  final int? sleepTimerMinutes;
  final String? errorMessage;
  final List<RecitationTrackEntity> reciterTracks;
  final bool isLoadingTracks;
  final ReciterEntity? selectedReciter;

  const AudioRecitersState({
    this.isLoading = false,
    this.reciters = const [],
    this.featuredReciters = const [],
    this.featuredReciter,
    this.activeFeaturedIndex = 0,
    this.categories = const [
      'الأكثر استماعاً',
      'التلاوات الخاشعة',
      'رواية حفص',
      'تلاوات نادرة',
    ],
    this.selectedCategory = 'الأكثر استماعاً',
    this.searchQuery = '',
    this.currentTrack,
    this.isPlaying = false,
    this.isBuffering = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isRepeating = false,
    this.isShuffling = false,
    this.playbackSpeed = 1.0,
    this.isFavorite = false,
    this.sleepTimerMinutes,
    this.errorMessage,
    this.reciterTracks = const [],
    this.isLoadingTracks = false,
    this.selectedReciter,
  });

  AudioRecitersState copyWith({
    bool? isLoading,
    List<ReciterEntity>? reciters,
    List<ReciterEntity>? featuredReciters,
    ReciterEntity? featuredReciter,
    int? activeFeaturedIndex,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    RecitationTrackEntity? currentTrack,
    bool clearCurrentTrack = false,
    bool? isPlaying,
    bool? isBuffering,
    Duration? position,
    Duration? duration,
    bool? isRepeating,
    bool? isShuffling,
    double? playbackSpeed,
    bool? isFavorite,
    int? sleepTimerMinutes,
    bool clearSleepTimer = false,
    String? errorMessage,
    List<RecitationTrackEntity>? reciterTracks,
    bool? isLoadingTracks,
    ReciterEntity? selectedReciter,
  }) {
    return AudioRecitersState(
      isLoading: isLoading ?? this.isLoading,
      reciters: reciters ?? this.reciters,
      featuredReciters: featuredReciters ?? this.featuredReciters,
      featuredReciter: featuredReciter ?? this.featuredReciter,
      activeFeaturedIndex: activeFeaturedIndex ?? this.activeFeaturedIndex,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      currentTrack: clearCurrentTrack ? null : (currentTrack ?? this.currentTrack),
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isRepeating: isRepeating ?? this.isRepeating,
      isShuffling: isShuffling ?? this.isShuffling,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      isFavorite: isFavorite ?? this.isFavorite,
      sleepTimerMinutes: clearSleepTimer ? null : (sleepTimerMinutes ?? this.sleepTimerMinutes),
      errorMessage: errorMessage,
      reciterTracks: reciterTracks ?? this.reciterTracks,
      isLoadingTracks: isLoadingTracks ?? this.isLoadingTracks,
      selectedReciter: selectedReciter ?? this.selectedReciter,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        reciters,
        featuredReciters,
        featuredReciter,
        activeFeaturedIndex,
        categories,
        selectedCategory,
        searchQuery,
        currentTrack,
        isPlaying,
        isBuffering,
        position,
        duration,
        isRepeating,
        isShuffling,
        playbackSpeed,
        isFavorite,
        sleepTimerMinutes,
        errorMessage,
        reciterTracks,
        isLoadingTracks,
        selectedReciter,
      ];
}
