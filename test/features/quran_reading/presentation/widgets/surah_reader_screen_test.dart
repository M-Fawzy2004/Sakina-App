import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_cubit.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_state.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/manuscript/quran_manuscript_header_footer.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_view.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_shimmer.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/surah_reader_screen.dart';

class MockQuranCubit extends Mock implements QuranCubit {}
class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockQuranCubit mockCubit;
  late MockPreferencesService mockPrefs;
  late StreamController<QuranState> stateController;

  const surahFatihah = SurahEntity(
    id: 1,
    nameArabic: 'الفَاتِحَة',
    englishName: 'Al-Fatihah',
    versesCount: 7,
    revelationType: 'مَكِّيَّة',
    pageNumber: 1,
    juzNumber: 1,
  );

  const surahBaqarah = SurahEntity(
    id: 2,
    nameArabic: 'البَقَرَة',
    englishName: 'Al-Baqarah',
    versesCount: 286,
    revelationType: 'مَدَنِيَّة',
    pageNumber: 2,
    juzNumber: 1,
  );

  const fatihahAyahs = [
    AyahEntity(
      numberInSurah: 1,
      text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      page: 1,
      juz: 1,
    ),
  ];

  const baqarahAyahs = [
    AyahEntity(
      numberInSurah: 1,
      text: 'الۤمۤ',
      page: 2,
      juz: 1,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(surahFatihah);
  });

  setUp(() {
    mockCubit = MockQuranCubit();
    mockPrefs = MockPreferencesService();
    stateController = StreamController<QuranState>.broadcast();

    if (sl.isRegistered<PreferencesService>()) {
      sl.unregister<PreferencesService>();
    }
    sl.registerSingleton<PreferencesService>(mockPrefs);
    when(() => mockPrefs.getString(any())).thenReturn(null);
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
    when(() => mockCubit.stream).thenAnswer((_) => stateController.stream);
    when(() => mockCubit.openSurahReader(any())).thenAnswer((_) async {});
    when(() => mockCubit.closeSurahReader()).thenReturn(null);
    when(() => mockCubit.close()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await stateController.close();
    if (sl.isRegistered<PreferencesService>()) {
      sl.unregister<PreferencesService>();
    }
  });

  Widget buildTestApp({required Widget child}) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocProvider<QuranCubit>.value(
            value: mockCubit,
            child: child,
          ),
        ),
      ),
    );
  }

  group('SurahReaderScreen Tests', () {
    testWidgets('renders QuranShimmer when state is not QuranLoaded', (tester) async {
      when(() => mockCubit.state).thenReturn(const QuranInitial());

      await tester.pumpWidget(
        buildTestApp(child: const SurahReaderScreen(surah: surahFatihah)),
      );

      expect(find.byType(QuranShimmer), findsOneWidget);
      expect(find.byType(QuranReaderView), findsNothing);
    });

    testWidgets('renders QuranReaderView when surah and verses are loaded', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const QuranLoaded(
          allSurahs: [surahFatihah, surahBaqarah],
          filteredSurahs: [surahFatihah, surahBaqarah],
          juzs: [],
          activeReadingSurah: surahFatihah,
          activeVerses: fatihahAyahs,
        ),
      );

      await tester.pumpWidget(
        buildTestApp(child: const SurahReaderScreen(surah: surahFatihah)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(QuranReaderView), findsOneWidget);
      expect(find.byType(QuranShimmer), findsNothing);
    });

    testWidgets('transitions seamlessly to next surah without getting stuck on QuranShimmer', (tester) async {
      var currentState = const QuranLoaded(
        allSurahs: [surahFatihah, surahBaqarah],
        filteredSurahs: [surahFatihah, surahBaqarah],
        juzs: [],
        activeReadingSurah: surahFatihah,
        activeVerses: fatihahAyahs,
      );
      when(() => mockCubit.state).thenAnswer((_) => currentState);

      await tester.pumpWidget(
        buildTestApp(child: const SurahReaderScreen(surah: surahFatihah)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(QuranReaderView), findsOneWidget);
      expect(find.textContaining('الفَاتِحَة'), findsWidgets);

      // Trigger surah change via reader callback
      final readerView = tester.widget<QuranReaderView>(find.byType(QuranReaderView));
      readerView.onSurahChanged?.call(surahBaqarah);

      // Verify cubit was requested to open the new surah
      verify(() => mockCubit.openSurahReader(surahBaqarah)).called(1);

      // Cubit emits loaded state for Surah Al-Baqarah
      currentState = const QuranLoaded(
        allSurahs: [surahFatihah, surahBaqarah],
        filteredSurahs: [surahFatihah, surahBaqarah],
        juzs: [],
        activeReadingSurah: surahBaqarah,
        activeVerses: baqarahAyahs,
      );
      stateController.add(currentState);

      await tester.pumpAndSettle();

      // Crucial: verify that the screen renders QuranReaderView with Al-Baqarah and is NOT stuck on QuranShimmer
      expect(find.byType(QuranShimmer), findsNothing);
      expect(find.byType(QuranReaderView), findsOneWidget);
      expect(find.textContaining('البَقَرَة'), findsWidgets);
    });
  });

  group('QuranNextSectionFooter Widget Tests', () {
    testWidgets('renders next surah banner with clean Almarai font text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: QuranNextSectionFooter(
            isLastPageOfSurah: true,
            nextSurahName: 'البقرة',
            nextPageNumber: 2,
            totalPages: 1,
            accentColor: Colors.amber,
            cardColor: Colors.black,
            textColor: Colors.white,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('السورة التالية: سورة البقرة'), findsOneWidget);
    });

    testWidgets('renders next page banner when not the last page', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: QuranNextSectionFooter(
            isLastPageOfSurah: false,
            nextSurahName: 'البقرة',
            nextPageNumber: 2,
            totalPages: 5,
            accentColor: Colors.amber,
            cardColor: Colors.black,
            textColor: Colors.white,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('الصفحة التالية (2 من 5)'), findsOneWidget);
    });
  });
}
