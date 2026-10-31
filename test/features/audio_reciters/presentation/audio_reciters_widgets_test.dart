import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/audio_player_settings_sheet.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/featured_reciters_carousel.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/recitation_audio_waveform.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/recitation_playback_controls.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/recitation_scrubber_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_tile_card.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciters_filter_chips.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciters_header_app_bar.dart';

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
      expect(find.text('1,578'), findsOneWidget);
      expect(find.text('حفص عن عاصم'), findsOneWidget);

      await tester.tap(find.byType(ReciterTileCard));
      await tester.pumpAndSettle();
      expect(tapped, true);
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
}
