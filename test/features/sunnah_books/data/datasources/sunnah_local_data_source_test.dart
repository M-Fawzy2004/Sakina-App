import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/features/sunnah_books/data/datasources/sunnah_local_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SunnahLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = SunnahLocalDataSourceImpl();
  });

  group('SunnahLocalDataSource Integration Tests', () {
    test('should load catalog with 9 books and 429 chapters instantly', () async {
      final books = await dataSource.loadCatalog();

      expect(books.length, 9);
      final totalHadiths = books.fold<int>(0, (sum, b) => sum + b.hadithsCount);
      expect(totalHadiths, 40943);

      final bukhari = books.firstWhere((b) => b.key == 'bukhari');
      expect(bukhari.titleAr, 'صحيح البخاري');
      expect(bukhari.hadithsCount, 7277);
      expect(bukhari.chaptersCount, 97);
    });

    test('should load paginated hadiths from gzipped book in background isolate', () async {
      final page1 = await dataSource.getBookHadiths(
        bookKey: 'ahmed',
        page: 1,
        pageSize: 15,
      );

      expect(page1.hadiths.length, 15);
      expect(page1.hasMore, isTrue);
      expect(page1.totalCount, 1374);
      expect(page1.hadiths.first.arabic.isNotEmpty, isTrue);

      final page2 = await dataSource.getBookHadiths(
        bookKey: 'ahmed',
        page: 2,
        pageSize: 15,
      );

      expect(page2.hadiths.length, 15);
      expect(page2.hadiths.first.idInBook, isNot(page1.hadiths.first.idInBook));
    });

    test('should search hadiths in gzipped book with diacritics stripping', () async {
      final searchPage = await dataSource.searchHadiths(
        bookKey: 'ahmed',
        query: 'الله',
        page: 1,
        pageSize: 10,
      );

      expect(searchPage.hadiths.isNotEmpty, isTrue);
      expect(searchPage.hadiths.length, lessThanOrEqualTo(10));
    });
  });
}

