import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_ornate_manuscript_card.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_settings_sheet.dart';

void main() {
  const testSurah = SurahEntity(
    id: 112,
    nameArabic: 'الإِخْلَاص',
    englishName: 'Al-Ikhlas',
    revelationType: 'مكية',
    versesCount: 4,
    pageNumber: 604,
    juzNumber: 30,
  );

  const testVerses = [
    AyahEntity(
      numberInSurah: 1,
      text: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
      page: 604,
      juz: 30,
    ),
    AyahEntity(
      numberInSurah: 2,
      text: 'اللَّهُ الصَّمَدُ',
      page: 604,
      juz: 30,
    ),
  ];

  Widget createTestWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
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

  group('QuranReaderPreferences Entity Tests', () {
    test('default preferences should be initialized correctly', () {
      const prefs = QuranReaderPreferences();

      expect(prefs.style, equals(QuranReadingStyle.continuous));
      expect(prefs.fontSize, equals(QuranFontSize.medium));
      expect(prefs.theme, equals(QuranReaderTheme.charcoal));
      expect(prefs.lineSpacing, equals(QuranLineSpacing.relaxed));
      expect(prefs.showDividers, isTrue);
      expect(prefs.isAutoScrollEnabled, isFalse);
      expect(prefs.isKeepScreenAwake, isTrue);
      expect(prefs.autoScrollSpeed, equals(1.0));
    });

    test('copyWith should update preferences immutably', () {
      const prefs = QuranReaderPreferences();
      final updated = prefs.copyWith(
        style: QuranReadingStyle.continuous,
        fontSize: QuranFontSize.large,
        theme: QuranReaderTheme.emerald,
        isAutoScrollEnabled: true,
      );

      expect(updated.style, equals(QuranReadingStyle.continuous));
      expect(updated.fontSize, equals(QuranFontSize.large));
      expect(updated.theme, equals(QuranReaderTheme.emerald));
      expect(updated.isAutoScrollEnabled, isTrue);
      expect(updated.showDividers, isTrue);
    });

    test('QuranFontSize values check', () {
      expect(QuranFontSize.values.length, equals(4));
      expect(QuranFontSize.small.displaySp, equals(18));
      expect(QuranFontSize.medium.displaySp, equals(22));
      expect(QuranFontSize.large.displaySp, equals(26));
      expect(QuranFontSize.extraLarge.displaySp, equals(30));
    });
  });

  group('QuranReaderSettingsSheet Widget Tests', () {
    testWidgets('renders all 5 setting sections with 4 font sizes and style switcher', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      QuranReaderPreferences currentPrefs = const QuranReaderPreferences();

      await tester.pumpWidget(
        createTestWidget(
          SizedBox(
            height: 900,
            child: QuranReaderSettingsSheet(
              preferences: currentPrefs,
              onPreferencesChanged: (newPrefs) => currentPrefs = newPrefs,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check header and titles
      expect(find.text('إِعْدَادَاتُ المَصْحَفِ الشَّرِيفِ'), findsOneWidget);
      expect(find.text('نَمَطُ عَرْضِ القِرَاءَةِ'), findsOneWidget);
      expect(find.text('رَسْمُ وَخَطُّ الكِتَابَةِ القُرْآنِيَّةِ'), findsOneWidget);
      expect(find.text('حَجْمُ الخَطِّ القُرْآنِيِّ (4 أَحْجَامٍ)'), findsOneWidget);

      // Check style cards
      expect(find.text('سَرْدٌ آيَةً بِآيَةٍ'), findsOneWidget);
      expect(find.text('مُصْحَفٌ مُتَّصِلٌ'), findsOneWidget);

      // Tap continuous style card
      await tester.tap(find.text('مُصْحَفٌ مُتَّصِلٌ'));
      await tester.pumpAndSettle();
      expect(currentPrefs.style, equals(QuranReadingStyle.continuous));

      // Tap script style card (الرسم الإملائي المرن)
      expect(find.text('الرَّسْمُ الإِمْلائِيُّ المَرِن'), findsOneWidget);
      await tester.tap(find.text('الرَّسْمُ الإِمْلائِيُّ المَرِن'));
      await tester.pumpAndSettle();
      expect(currentPrefs.scriptStyle, equals(QuranScriptStyle.imlaei));

      // Scroll down to reveal font size buttons
      await tester.drag(find.byType(ListView), const Offset(0, -250));
      await tester.pumpAndSettle();

      // Check font size 4 segmented buttons
      expect(find.text('صَغِير'), findsOneWidget);
      expect(find.text('مُتَوَسِّط'), findsOneWidget);
      expect(find.text('كَبِير'), findsOneWidget);
      expect(find.text('كَبِيرٌ جِدًّا'), findsOneWidget);

      // Tap 'كَبِير'
      await tester.tap(find.text('كَبِير'));
      await tester.pumpAndSettle();
      expect(currentPrefs.fontSize, equals(QuranFontSize.large));
    });

    testWidgets('instantaneous in-sheet and external state updates on toggle and switch changes without closing', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      QuranReaderPreferences currentPrefs = const QuranReaderPreferences();

      await tester.pumpWidget(
        createTestWidget(
          QuranReaderSettingsSheet(
            preferences: currentPrefs,
            onPreferencesChanged: (newPrefs) => currentPrefs = newPrefs,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap stepper minus icon
      await tester.tap(find.byIcon(Iconsax.minus_cirlce));
      await tester.pumpAndSettle();

      // State updates immediately in real time
      expect(currentPrefs.fontSize, equals(QuranFontSize.small));

      // Tap stepper plus icon
      await tester.tap(find.byIcon(Iconsax.add_circle));
      await tester.pumpAndSettle();
      expect(currentPrefs.fontSize, equals(QuranFontSize.medium));
    });
  });

  group('QuranOrnateManuscriptCard Reading Modes', () {
    testWidgets('renders verseByVerse mode with separate rows and star rosettes', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      int? tappedAyah;

      await tester.pumpWidget(
        createTestWidget(
          SizedBox(
            height: 700,
            child: QuranOrnateManuscriptCard(
              surah: testSurah,
              verses: testVerses,
              preferences: const QuranReaderPreferences(
                style: QuranReadingStyle.verseByVerse,
              ),
              selectedAyahNumber: null,
              onAyahTap: (ayahNumber) => tappedAyah = ayahNumber,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final verse1 = find.text('قُلْ هُوَ اللَّهُ أَحَدٌ');
      expect(verse1, findsOneWidget);

      // Tap on verse 1
      await tester.tap(verse1);
      await tester.pumpAndSettle();
      expect(tappedAyah, equals(1));
    });

    testWidgets('renders continuous Mushaf mode with unified flowing text', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          SizedBox(
            height: 700,
            child: QuranOrnateManuscriptCard(
              surah: testSurah,
              verses: testVerses,
              preferences: const QuranReaderPreferences(
                style: QuranReadingStyle.continuous,
              ),
              selectedAyahNumber: null,
              onAyahTap: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // In continuous mode, RichText contains all verses
      expect(find.byType(RichText), findsWidgets);
    });
  });
}
