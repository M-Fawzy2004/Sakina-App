import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/services/audio/audio_player_handler.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/usecases/get_featured_reciter_usecase.dart';
import 'package:sakina_app/features/audio_reciters/domain/usecases/get_reciter_tracks_usecase.dart';
import 'package:sakina_app/features/audio_reciters/domain/usecases/get_reciters_usecase.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_cubit.dart';

class MockGetRecitersUseCase extends Mock implements GetRecitersUseCase {}
class MockGetFeaturedReciterUseCase extends Mock implements GetFeaturedReciterUseCase {}
class MockGetReciterTracksUseCase extends Mock implements GetReciterTracksUseCase {}
class MockAudioPlayerHandler extends Mock implements AudioPlayerHandler {}

class FakeGetRecitersParams extends Fake implements GetRecitersParams {}
class FakeGetReciterTracksParams extends Fake implements GetReciterTracksParams {}

void main() {
  late MockGetRecitersUseCase mockGetRecitersUseCase;
  late MockGetFeaturedReciterUseCase mockGetFeaturedReciterUseCase;
  late MockGetReciterTracksUseCase mockGetReciterTracksUseCase;
  late MockAudioPlayerHandler mockAudioPlayerHandler;
  late AudioRecitersCubit cubit;

  late StreamController<PlayerState> playerStateController;
  late StreamController<Duration> positionController;
  late StreamController<Duration?> durationController;

  setUpAll(() {
    registerFallbackValue(Duration.zero);
    registerFallbackValue(FakeGetRecitersParams());
    registerFallbackValue(FakeGetReciterTracksParams());
    registerFallbackValue(const NoParams());
  });

  const testReciter = ReciterEntity(
    id: 1,
    nameArabic: 'الشيخ عبد الباسط عبد الصمد',
    englishName: 'Abdul Basit Abdul Samad',
    photoUrl: 'https://example.com/photo.jpg',
    listenersCount: 1578,
    formattedListeners: '1,578',
    revelationStyle: 'تلاوة خاشعة',
    riwayah: 'حفص عن عاصم',
    isFeatured: true,
    availableSurahsCount: 114,
    categories: ['الأكثر استماعاً', 'التلاوات الخاشعة'],
  );

  const testTrack = RecitationTrackEntity(
    id: 101,
    reciterId: 1,
    reciterName: 'الشيخ عبد الباسط عبد الصمد',
    surahId: 19,
    surahNameArabic: 'سورة مريم',
    styleDescription: 'سُورَةُ مَرْيَمَ • تِلَاوَةٌ خَاشِعَةٌ',
    audioUrl: 'https://example.com/audio.mp3',
    duration: Duration(minutes: 28),
    riwayah: 'حفص عن عاصم',
  );

  setUp(() {
    mockGetRecitersUseCase = MockGetRecitersUseCase();
    mockGetFeaturedReciterUseCase = MockGetFeaturedReciterUseCase();
    mockGetReciterTracksUseCase = MockGetReciterTracksUseCase();
    mockAudioPlayerHandler = MockAudioPlayerHandler();

    playerStateController = StreamController<PlayerState>.broadcast();
    positionController = StreamController<Duration>.broadcast();
    durationController = StreamController<Duration?>.broadcast();

    when(() => mockAudioPlayerHandler.playerStateStream)
        .thenAnswer((_) => playerStateController.stream);
    when(() => mockAudioPlayerHandler.positionStream)
        .thenAnswer((_) => positionController.stream);
    when(() => mockAudioPlayerHandler.durationStream)
        .thenAnswer((_) => durationController.stream);
    when(() => mockAudioPlayerHandler.isPlaying).thenReturn(false);
    when(() => mockAudioPlayerHandler.currentPosition).thenReturn(Duration.zero);
    when(() => mockAudioPlayerHandler.setAudioUrl(any())).thenAnswer((_) async {});
    when(() => mockAudioPlayerHandler.play()).thenAnswer((_) async {});
    when(() => mockAudioPlayerHandler.pause()).thenAnswer((_) async {});
    when(() => mockAudioPlayerHandler.seek(any())).thenAnswer((_) async {});
    when(() => mockAudioPlayerHandler.setSpeed(any())).thenAnswer((_) async {});

    cubit = AudioRecitersCubit(
      getRecitersUseCase: mockGetRecitersUseCase,
      getFeaturedReciterUseCase: mockGetFeaturedReciterUseCase,
      getReciterTracksUseCase: mockGetReciterTracksUseCase,
      audioPlayerHandler: mockAudioPlayerHandler,
    );
  });

  tearDown(() {
    cubit.close();
    playerStateController.close();
    positionController.close();
    durationController.close();
  });

  group('AudioRecitersCubit', () {
    test('loadCatalog populates reciters and featuredReciter', () async {
      when(() => mockGetRecitersUseCase(any()))
          .thenAnswer((_) async => const Right([testReciter]));
      when(() => mockGetFeaturedReciterUseCase(any()))
          .thenAnswer((_) async => const Right([testReciter]));

      await cubit.loadCatalog();

      expect(cubit.state.reciters, [testReciter]);
      expect(cubit.state.featuredReciters, [testReciter]);
      expect(cubit.state.featuredReciter, testReciter);
      expect(cubit.state.isLoading, false);
    });

    test('selectCategory updates selectedCategory and filters list', () async {
      when(() => mockGetRecitersUseCase(any()))
          .thenAnswer((_) async => const Right([testReciter]));

      await cubit.selectCategory('التلاوات الخاشعة');

      expect(cubit.state.selectedCategory, 'التلاوات الخاشعة');
      expect(cubit.state.reciters, [testReciter]);
    });

    test('playTrack sets audio url and calls handler play', () async {
      await cubit.playTrack(testTrack);

      expect(cubit.state.currentTrack, testTrack);
      verify(() => mockAudioPlayerHandler.setAudioUrl(testTrack.audioUrl)).called(1);
      verify(() => mockAudioPlayerHandler.play()).called(1);
    });

    test('toggleRepeat updates isRepeating', () {
      expect(cubit.state.isRepeating, false);
      cubit.toggleRepeat();
      expect(cubit.state.isRepeating, true);
    });

    test('toggleShuffle updates isShuffling', () {
      expect(cubit.state.isShuffling, false);
      cubit.toggleShuffle();
      expect(cubit.state.isShuffling, true);
    });

    test('setPlaybackSpeed updates state and calls audioPlayerHandler.setSpeed', () async {
      await cubit.setPlaybackSpeed(1.5);
      expect(cubit.state.playbackSpeed, 1.5);
      verify(() => mockAudioPlayerHandler.setSpeed(1.5)).called(1);
    });
  });
}
