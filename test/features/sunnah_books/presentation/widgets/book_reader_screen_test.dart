import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_page_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_chapter_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/usecases/get_book_hadiths_usecase.dart';
import 'package:sakina_app/features/sunnah_books/domain/usecases/search_hadiths_usecase.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/book_reader_cubit.dart';
import 'package:sakina_app/features/sunnah_books/presentation/widgets/book_reader_screen.dart';

class MockGetBookHadithsUseCase extends Mock implements GetBookHadithsUseCase {}
class MockSearchHadithsUseCase extends Mock implements SearchHadithsUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGetBookHadithsUseCase mockGetHadithsUseCase;
  late MockSearchHadithsUseCase mockSearchHadithsUseCase;

  const testBook = SunnahBookEntity(
    id: 1,
    key: 'bukhari',
    titleAr: 'صحيح البخاري',
    titleEn: 'Sahih al-Bukhari',
    authorAr: 'الإمام البخاري',
    authorEn: 'Imam Bukhari',
    introductionAr: '',
    hadithsCount: 7277,
    chaptersCount: 1,
    chapters: [
      SunnahChapterEntity(
        id: 1,
        bookId: 1,
        arabic: 'كتاب بدء الوحي',
        english: 'Revelation',
      ),
    ],
  );

  const testHadith = HadithEntity(
    id: 1,
    idInBook: 1,
    chapterId: 1,
    bookId: 1,
    arabic: 'إنما الأعمال بالنيات وإنما لكل امرئ ما نوى',
    englishNarrator: '',
    englishText: '',
  );

  setUp(() {
    mockGetHadithsUseCase = MockGetBookHadithsUseCase();
    mockSearchHadithsUseCase = MockSearchHadithsUseCase();

    if (sl.isRegistered<BookReaderCubit>()) {
      sl.unregister<BookReaderCubit>();
    }

    sl.registerFactory<BookReaderCubit>(
      () => BookReaderCubit(
        getHadithsUseCase: mockGetHadithsUseCase,
        searchHadithsUseCase: mockSearchHadithsUseCase,
      ),
    );
  });

  tearDown(() {
    if (sl.isRegistered<BookReaderCubit>()) {
      sl.unregister<BookReaderCubit>();
    }
  });

  testWidgets('BookReaderScreen renders fixed top bar, chapter chips row, and hadith page card',
      (tester) async {
    when(() => mockGetHadithsUseCase(
          bookKey: 'bukhari',
          chapterId: null,
          page: 1,
          pageSize: any(named: 'pageSize'),
        )).thenAnswer((_) async => const Right(HadithPageEntity(
          hadiths: [testHadith],
          page: 1,
          pageSize: 20,
          totalCount: 7277,
          hasMore: true,
        )));

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          theme: AppTheme.charcoalLuxury,
          home: const Directionality(
            textDirection: TextDirection.rtl,
            child: BookReaderScreen(book: testBook),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Title & Subtitle in Fixed Top Bar
    expect(find.text('صحيح البخاري'), findsOneWidget);

    // Verify Chapters row
    expect(find.text('جميع الأبواب'), findsOneWidget);
    expect(find.text('كتاب بدء الوحي'), findsWidgets);

    // Verify Hadith Card content (Pure Arabic)
    expect(find.text('حديث #1'), findsOneWidget);
    expect(find.text('إنما الأعمال بالنيات وإنما لكل امرئ ما نوى'), findsOneWidget);
    expect(find.text('1 / 7277'), findsOneWidget);
  });
}

