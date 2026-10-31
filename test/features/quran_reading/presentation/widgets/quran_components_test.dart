import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_3d_page_turn.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_mushaf_brand_header.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_state.dart';
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
    testWidgets('renders 4 tabs («الصَّفْحَة», «السُّورَة», «الجُزْء», «الحِزْب») and handles tab selection', (tester) async {
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

      expect(find.text('الصَّفْحَة'), findsOneWidget);
      expect(find.text('السُّورَة'), findsOneWidget);
      expect(find.text('الجُزْء'), findsOneWidget);
      expect(find.text('الحِزْب'), findsOneWidget);

      await tester.tap(find.text('الجُزْء'));
      await tester.pumpAndSettle();

      expect(selected, equals(QuranTab.juzs));

      await tester.tap(find.text('الصَّفْحَة'));
      await tester.pumpAndSettle();

      expect(selected, equals(QuranTab.page));
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
      expect(find.text('الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('الرَّحْمَٰنِ الرَّحِيمِ'),
        100.0,
      );
      expect(find.text('الرَّحْمَٰنِ الرَّحِيمِ'), findsOneWidget);

      final backButton = find.byIcon(Iconsax.arrow_left_2).first;
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(closed, isTrue);
    });
  });
}
