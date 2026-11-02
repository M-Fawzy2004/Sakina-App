import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/features/hisn_muslim/data/datasources/hisn_local_data_source.dart';
import 'package:sakina_app/features/hisn_muslim/data/datasources/static/hisn_arabic_titles_map.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HisnArabicTitlesMap Tests', () {
    test('should map all standard chapters to proper Arabic titles and categories', () {
      final meta = HisnArabicTitlesMap.getMeta('Chapter: When waking up');
      expect(meta.titleAr, 'أذكار الاستيقاظ من النوم');
      expect(meta.category, 'اليوم والليلة');

      final metaAthan = HisnArabicTitlesMap.getMeta('Chapter: Concerning the athan (the call to prayer)');
      expect(metaAthan.titleAr, 'أذكار الأذان');
      expect(metaAthan.category, 'الصلوات والمساجد');
    });

    test('should return fallback metadata for unknown chapters', () {
      final meta = HisnArabicTitlesMap.getMeta('Chapter: Custom Unknown Chapter');
      expect(meta.titleAr, 'Custom Unknown Chapter');
      expect(meta.category, 'أدعية جامعة');
    });
  });

  group('HisnLocalDataSource Integration Tests', () {
    late HisnLocalDataSourceImpl dataSource;

    setUp(() {
      dataSource = HisnLocalDataSourceImpl();
    });

    test('should load all 132 chapters and 268 duas from local asset', () async {
      final chapters = await dataSource.loadChapters();

      expect(chapters.length, 132);
      final totalDuas = chapters.fold<int>(0, (sum, c) => sum + c.itemCount);
      expect(totalDuas, 268);

      final firstChapter = chapters.first;
      expect(firstChapter.id, 1);
      expect(firstChapter.titleAr, 'أذكار الاستيقاظ من النوم');
      expect(firstChapter.items.length, 4);
    });

    test('should retrieve chapter by ID', () async {
      final chapter = await dataSource.getChapterById(1);
      expect(chapter.id, 1);
      expect(chapter.titleAr, 'أذكار الاستيقاظ من النوم');
    });

    test('should search duas across arabic text with diacritics stripping', () async {
      final results = await dataSource.searchDuas('الحمد لله الذي احيانا');
      expect(results.isNotEmpty, isTrue);
      expect(results.first.arabic, contains('الحَمْـدُ لِلّهِ'));
    });
  });
}

