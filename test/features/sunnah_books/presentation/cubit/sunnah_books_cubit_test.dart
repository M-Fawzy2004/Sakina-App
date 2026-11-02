import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/usecases/get_sunnah_books_usecase.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/sunnah_books_cubit.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/sunnah_books_state.dart';

class MockGetSunnahBooksUseCase extends Mock implements GetSunnahBooksUseCase {}

void main() {
  late MockGetSunnahBooksUseCase mockUseCase;
  late SunnahBooksCubit cubit;

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

  setUp(() {
    mockUseCase = MockGetSunnahBooksUseCase();
    cubit = SunnahBooksCubit(getBooksUseCase: mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('SunnahBooksCubit Tests', () {
    test('initial state should be SunnahBooksInitial', () {
      expect(cubit.state, const SunnahBooksInitial());
    });

    test('loadCatalog emits SunnahBooksLoaded on success', () async {
      when(() => mockUseCase())
          .thenAnswer((_) async => const Right([testBook]));

      await cubit.loadCatalog();

      expect(cubit.state, isA<SunnahBooksLoaded>());
      final loaded = cubit.state as SunnahBooksLoaded;
      expect(loaded.allBooks.length, 1);
      expect(loaded.totalHadiths, 7277);
    });

    test('loadCatalog emits SunnahBooksError on failure', () async {
      when(() => mockUseCase())
          .thenAnswer((_) async => const Left(ServerFailure(message: 'خطأ تحميل')));

      await cubit.loadCatalog();

      expect(cubit.state, const SunnahBooksError(message: 'خطأ تحميل'));
    });

    test('searchBooks filters books by title or author', () async {
      when(() => mockUseCase())
          .thenAnswer((_) async => const Right([testBook]));

      await cubit.loadCatalog();
      cubit.searchBooks('البخاري');

      final loaded = cubit.state as SunnahBooksLoaded;
      expect(loaded.filteredBooks.length, 1);

      cubit.searchBooks('غير موجود');
      final notFound = cubit.state as SunnahBooksLoaded;
      expect(notFound.filteredBooks.isEmpty, isTrue);
    });
  });
}

