import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/juz_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/failures/quran_failure.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_juzs_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_last_read_bookmark_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_surah_verses_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_surahs_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/save_last_read_bookmark_usecase.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_cubit.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_state.dart';

class MockGetSurahsUseCase extends Mock implements GetSurahsUseCase {}
class MockGetJuzsUseCase extends Mock implements GetJuzsUseCase {}
class MockGetSurahVersesUseCase extends Mock implements GetSurahVersesUseCase {}
class MockGetLastReadBookmarkUseCase extends Mock implements GetLastReadBookmarkUseCase {}
class MockSaveLastReadBookmarkUseCase extends Mock implements SaveLastReadBookmarkUseCase {}

void main() {
  late QuranCubit cubit;
  late MockGetSurahsUseCase mockGetSurahs;
  late MockGetJuzsUseCase mockGetJuzs;
  late MockGetSurahVersesUseCase mockGetSurahVerses;
  late MockGetLastReadBookmarkUseCase mockGetLastReadBookmark;
  late MockSaveLastReadBookmarkUseCase mockSaveLastReadBookmark;

  setUp(() {
    mockGetSurahs = MockGetSurahsUseCase();
    mockGetJuzs = MockGetJuzsUseCase();
    mockGetSurahVerses = MockGetSurahVersesUseCase();
    mockGetLastReadBookmark = MockGetLastReadBookmarkUseCase();
    mockSaveLastReadBookmark = MockSaveLastReadBookmarkUseCase();

    cubit = QuranCubit(
      getSurahsUseCase: mockGetSurahs,
      getJuzsUseCase: mockGetJuzs,
      getSurahVersesUseCase: mockGetSurahVerses,
      getLastReadBookmarkUseCase: mockGetLastReadBookmark,
      saveLastReadBookmarkUseCase: mockSaveLastReadBookmark,
    );
  });

  tearDown(() {
    cubit.close();
  });

  const tSurahs = [
    SurahEntity(
      id: 1,
      nameArabic: 'الفَاتِحَة',
      englishName: 'Al-Fatihah',
      revelationType: 'مكية',
      versesCount: 7,
      pageNumber: 1,
      juzNumber: 1,
    ),
    SurahEntity(
      id: 2,
      nameArabic: 'البَقَرَة',
      englishName: 'Al-Baqarah',
      revelationType: 'مدنية',
      versesCount: 286,
      pageNumber: 2,
      juzNumber: 1,
    ),
  ];

  const tJuzs = [
    JuzEntity(
      id: 1,
      nameArabic: 'الجُزْءُ 1',
      startSurahName: 'الفَاتِحَة',
      startVerseNumber: 1,
      startPageNumber: 1,
      endPageNumber: 21,
    ),
  ];

  final tBookmark = QuranBookmarkEntity(
    surahId: 1,
    surahName: 'الفَاتِحَة',
    ayahNumber: 1,
    pageNumber: 1,
    timestamp: DateTime(2026, 10, 30),
  );

  test('initial state should be QuranInitial', () {
    expect(cubit.state, const QuranInitial());
  });

  test('loadQuranData should emit [QuranLoading, QuranLoaded] on success', () async {
    when(() => mockGetSurahs(const NoParams())).thenAnswer((_) async => const Right(tSurahs));
    when(() => mockGetJuzs(const NoParams())).thenAnswer((_) async => const Right(tJuzs));
    when(() => mockGetLastReadBookmark(const NoParams())).thenAnswer((_) async => Right(tBookmark));

    final expectedStates = [
      const QuranLoading(),
      QuranLoaded(
        allSurahs: tSurahs,
        filteredSurahs: tSurahs,
        juzs: tJuzs,
        lastReadBookmark: tBookmark,
      ),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.loadQuranData();
  });

  test('loadQuranData should emit [QuranLoading, QuranError] when getSurahs fails', () async {
    const tFailure = QuranDataFetchFailure();
    when(() => mockGetSurahs(const NoParams())).thenAnswer((_) async => const Left(tFailure));
    when(() => mockGetJuzs(const NoParams())).thenAnswer((_) async => const Right(tJuzs));
    when(() => mockGetLastReadBookmark(const NoParams())).thenAnswer((_) async => const Right(null));

    final expectedStates = [
      const QuranLoading(),
      QuranError(message: tFailure.message),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.loadQuranData();
  });

  test('searchSurahs should filter correctly by query', () async {
    when(() => mockGetSurahs(const NoParams())).thenAnswer((_) async => const Right(tSurahs));
    when(() => mockGetJuzs(const NoParams())).thenAnswer((_) async => const Right(tJuzs));
    when(() => mockGetLastReadBookmark(const NoParams())).thenAnswer((_) async => const Right(null));

    await cubit.loadQuranData();

    cubit.searchSurahs('البقرة');

    final state = cubit.state as QuranLoaded;
    expect(state.filteredSurahs.length, 1);
    expect(state.filteredSurahs.first.nameArabic, 'البَقَرَة');
  });
}

