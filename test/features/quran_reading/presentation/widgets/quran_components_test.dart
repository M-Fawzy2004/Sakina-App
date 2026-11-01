import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/hizb_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_3d_page_turn.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_hizbs_list.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_mushaf_brand_header.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_state.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_ornate_manuscript_card.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_ornate_surah_header.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_floating_bar.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_view.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_resume_reading_hero.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_surah_mockup_card.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_tab_bar.dart';

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

  const testSurah = SurahEntity(
    id: 18,
    nameArabic: 'الكَهْفِ',
    englishName: 'Al-Kahf',
    versesCount: 110,
    revelationType: 'مَكِّيَّة',
    pageNumber: 293,
    juzNumber: 15,
  );

  group('QuranMushafBrandHeader Widget Tests', () {
    testWidgets('renders brand title «القُرْآنُ الكَرِيمُ» and triggers search', (tester) async {
      bool searchToggled = false;

      await tester.pumpWidget(
        createTestWidget(
          QuranMushafBrandHeader(
            isSearchActive: false,
            onSearchToggle: () => searchToggled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('القُرْآنُ الكَرِيمُ'), findsOneWidget);
      expect(find.byType(QuranMushafBrandHeader), findsOneWidget);

      final searchIcon = find.byType(InkWell);
      await tester.tap(searchIcon);
      await tester.pumpAndSettle();

      expect(searchToggled, isTrue);
    });
  });

  group('QuranResumeReadingHero Widget Tests', () {
    testWidgets('renders hero card with hanging ribbon and triggers resume', (tester) async {
      bool resumed = false;

      await tester.pumpWidget(
        createTestWidget(
          QuranResumeReadingHero(
            bookmark: null,
            onResumeTap: () => resumed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Resume Reading'), findsOneWidget);
      expect(find.textContaining('مُوَاصَلَةُ القِرَاءَةِ'), findsOneWidget);
      expect(find.text('سُورَةُ الكَهْفِ'), findsOneWidget);

      await tester.tap(find.text('سُورَةُ الكَهْفِ'));
      await tester.pumpAndSettle();

      expect(resumed, isTrue);
    });
  });

  group('QuranSurahMockupCard Widget Tests', () {
    testWidgets('renders surah card with English ID numeral (18), English title, meaning, and handles tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestWidget(
          QuranSurahMockupCard(
            surah: testSurah,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('18'), findsOneWidget);
      expect(find.text('Al-Kahf'), findsOneWidget);
      expect(find.text('The Cave'), findsOneWidget);
      expect(find.text('سُورَةُ الكَهْفِ'), findsOneWidget);

      await tester.tap(find.text('سُورَةُ الكَهْفِ'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });

  group('QuranTabBar Widget Tests', () {
    testWidgets('renders 3 tabs («السُّورَة», «الجُزْء», «الحِزْب») and handles tab selection without page tab', (tester) async {
      QuranTab selected = QuranTab.surahs;

      await tester.pumpWidget(
        createTestWidget(
          QuranTabBar(
            selectedTab: selected,
            onTabSelected: (tab) => selected = tab,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الصَّفْحَة'), findsNothing);
      expect(find.text('السُّورَة'), findsOneWidget);
      expect(find.text('الجُزْء'), findsOneWidget);
      expect(find.text('الحِزْب'), findsOneWidget);

      await tester.tap(find.text('الجُزْء'));
      await tester.pumpAndSettle();

      expect(selected, equals(QuranTab.juzs));

      await tester.tap(find.text('الحِزْب'));
      await tester.pumpAndSettle();

      expect(selected, equals(QuranTab.hizbs));
    });
  });

  group('QuranOrnateSurahHeader Widget Tests', () {
    testWidgets('renders arabesque frame with calligraphic surah title', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const QuranOrnateSurahHeader(surah: testSurah),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('سُورَةُ الكَهْفِ'), findsOneWidget);
      expect(find.byType(QuranOrnateSurahHeader), findsOneWidget);
    });
  });

  group('Quran3dPageTurn Widget Tests', () {
    testWidgets('renders child with 3D transform without crashing', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const Quran3dPageTurn(
            pageIndex: 0,
            currentPageValue: 0.3,
            child: Text('3D Page Turn Test Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('3D Page Turn Test Content'), findsOneWidget);
    });
  });

  group('QuranReaderFloatingBar Widget Tests', () {
    testWidgets('renders navigation info and responds to tap actions', (tester) async {
      bool playTapped = false;
      bool tafsirTapped = false;
      bool copyTapped = false;
      bool bookmarkTapped = false;
      bool prevTapped = false;
      bool nextTapped = false;

      await tester.pumpWidget(
        createTestWidget(
          QuranReaderFloatingBar(
            pageNumber: 293,
            juzNumber: 15,
            selectedAyahNumber: 5,
            onPreviousPage: () => prevTapped = true,
            onNextPage: () => nextTapped = true,
            onPlay: () => playTapped = true,
            onTafsir: () => tafsirTapped = true,
            onCopy: () => copyTapped = true,
            onBookmark: () => bookmarkTapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الآية 5'), findsOneWidget);
      expect(find.byTooltip('تِلَاوَة'), findsOneWidget);
      expect(find.byTooltip('تَفْسِير'), findsOneWidget);
      expect(find.byTooltip('نَسْخ'), findsOneWidget);
      expect(find.byTooltip('حِفْظ'), findsOneWidget);

      await tester.tap(find.byTooltip('تِلَاوَة'));
      await tester.pumpAndSettle();
      expect(playTapped, isTrue);

      await tester.tap(find.byTooltip('تَفْسِير'));
      await tester.pumpAndSettle();
      expect(tafsirTapped, isTrue);

      await tester.tap(find.byTooltip('نَسْخ'));
      await tester.pumpAndSettle();
      expect(copyTapped, isTrue);

      await tester.tap(find.byTooltip('حِفْظ'));
      await tester.pumpAndSettle();
      expect(bookmarkTapped, isTrue);

      await tester.tap(find.byTooltip('الصفحة السابقة'));
      await tester.pumpAndSettle();
      expect(prevTapped, isTrue);

      await tester.tap(find.byTooltip('الصفحة التالية'));
      await tester.pumpAndSettle();
      expect(nextTapped, isTrue);
    });

    testWidgets('displays pause button when audio is actively playing', (tester) async {
      bool pauseTapped = false;

      await tester.pumpWidget(
        createTestWidget(
          QuranReaderFloatingBar(
            pageNumber: 1,
            juzNumber: 1,
            selectedAyahNumber: 2,
            isAudioPlaying: true,
            onPreviousPage: () {},
            onNextPage: () {},
            onPlay: () => pauseTapped = true,
            onTafsir: () {},
            onCopy: () {},
            onBookmark: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byTooltip('إِيقَافٌ مُؤَقَّت'), findsOneWidget);
      expect(find.byIcon(Iconsax.pause), findsOneWidget);

      await tester.tap(find.byTooltip('إِيقَافٌ مُؤَقَّت'));
      await tester.pumpAndSettle();
      expect(pauseTapped, isTrue);
    });
  });

  group('QuranReaderView Widget Tests', () {
    testWidgets('renders illuminated manuscript card, top bar, and responds to back tap', (tester) async {
      bool closed = false;

      const testVerses = [
        AyahEntity(
          numberInSurah: 1,
          text: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
          page: 1,
          juz: 1,
        ),
        AyahEntity(
          numberInSurah: 2,
          text: 'الرَّحْمَٰنِ الرَّحِيمِ',
          page: 1,
          juz: 1,
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          QuranReaderView(
            surah: testSurah,
            verses: testVerses,
            onClose: () => closed = true,
            onBookmarkSaved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('سُورَةُ الكَهْفِ'), findsOneWidget);
      expect(find.textContaining('الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ'), findsOneWidget);
      expect(find.textContaining('الرَّحْمَٰنِ الرَّحِيمِ'), findsNWidgets(2));

      final backButton = find.byIcon(Iconsax.arrow_right_3).first;
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(closed, isTrue);
    });

    testWidgets('paginates verses into chapters and supports horizontal navigation', (tester) async {
      // 45 verses: page 1 (1-20), page 2 (21-40), page 3 (41-45)
      final testVerses = List.generate(
        45,
        (i) => AyahEntity(
          numberInSurah: i + 1,
          text: 'آيَةُ رَقْمِ ${i + 1}',
          page: 1,
          juz: 1,
        ),
      );

      await tester.pumpWidget(
        createTestWidget(
          QuranReaderView(
            surah: testSurah,
            verses: testVerses,
            onClose: () {},
            onBookmarkSaved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check first page shows verses 1-20
      expect(find.textContaining('آيَةُ رَقْمِ 1'), findsWidgets);
      expect(find.textContaining('آيَةُ رَقْمِ 20'), findsWidgets);
      // Verse 25 is on page 2, so not on page 1
      expect(find.textContaining('آيَةُ رَقْمِ 25'), findsNothing);

      // Verify page label on manuscript card: صَفْحَةُ 1 مِنْ 3
      expect(find.textContaining('صَفْحَةُ 1 مِنْ 3'), findsOneWidget);

      // Fling horizontally in RTL (positive Offset x) to page 2 via PageView
      await tester.fling(find.byType(PageView), const Offset(400, 0), 1000.0);
      await tester.pumpAndSettle();

      // Now on page 2: verses 21-40
      expect(find.textContaining('آيَةُ رَقْمِ 21'), findsWidgets);
      expect(find.textContaining('آيَةُ رَقْمِ 40'), findsWidgets);
      expect(find.textContaining('صَفْحَةُ 2 مِنْ 3'), findsOneWidget);

      // Fling again to go to page 3 (verses 41-45)
      await tester.fling(find.byType(PageView), const Offset(400, 0), 1000.0);
      await tester.pumpAndSettle();

      expect(find.textContaining('آيَةُ رَقْمِ 41'), findsWidgets);
      expect(find.textContaining('آيَةُ رَقْمِ 45'), findsWidgets);
      expect(find.textContaining('صَفْحَةُ 3 مِنْ 3'), findsOneWidget);
    });
  });

  group('QuranOrnateManuscriptCard Audio Tests', () {
    testWidgets('renders per-ayah play button and triggers onPlayAyah callback', (tester) async {
      int? playedAyah;
      const testVerses = [
        AyahEntity(
          numberInSurah: 1,
          text: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
          page: 1,
          juz: 1,
        ),
        AyahEntity(
          numberInSurah: 2,
          text: 'الرَّحْمَٰنِ الرَّحِيمِ',
          page: 1,
          juz: 1,
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          QuranOrnateManuscriptCard(
            surah: testSurah,
            verses: testVerses,
            preferences: const QuranReaderPreferences(
              style: QuranReadingStyle.verseByVerse,
            ),
            selectedAyahNumber: null,
            recitingAyahNumber: 1,
            isAyahAudioPlaying: true,
            onAyahTap: (_) {},
            onPlayAyah: (ayah) => playedAyah = ayah,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Ayah 1 is reciting & playing: should display pause icon
      expect(find.byIcon(Iconsax.pause), findsOneWidget);
      // Ayah 2 is not reciting: should display play icon
      expect(find.byIcon(Iconsax.play), findsOneWidget);

      // Tap on Ayah 2 play button
      await tester.tap(find.byIcon(Iconsax.play));
      await tester.pumpAndSettle();

      expect(playedAyah, 2);
    });
  });

  group('HizbEntity Authentic Dataset Tests', () {
    test('contains exactly 60 authentic Hizbs', () {
      expect(HizbEntity.allHizbs.length, 60);
    });

    test('verifies accurate starting verse and page mappings', () {
      final hizb1 = HizbEntity.allHizbs[0];
      expect(hizb1.number, 1);
      expect(hizb1.juzNumber, 1);
      expect(hizb1.surahId, 1);
      expect(hizb1.startVerseNumber, 1);
      expect(hizb1.startPageNumber, 1);

      final hizb3 = HizbEntity.allHizbs[2];
      expect(hizb3.number, 3);
      expect(hizb3.juzNumber, 2);
      expect(hizb3.surahId, 2);
      expect(hizb3.startVerseNumber, 142);
      expect(hizb3.startPageNumber, 22);

      final hizb5 = HizbEntity.allHizbs[4];
      expect(hizb5.number, 5);
      expect(hizb5.juzNumber, 3);
      expect(hizb5.surahId, 2);
      expect(hizb5.startVerseNumber, 253);
      expect(hizb5.startPageNumber, 42);

      final hizb60 = HizbEntity.allHizbs[59];
      expect(hizb60.number, 60);
      expect(hizb60.juzNumber, 30);
      expect(hizb60.surahId, 87);
      expect(hizb60.startVerseNumber, 1);
      expect(hizb60.startPageNumber, 591);
    });
  });

  group('QuranHizbsList Widget Tests', () {
    testWidgets('renders list of Hizbs and triggers onHizbTap with HizbEntity', (tester) async {
      HizbEntity? tappedHizb;

      await tester.pumpWidget(
        createTestWidget(
          CustomScrollView(
            slivers: [
              QuranHizbsList(
                allSurahs: const [testSurah],
                onHizbTap: (hizb) => tappedHizb = hizb,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الحِزْبُ 1'), findsOneWidget);
      expect(find.text('الحِزْبُ 2'), findsOneWidget);

      await tester.tap(find.text('الحِزْبُ 1'));
      await tester.pumpAndSettle();

      expect(tappedHizb, isNotNull);
      expect(tappedHizb!.number, 1);
      expect(tappedHizb!.startVerseNumber, 1);
    });
  });

  group('QuranReaderView Initial Ayah Navigation Tests', () {
    testWidgets('jumps directly to target page and selects initialAyahNumber', (tester) async {
      final longVersesList = List.generate(
        60,
        (i) => AyahEntity(
          numberInSurah: i + 1,
          text: 'آيَةُ رَقْمِ ${i + 1}',
          page: 10 + (i ~/ 20),
          juz: 2,
        ),
      );

      await tester.pumpWidget(
        createTestWidget(
          QuranReaderView(
            surah: testSurah,
            verses: longVersesList,
            initialAyahNumber: 25,
            onClose: () {},
            onBookmarkSaved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Because verse 25 is on page index 1 (verses 21-40), verses 21 through 40 are rendered
      expect(find.text('21'), findsWidgets);
      expect(find.text('25'), findsWidgets);
      expect(find.text('40'), findsWidgets);
      // Floating bar indicates Ayah 25 is actively selected
      expect(find.textContaining('الآية 25'), findsOneWidget);
      expect(find.textContaining('آيَةُ رَقْمِ 25'), findsWidgets);
    });
  });
}
