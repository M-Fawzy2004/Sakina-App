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
      expect(find.text('تطبيق سَكِينَة'), findsOneWidget);
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
      expect(find.byType(VerseCardPlaybackBar), findsOneWidget);
      expect(find.byType(VerseCardBackgroundSelector), findsOneWidget);
      expect(find.byType(VerseCardActionsRow), findsOneWidget);

      // Verify navigating to next verse updates text
      final initialVerse = VerseCardItem.curatedVerses[0];
      final nextVerse = VerseCardItem.curatedVerses[1];
      expect(find.text(initialVerse.ayahText), findsOneWidget);

      await tester.tap(find.byTooltip('الآية التالية'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text(nextVerse.ayahText), findsOneWidget);
    });
  });
}
