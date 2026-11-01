import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/quran_local_data_source.dart';
import 'package:sakina_app/features/quran_reading/data/models/ayah_model.dart';
import 'package:sakina_app/features/quran_reading/data/models/juz_model.dart';
import 'package:sakina_app/features/quran_reading/data/models/quran_bookmark_model.dart';
import 'package:sakina_app/features/quran_reading/data/models/surah_model.dart';
import 'package:sakina_app/features/quran_reading/data/repositories/quran_repository_impl.dart';

class MockQuranLocalDataSource extends Mock implements QuranLocalDataSource {}

void main() {
  late QuranRepositoryImpl repository;
  late MockQuranLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockQuranLocalDataSource();
    repository = QuranRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  const tSurahModels = [
    SurahModel(
      id: 1,
      nameArabic: 'الفَاتِحَة',
      englishName: 'Al-Fatihah',
      revelationType: 'مكية',
      versesCount: 7,
      pageNumber: 1,
      juzNumber: 1,
    ),
  ];

  const tJuzModels = [
    JuzModel(
      id: 1,
      nameArabic: 'الجُزْءُ 1',
      startSurahName: 'الفَاتِحَة',
      startVerseNumber: 1,
      startPageNumber: 1,
      endPageNumber: 21,
    ),
  ];

  const tAyahModels = [
    AyahModel(
      numberInSurah: 1,
      text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      page: 1,
      juz: 1,
    ),
  ];

  group('QuranRepositoryImpl Local-First', () {
    test('getSurahs returns Right with List<SurahEntity> from local data source', () async {
      when(() => mockLocalDataSource.getSurahs()).thenAnswer((_) async => tSurahModels);

      final result = await repository.getSurahs();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (surahs) => expect(surahs.first.id, 1),
      );
      verify(() => mockLocalDataSource.getSurahs()).called(1);
    });

    test('getJuzs returns Right with List<JuzEntity> from local data source', () async {
      when(() => mockLocalDataSource.getJuzs()).thenAnswer((_) async => tJuzModels);

      final result = await repository.getJuzs();

      expect(result.isRight(), isTrue);
      verify(() => mockLocalDataSource.getJuzs()).called(1);
    });

    test('getSurahVerses returns Right with List<AyahEntity> from local data source', () async {
      when(() => mockLocalDataSource.getSurahVerses(1)).thenAnswer((_) async => tAyahModels);

      final result = await repository.getSurahVerses(1);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right'),
        (verses) => expect(verses.first.numberInSurah, 1),
      );
      verify(() => mockLocalDataSource.getSurahVerses(1)).called(1);
    });

    test('getLastReadBookmark returns bookmark from local data source', () async {
      final tBookmarkModel = QuranBookmarkModel(
        surahId: 1,
        surahName: 'الفَاتِحَة',
        ayahNumber: 1,
        pageNumber: 1,
        timestamp: DateTime(2026, 11, 1),
      );
      when(() => mockLocalDataSource.getLastReadBookmark()).thenAnswer((_) async => tBookmarkModel);

      final result = await repository.getLastReadBookmark();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right'),
        (bookmark) => expect(bookmark?.surahId, 1),
      );
      verify(() => mockLocalDataSource.getLastReadBookmark()).called(1);
    });
  });
}

