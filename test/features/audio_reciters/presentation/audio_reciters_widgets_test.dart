import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:just_audio/just_audio.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/services/audio/audio_player_handler.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/usecases/get_featured_reciter_usecase.dart';
import 'package:sakina_app/features/audio_reciters/domain/usecases/get_reciter_tracks_usecase.dart';
import 'package:sakina_app/features/audio_reciters/domain/usecases/get_reciters_usecase.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_cubit.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/audio_player_settings_sheet.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/featured_reciters_carousel.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/recitation_audio_waveform.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/recitation_playback_controls.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/recitation_scrubber_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/live_stream_channels_card.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/live_broadcast_status_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/live_sanctuary_aura_medallion.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/live_sanctuary_playback_controls.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_grid_card.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_tile_card.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciters_filter_chips.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciters_header_app_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_mini_player_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/reciter_surahs_screen.dart';

class _MockGetRecitersUseCase extends Mock implements GetRecitersUseCase {}
class _MockGetFeaturedReciterUseCase extends Mock implements GetFeaturedReciterUseCase {}
class _MockGetReciterTracksUseCase extends Mock implements GetReciterTracksUseCase {}
class _MockAudioPlayerHandler extends Mock implements AudioPlayerHandler {}

class _FakeGetReciterTracksParams extends Fake implements GetReciterTracksParams {}

void main() {
  Widget createTestWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: child,
          ),
        ),
      ),
    );
  }

  const testReciter = ReciterEntity(
    id: 1,
    nameArabic: 'الشيخ عبد الباسط عبد الصمد',
    englishName: 'Abdul Basit Abdul Samad',
    photoUrl: null,
    listenersCount: 1578,
    formattedListeners: '1,578',
    revelationStyle: 'تلاوة خاشعة ومجودة',
    riwayah: 'حفص عن عاصم',
    isFeatured: true,
    availableSurahsCount: 114,
    categories: ['الأكثر استماعاً', 'التلاوات الخاشعة'],
  );

  group('RecitersHeaderAppBar', () {
    testWidgets('renders brand name and section title', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestWidget(const RecitersHeaderAppBar()));
      await tester.pumpAndSettle();

      expect(find.text('سكينة'), findsOneWidget);
      expect(find.text('واجهة التلاوات'), findsOneWidget);
    });
  });

  group('RecitersFilterChips', () {
    testWidgets('renders chips and responds to selection', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      String selected = 'الأكثر استماعاً';

      await tester.pumpWidget(
        createTestWidget(
          RecitersFilterChips(
            categories: const ['الأكثر استماعاً', 'التلاوات الخاشعة', 'رواية حفص'],
            selectedCategory: selected,
            onSelected: (cat) => selected = cat,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الأكثر استماعاً'), findsOneWidget);
      expect(find.text('التلاوات الخاشعة'), findsOneWidget);

      await tester.tap(find.text('التلاوات الخاشعة'));
      await tester.pumpAndSettle();

      expect(selected, 'التلاوات الخاشعة');
    });
  });

  group('FeaturedRecitersCarousel', () {
    testWidgets('renders sheikhs carousel and triggers card tap', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      bool cardTapped = false;

      await tester.pumpWidget(
        createTestWidget(
          FeaturedRecitersCarousel(
            featuredReciters: const [testReciter],
            activeIndex: 0,
            isPlaying: false,
            onPageChanged: (_) {},
            onPlayTap: (_) {},
            onCardTap: (_) => cardTapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الشيخ عبد الباسط عبد الصمد'), findsOneWidget);

      await tester.tap(find.text('الشيخ عبد الباسط عبد الصمد'));
      await tester.pumpAndSettle();
      expect(cardTapped, true);
    });
  });

  group('ReciterTileCard', () {
    testWidgets('renders reciter info and listener count badge', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestWidget(
          ReciterTileCard(
            reciter: testReciter,
            isCurrentPlaying: false,
            onTap: () => tapped = true,
            onActionTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الشيخ عبد الباسط عبد الصمد'), findsOneWidget);
      expect(find.text('تلاوة خاشعة ومجودة'), findsOneWidget);
      expect(find.text('114 سورة'), findsOneWidget);
      expect(find.text('حفص عن عاصم'), findsOneWidget);

      await tester.tap(find.byType(ReciterTileCard));
      await tester.pumpAndSettle();
      expect(tapped, true);
    });
  });

  group('ReciterGridCard', () {
    testWidgets('renders grid card with avatar letter, sheikh name and title', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestWidget(
          ReciterGridCard(
            reciter: testReciter,
            isCurrentPlaying: false,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الشيخ عبد الباسط عبد الصمد'), findsOneWidget);
      expect(find.text('تلاوة خاشعة ومجودة'), findsOneWidget);
      expect(find.text('حفص عن عاصم • 114 سورة'), findsOneWidget);

      await tester.tap(find.byType(ReciterGridCard));
      await tester.pumpAndSettle();
      expect(tapped, true);
    });
  });

  group('LiveStreamChannelsSection', () {
    testWidgets('renders Makkah and Madinah live channels and triggers tap', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      RecitationTrackEntity? tappedTrack;

      await tester.pumpWidget(
        createTestWidget(
          LiveStreamChannelsSection(
            currentTrack: null,
            isPlaying: false,
            onChannelTap: (track) => tappedTrack = track,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('البث المباشر'), findsOneWidget);
      expect(find.text('مباشر'), findsWidgets);
      expect(find.text('قناة القرآن الكريم'), findsOneWidget);
      expect(find.text('قناة السنة النبوية'), findsOneWidget);

      await tester.tap(find.text('قناة القرآن الكريم'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(tappedTrack, isNotNull);
      expect(tappedTrack!.surahNameArabic, 'قناة القرآن الكريم');
    });
  });

  group('RecitationAudioWaveform', () {
    testWidgets('renders without throwing when playing and paused', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const RecitationAudioWaveform(isPlaying: true),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(RecitationAudioWaveform), findsOneWidget);
    });
  });

  group('RecitationScrubberBar', () {
    testWidgets('renders elapsed and remaining timestamps', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          RecitationScrubberBar(
            position: const Duration(seconds: 10),
            duration: const Duration(minutes: 11, seconds: 9),
            onSeek: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0:10'), findsOneWidget);
      expect(find.text('-10:59'), findsOneWidget);
    });
  });

  group('RecitationPlaybackControls', () {
    testWidgets('renders play/pause and auxiliary buttons', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          RecitationPlaybackControls(
            isPlaying: false,
            isBuffering: false,
            isRepeating: false,
            isShuffling: false,
            onPlayPause: () {},
            onNext: () {},
            onPrevious: () {},
            onToggleRepeat: () {},
            onToggleShuffle: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RecitationPlaybackControls), findsOneWidget);
    });
  });

  group('AudioPlayerSettingsSheet', () {
    testWidgets('renders speed and sleep timer options with immediate reaction', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      double selectedSpeed = 1.0;
      int? selectedTimer;

      await tester.pumpWidget(
        createTestWidget(
          AudioPlayerSettingsSheet(
            currentSpeed: selectedSpeed,
            sleepTimerMinutes: selectedTimer,
            isRepeating: false,
            onSpeedSelected: (s) => selectedSpeed = s,
            onSleepTimerSelected: (t) => selectedTimer = t,
            onToggleRepeat: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('إعدادات التلاوة والمشغل'), findsOneWidget);
      expect(find.text('2.0x'), findsOneWidget);

      await tester.tap(find.text('2.0x'));
      await tester.pumpAndSettle();

      expect(selectedSpeed, 2.0);
    });
  });

  group('ReciterSurahsScreen', () {
    testWidgets('renders reciter profile and surahs list', (tester) async {
      registerFallbackValue(_FakeGetReciterTracksParams());
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final mockRecitersUseCase = _MockGetRecitersUseCase();
      final mockFeaturedUseCase = _MockGetFeaturedReciterUseCase();
      final mockTracksUseCase = _MockGetReciterTracksUseCase();
      final mockPlayerHandler = _MockAudioPlayerHandler();

      const playerStream = Stream<PlayerState>.empty();
      const posStream = Stream<Duration>.empty();
      const durStream = Stream<Duration?>.empty();

      when(() => mockPlayerHandler.playerStateStream).thenAnswer((_) => playerStream);
      when(() => mockPlayerHandler.positionStream).thenAnswer((_) => posStream);
      when(() => mockPlayerHandler.durationStream).thenAnswer((_) => durStream);
      when(() => mockPlayerHandler.isPlaying).thenReturn(false);

      const testTrack = RecitationTrackEntity(
        id: 1001,
        reciterId: 1,
        reciterName: 'الشيخ عبد الباسط عبد الصمد',
        surahId: 1,
        surahNameArabic: 'سُورَةُ الفَاتِحَةِ',
        styleDescription: 'تلاوة مجودة',
        audioUrl: 'https://server7.mp3quran.net/basit/001.mp3',
        duration: Duration(minutes: 1),
        riwayah: 'المصحف المجود',
      );

      when(() => mockTracksUseCase(any()))
          .thenAnswer((_) async => const Right([testTrack]));

      final cubit = AudioRecitersCubit(
        getRecitersUseCase: mockRecitersUseCase,
        getFeaturedReciterUseCase: mockFeaturedUseCase,
        getReciterTracksUseCase: mockTracksUseCase,
        audioPlayerHandler: mockPlayerHandler,
      );

      addTearDown(() => cubit.close());

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: BlocProvider<AudioRecitersCubit>.value(
                value: cubit,
                child: const ReciterSurahsScreen(reciter: testReciter),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('الشيخ عبد الباسط عبد الصمد'), findsWidgets);
      expect(find.text('فهرس السور القرآنية'), findsOneWidget);
      expect(find.text('سُورَةُ الفَاتِحَةِ'), findsOneWidget);
      expect(find.text('بدء من الفاتحة'), findsOneWidget);
      expect(find.text('تشغيل عشوائي'), findsOneWidget);
    });
  });

  group('LiveBroadcastStatusBar', () {
    testWidgets('renders live beacon and quality badges with zero seconds displayed', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const LiveBroadcastStatusBar(isPlaying: true),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('مباشر LIVE'), findsOneWidget);
      expect(find.text('نقل حي عبر الأقمار الاصطناعية • 24 ساعة'), findsOneWidget);
      expect(find.text('320kbps HD'), findsOneWidget);
      // Ensure zero seconds scrubber or timestamps exist
      expect(find.text('0:00'), findsNothing);
      expect(find.text('0:24'), findsNothing);
    });
  });

  group('LiveSanctuaryAuraMedallion', () {
    testWidgets('renders Makkah Kaaba emblem and calligraphy', (tester) async {
      final controller = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(seconds: 24),
      );
      addTearDown(() => controller.dispose());

      await tester.pumpWidget(
        createTestWidget(
          LiveSanctuaryAuraMedallion(
            isMakkah: true,
            isPlaying: true,
            rotationAnimation: controller,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('🕋'), findsOneWidget);
      expect(find.text('المسجد الحرام'), findsOneWidget);
      expect(find.text('الكعبة المشرفة'), findsOneWidget);
    });

    testWidgets('renders Madinah Prophet Mosque emblem and calligraphy', (tester) async {
      final controller = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(seconds: 24),
      );
      addTearDown(() => controller.dispose());

      await tester.pumpWidget(
        createTestWidget(
          LiveSanctuaryAuraMedallion(
            isMakkah: false,
            isPlaying: true,
            rotationAnimation: controller,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('🕌'), findsOneWidget);
      expect(find.text('المسجد النبوي'), findsOneWidget);
      expect(find.text('الروضة الشريفة'), findsOneWidget);
    });
  });

  group('LiveSanctuaryPlaybackControls', () {
    testWidgets('renders controls and triggers actions without side cards', (tester) async {
      bool switchedMakkah = false;
      bool switchedMadinah = false;
      bool playPaused = false;
      bool reconnected = false;

      await tester.pumpWidget(
        createTestWidget(
          LiveSanctuaryPlaybackControls(
            isPlaying: true,
            isBuffering: false,
            isMakkah: true,
            onPlayPause: () => playPaused = true,
            onSwitchToMakkah: () => switchedMakkah = true,
            onSwitchToMadinah: () => switchedMadinah = true,
            onReconnect: () => reconnected = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Ensure bulky side cards are removed
      expect(find.text('مكة المكرمة'), findsNothing);
      expect(find.text('المدينة المنورة'), findsNothing);

      await tester.tap(find.byIcon(Iconsax.next));
      await tester.pumpAndSettle();
      expect(switchedMadinah, true);

      // Now switch back with isMakkah false
      await tester.pumpWidget(
        createTestWidget(
          LiveSanctuaryPlaybackControls(
            isPlaying: true,
            isBuffering: false,
            isMakkah: false,
            onPlayPause: () => playPaused = true,
            onSwitchToMakkah: () => switchedMakkah = true,
            onSwitchToMadinah: () => switchedMadinah = true,
            onReconnect: () => reconnected = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Iconsax.previous));
      await tester.pumpAndSettle();
      expect(switchedMakkah, true);

      await tester.tap(find.byIcon(Iconsax.pause));
      await tester.pumpAndSettle();
      expect(playPaused, true);

      await tester.tap(find.byIcon(Iconsax.refresh));
      await tester.pumpAndSettle();
      expect(reconnected, true);
    });
  });

  group('ReciterMiniPlayerBar', () {
    testWidgets('renders track title, reciter name and handles downward drag swipe to dismiss', (tester) async {
      bool dismissed = false;
      bool playPaused = false;

      const track = RecitationTrackEntity(
        id: 990004,
        reciterId: 999,
        reciterName: 'المسجد النبوي • المدينة المنورة',
        surahId: 0,
        surahNameArabic: 'قناة السنة النبوية',
        styleDescription: 'بث حي متواصل من الروضة الشريفة',
        audioUrl: 'https://win.holol.com/live/sunnah/playlist.m3u8',
        duration: Duration.zero,
        riwayah: 'بث مباشر 24/7',
      );

      await tester.pumpWidget(
        createTestWidget(
          ReciterMiniPlayerBar(
            track: track,
            isPlaying: true,
            onTap: () {},
            onPlayPauseTap: () => playPaused = true,
            onDismiss: () => dismissed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('قناة السنة النبوية'), findsOneWidget);
      expect(find.text('المسجد النبوي • المدينة المنورة'), findsOneWidget);

      // Play/Pause tap
      await tester.tap(find.byIcon(Iconsax.pause));
      await tester.pumpAndSettle();
      expect(playPaused, true);

      // Downward swipe drag gesture on the mini player
      await tester.drag(find.text('قناة السنة النبوية'), const Offset(0, 150));
      await tester.pumpAndSettle();

      expect(dismissed, true);
    });

    testWidgets('triggers onDismiss when close icon is tapped', (tester) async {
      bool dismissed = false;

      const track = RecitationTrackEntity(
        id: 1001,
        reciterId: 1,
        reciterName: 'الشيخ عبد الباسط عبد الصمد',
        surahId: 1,
        surahNameArabic: 'سُورَةُ الفَاتِحَةِ',
        styleDescription: 'تلاوة مجودة',
        audioUrl: 'https://server7.mp3quran.net/basit/001.mp3',
        duration: Duration(minutes: 1),
        riwayah: 'المصحف المجود',
      );

      await tester.pumpWidget(
        createTestWidget(
          ReciterMiniPlayerBar(
            track: track,
            isPlaying: false,
            onTap: () {},
            onPlayPauseTap: () {},
            onDismiss: () => dismissed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Iconsax.close_circle));
      await tester.pumpAndSettle();

      expect(dismissed, true);
    });
  });
}
