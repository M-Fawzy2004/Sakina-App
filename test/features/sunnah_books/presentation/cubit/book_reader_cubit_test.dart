import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_page_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/usecases/get_book_hadiths_usecase.dart';
import 'package:sakina_app/features/sunnah_books/domain/usecases/search_hadiths_usecase.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/book_reader_cubit.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/book_reader_state.dart';

class MockGetBookHadithsUseCase extends Mock implements GetBookHadithsUseCase {}

class MockSearchHadithsUseCase extends Mock implements SearchHadithsUseCase {}

void main() {
  late MockGetBookHadithsUseCase mockGetHadithsUseCase;
  late MockSearchHadithsUseCase mockSearchHadithsUseCase;
  late BookReaderCubit cubit;

  const testBook = SunnahBookEntity(
    id: 1,
    key: 'bukhari',
    titleAr: 'صحيح البخاري',
    titleEn: 'Sahih al-Bukhari',
    authorAr: 'الإمام البخاري',
    authorEn: 'Imam Bukhari',
    introductionAr: '',
    hadithsCount: 7277,
    chaptersCount: 97,
    chapters: [],
  );

  const testHadith1 = HadithEntity(
    id: 1,
    idInBook: 1,
    chapterId: 1,
    bookId: 1,
    arabic: 'إنما الأعمال بالنيات',
    englishNarrator: 'Narrated Umar',
    englishText: 'Actions are according to intentions',
  );

  const testHadith2 = HadithEntity(
    id: 2,
    idInBook: 2,
    chapterId: 1,
    bookId: 1,
    arabic: 'حديث آخر',
    englishNarrator: '',
    englishText: '',
  );

  setUp(() {
    mockGetHadithsUseCase = MockGetBookHadithsUseCase();
    mockSearchHadithsUseCase = MockSearchHadithsUseCase();
    cubit = BookReaderCubit(
      getHadithsUseCase: mockGetHadithsUseCase,
      searchHadithsUseCase: mockSearchHadithsUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('BookReaderCubit Tests', () {
    test('initial state should be BookReaderInitial', () {
      expect(cubit.state, const BookReaderInitial());
    });

    test('initBook loads page 1 and emits BookReaderLoaded', () async {
      when(() => mockGetHadithsUseCase(
            bookKey: 'bukhari',
            chapterId: null,
            page: 1,
            pageSize: 20,
          )).thenAnswer((_) async => const Right(HadithPageEntity(
            hadiths: [testHadith1],
            page: 1,
            pageSize: 20,
            totalCount: 7277,
            hasMore: true,
          )));

      await cubit.initBook(testBook);

      expect(cubit.state, isA<BookReaderLoaded>());
      final loaded = cubit.state as BookReaderLoaded;
      expect(loaded.hadiths.length, 1);
      expect(loaded.currentPage, 1);
      expect(loaded.hasMore, isTrue);
    });

    test('loadNextPage appends hadiths to list', () async {
      when(() => mockGetHadithsUseCase(
            bookKey: 'bukhari',
            chapterId: null,
            page: 1,
            pageSize: 20,
          )).thenAnswer((_) async => const Right(HadithPageEntity(
            hadiths: [testHadith1],
            page: 1,
            pageSize: 20,
            totalCount: 2,
            hasMore: true,
          )));

      when(() => mockGetHadithsUseCase(
            bookKey: 'bukhari',
            chapterId: null,
            page: 2,
            pageSize: 20,
          )).thenAnswer((_) async => const Right(HadithPageEntity(
            hadiths: [testHadith2],
            page: 2,
            pageSize: 20,
            totalCount: 2,
            hasMore: false,
          )));

      await cubit.initBook(testBook);
      await cubit.loadNextPage();

      final loaded = cubit.state as BookReaderLoaded;
      expect(loaded.hadiths.length, 2);
      expect(loaded.currentPage, 2);
      expect(loaded.hasMore, isFalse);
    });
  });
}
