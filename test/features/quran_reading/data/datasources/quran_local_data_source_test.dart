import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/quran_local_data_source.dart';
import 'package:sakina_app/features/quran_reading/data/models/quran_bookmark_model.dart';

class MockPreferencesService extends Mock implements PreferencesService {}
class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late QuranLocalDataSourceImpl dataSource;
  late MockPreferencesService mockPreferencesService;
  late MockAssetBundle mockAssetBundle;

  setUp(() {
    mockPreferencesService = MockPreferencesService();
    mockAssetBundle = MockAssetBundle();
    dataSource = QuranLocalDataSourceImpl(
      preferencesService: mockPreferencesService,
      assetBundle: mockAssetBundle,
    );
  });

  group('QuranLocalDataSourceImpl', () {
    test('getSurahs returns all 114 Surahs offline', () async {
      final surahs = await dataSource.getSurahs();
      expect(surahs.length, 114);
      expect(surahs.first.id, 1);
      expect(surahs.first.nameArabic, 'الفَاتِحَة');
      expect(surahs.last.id, 114);
      expect(surahs.last.nameArabic, 'النَّاس');
    });

    test('getJuzs returns all 30 Juzs offline', () async {
      final juzs = await dataSource.getJuzs();
      expect(juzs.length, 30);
      expect(juzs.first.id, 1);
      expect(juzs.last.id, 30);
    });

    test('getSurahVerses loads and parses target offline JSON correctly', () async {
      const mockJson = '''
      {
        "surah": "الفاتحة",
        "number": 1,
        "ayahs": [
          {
            "ayah_number": 1,
            "text": "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ",
            "tafsir": [
              { "type": "التفسير المختصر", "text": "باسم الله أبدأ قراءة القرآن..." },
              { "type": "تفسير الجلالين", "text": "«بسم الله الرحمن الرحيم»" },
              { "type": "تفسير السعدي", "text": "بِسْمِ اللَّهِ أي: أبتدئ بكل اسم لله تعالى..." }
            ]
          },
          {
            "ayah_number": 2,
            "text": "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
            "tafsir": [
              { "type": "التفسير المختصر", "text": "الثناء الكامل لله وحده..." }
            ]
          }
        ]
      }
      ''';

      when(() => mockAssetBundle.loadString('assets/quran_data/001_al-fatiha.json'))
          .thenAnswer((_) async => mockJson);

      final verses = await dataSource.getSurahVerses(1);

      expect(verses.length, 2);
      expect(verses[0].numberInSurah, 1);
      expect(verses[0].text, 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ');
      expect(verses[0].tafsirs.length, 3);
      expect(verses[0].tafsirs[0].type, 'التفسير المختصر');
      expect(verses[0].tafsirs[1].type, 'تفسير الجلالين');
      expect(verses[0].tafsirs[2].type, 'تفسير السعدي');
      expect(verses[0].tafsir, 'باسم الله أبدأ قراءة القرآن...');

      expect(verses[1].numberInSurah, 2);
      expect(verses[1].text, 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ');
      expect(verses[1].tafsirs.length, 1);

      // Verify second call is served from in-memory cache (loadString not called again)
      final cachedVerses = await dataSource.getSurahVerses(1);
      expect(cachedVerses, same(verses));
      verify(() => mockAssetBundle.loadString('assets/quran_data/001_al-fatiha.json')).called(1);
    });

    test('getSurahVerses falls back gracefully when asset cannot be loaded', () async {
      when(() => mockAssetBundle.loadString(any()))
          .thenThrow(Exception('Asset not found'));

      final verses = await dataSource.getSurahVerses(114);

      expect(verses.isNotEmpty, isTrue);
      expect(verses.first.numberInSurah, 1);
      expect(verses.first.text, contains('النَّاسِ'));
    });

    test('getLastReadBookmark returns default initial bookmark when uninitialized', () async {
      when(() => mockPreferencesService.getString(any())).thenReturn(null);

      final bookmark = await dataSource.getLastReadBookmark();

      expect(bookmark, isNotNull);
      expect(bookmark!.surahId, 55);
      expect(bookmark.surahName, contains('الرَّحْمَٰن'));
    });

    test('saveLastReadBookmark persists bookmark to preferences', () async {
      final bookmark = QuranBookmarkModel(
        surahId: 18,
        surahName: 'الكَهْف',
        ayahNumber: 1,
        pageNumber: 293,
        timestamp: DateTime(2026, 11, 1),
      );

      when(() => mockPreferencesService.setString(any(), any()))
          .thenAnswer((_) async => true);

      await dataSource.saveLastReadBookmark(bookmark);

      verify(() => mockPreferencesService.setString(
            any(),
            any(that: contains('الكَهْف')),
          )).called(1);
    });
  });
}

