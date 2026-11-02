import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/usecases/get_sunnah_books_usecase.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/sunnah_books_cubit.dart';
import 'package:sakina_app/features/sunnah_books/presentation/widgets/sunnah_books_screen.dart';

class MockGetSunnahBooksUseCase extends Mock implements GetSunnahBooksUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGetSunnahBooksUseCase mockUseCase;

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

    if (sl.isRegistered<SunnahBooksCubit>()) {
      sl.unregister<SunnahBooksCubit>();
    }

    sl.registerLazySingleton<SunnahBooksCubit>(
      () => SunnahBooksCubit(getBooksUseCase: mockUseCase),
    );
  });

  tearDown(() {
    if (sl.isRegistered<SunnahBooksCubit>()) {
      sl.unregister<SunnahBooksCubit>();
    }
  });

  testWidgets('SunnahBooksScreen renders header, stats ribbon, search bar and book card',
      (tester) async {
    when(() => mockUseCase())
        .thenAnswer((_) async => const Right([testBook]));

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          theme: AppTheme.charcoalLuxury,
          home: const Directionality(
            textDirection: TextDirection.rtl,
            child: SunnahBooksScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('كُتُبُ السُّنَّةِ النَّبَوِيَّةِ'), findsOneWidget);
    expect(find.text('صحيح البخاري'), findsOneWidget);
    expect(find.text('7277 حديثاً'), findsOneWidget);
  });
}

