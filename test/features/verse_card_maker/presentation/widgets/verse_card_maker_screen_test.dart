import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/verse_card_maker/domain/entities/verse_card_item.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_actions_row.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_background_selector.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_display.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_duration_matcher_chip.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_playback_bar.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_top_bar.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_watermark.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/verse_card_maker_screen.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: ThemeData(
          extensions: const [AppColorsScheme.dark],
        ),
        home: child,
      ),
    );
  }

  group('VerseCardMaker Widget Tests', () {
    testWidgets('VerseCardDisplay renders Ayah text, Surah badge, and watermark',
        (tester) async {
      final key = GlobalKey();
      final verse = VerseCardItem.curatedVerses.first;

      await tester.pumpWidget(
        buildTestableWidget(
          Scaffold(
            body: VerseCardDisplay(
              cardKey: key,
              verse: verse,
              reciterName: 'مشاري راشد العفاسي',
              isPlayingRecitation: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(verse.ayahText), findsOneWidget);
      expect(
          find.text('سُورَةُ ${verse.surahName} • الآيَةُ ${verse.ayahNumber}'),
          findsOneWidget);
      expect(find.byType(VerseCardWatermark), findsOneWidget);
      expect(find.text('سَكِينَة'), findsOneWidget);
    });

    testWidgets('VerseCardDisplay renders multi-verse range badge with zero border',
        (tester) async {
      final key = GlobalKey();
      final overlayKey = GlobalKey();
      const multiVerse = VerseCardItem(
        surahNumber: 2,
        ayahNumber: 1,
        endAyahNumber: 3,
        surahName: 'البقرة',
        ayahText: 'الم',
        versesTextList: [
          'الم',
          'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ',
          'الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ',
        ],
        theme: 'هدى',
        durationSeconds: 20,
      );

      await tester.pumpWidget(
        buildTestableWidget(
          Scaffold(
            body: VerseCardDisplay(
              cardKey: key,
              overlayKey: overlayKey,
              verse: multiVerse,
              currentAyahDisplayIndex: 0,
              reciterName: 'مشاري راشد العفاسي',
              isPlayingRecitation: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('سُورَةُ البقرة • الآيَةُ 1'), findsOneWidget);
      expect(find.text('الم'), findsOneWidget);

      // Verify ZERO outer border on card container
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byKey(key),
          matching: find.byType(Container).first,
        ),
      );
      final boxDecoration = container.decoration as BoxDecoration?;
      expect(boxDecoration?.border, isNull);

      // Now pump with active Ayah index = 1
      await tester.pumpWidget(
        buildTestableWidget(
          Scaffold(
            body: VerseCardDisplay(
              cardKey: key,
              overlayKey: overlayKey,
              verse: multiVerse,
              currentAyahDisplayIndex: 1,
              reciterName: 'مشاري راشد العفاسي',
              isPlayingRecitation: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('سُورَةُ البقرة • الآيَةُ 2'), findsOneWidget);
      expect(
          find.text('ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ'),
          findsOneWidget);
    });

    testWidgets(
        'VerseCardBackgroundSelector renders 10 presets and custom upload buttons',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          Scaffold(
            body: VerseCardBackgroundSelector(
              selectedPresetAsset: 'assets/images/background_1.jpg',
              hasCustomImage: false,
              hasCustomVideo: false,
              onSelectPreset: (_) {},
              onPickCustomImage: () {},
              onPickCustomVideo: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('صورتك'), findsOneWidget);
      expect(find.text('فيديو'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('VerseCardActionsRow renders save, share, and copy buttons',
        (tester) async {
      bool copied = false;

      await tester.pumpWidget(
        buildTestableWidget(
          Scaffold(
            body: VerseCardActionsRow(
              isExporting: false,
              isVideoMode: false,
              onSavePrimary: () {},
              onShareCard: () {},
              onCopyText: () => copied = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('حفظ كصورة 4K'), findsOneWidget);
      expect(find.text('مشاركة'), findsOneWidget);

      await tester.tap(find.byTooltip('نسخ نص الآية'));
      await tester.pumpAndSettle();

      expect(copied, isTrue);
    });

    testWidgets('VerseCardDurationMatcherChip renders video duration match',
        (tester) async {
      bool autoMatched = false;
      final verse = VerseCardItem.curatedVerses.first;

      await tester.pumpWidget(
        buildTestableWidget(
          Scaffold(
            body: VerseCardDurationMatcherChip(
              videoDurationSeconds: 15,
              currentVerse: verse,
              onAutoMatchVerse: () => autoMatched = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('فيديو ريلز: 15 ث'), findsOneWidget);
      expect(find.text('تَوْفِيقُ الآيَة'), findsOneWidget);

      await tester.tap(find.text('تَوْفِيقُ الآيَة'));
      await tester.pumpAndSettle();

      expect(autoMatched, isTrue);
    });

    testWidgets('VerseCardTopBar renders unified header and random ayah button',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          Scaffold(
            body: VerseCardTopBar(
              onBack: () {},
              onRandomAyah: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('صَانِعُ بِطَاقَاتِ الآيَاتِ'), findsOneWidget);
      expect(find.text('تصميم 4K ومقاطع ريلز مع التلاوة'), findsOneWidget);
    });

    testWidgets('VerseCardMakerScreen renders full studio layout and controls',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestableWidget(
          const VerseCardMakerScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('صَانِعُ بِطَاقَاتِ الآيَاتِ'), findsOneWidget);
      expect(find.byType(VerseCardDisplay), findsOneWidget);
      // In default Image Mode, playback bar is hidden to prevent unwanted audio
      expect(find.byType(VerseCardPlaybackBar), findsNothing);
      expect(find.byType(VerseCardBackgroundSelector), findsOneWidget);
      expect(find.byType(VerseCardActionsRow), findsOneWidget);

      // Verify switching to Video Reels mode reveals video hero and playback bar
      await tester.tap(find.textContaining('فِيدْيُو رِيلْز'));
      await tester.pumpAndSettle();
      expect(find.byType(VerseCardPlaybackBar), findsOneWidget);
      expect(find.text('اخْتِيَارُ مَقْطَعِ فِيدْيُو مِنَ الِاسْتُودْيُو'), findsOneWidget);

      // Verify navigating to next verse via playback bar updates text
      final initialVerse = VerseCardItem.curatedVerses[0];
      final nextVerse = VerseCardItem.curatedVerses[1];
      expect(find.text(initialVerse.ayahText), findsOneWidget);

      await tester.ensureVisible(find.byTooltip('الآية التالية'));
      await tester.tap(find.byTooltip('الآية التالية'));
      await tester.pumpAndSettle();

      expect(find.text(nextVerse.ayahText), findsOneWidget);

      // Switch back to Image mode and verify clean state
      await tester.tap(find.textContaining('تَصْمِيمُ صُورَة'));
      await tester.pumpAndSettle();
      expect(find.byType(VerseCardPlaybackBar), findsNothing);
    });
  });
}
