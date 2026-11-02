import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_chapter_entity.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_dua_entity.dart';
import 'package:sakina_app/features/hisn_muslim/domain/repositories/hisn_repository.dart';
import 'package:sakina_app/features/hisn_muslim/domain/usecases/get_hisn_chapters_usecase.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/cubit/hisn_cubit.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/widgets/hisn_muslim_screen.dart';

class MockGetHisnChaptersUseCase extends Mock
    implements GetHisnChaptersUseCase {}

class MockHisnRepository extends Mock implements HisnRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGetHisnChaptersUseCase mockGetChaptersUseCase;
  late MockHisnRepository mockRepository;

  const testDua = HisnDuaEntity(
    id: 1,
    chapterId: 1,
    chapterTitle: 'Chapter: When waking up',
    chapterTitleAr: 'أذكار الاستيقاظ من النوم',
    reference: 'Reference: Hisn al-Muslim 1',
    arabic: 'الحمد لله الذي أحيانا',
    english: 'Praise is to Allah',
  );

  const testChapters = [
    HisnChapterEntity(
      id: 1,
      title: 'Chapter: When waking up',
      titleAr: 'أذكار الاستيقاظ من النوم',
      category: 'اليوم والليلة',
      items: [testDua],
    ),
  ];

  setUp(() {
    mockGetChaptersUseCase = MockGetHisnChaptersUseCase();
    mockRepository = MockHisnRepository();

    if (sl.isRegistered<HisnCubit>()) {
      sl.unregister<HisnCubit>();
    }

    sl.registerLazySingleton<HisnCubit>(
      () => HisnCubit(
        getChaptersUseCase: mockGetChaptersUseCase,
        repository: mockRepository,
      ),
    );
  });

  tearDown(() {
    if (sl.isRegistered<HisnCubit>()) {
      sl.unregister<HisnCubit>();
    }
  });

  testWidgets('HisnMuslimScreen renders header, search field, category chips, and chapter cards',
      (tester) async {
    when(() => mockGetChaptersUseCase())
        .thenAnswer((_) async => const Right(testChapters));

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          theme: AppTheme.charcoalLuxury,
          home: const Directionality(
            textDirection: TextDirection.rtl,
            child: HisnMuslimScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('حِصْنُ المُسْلِمِ'), findsOneWidget);
    expect(find.text('ابحث في أبواب وأدعية حصن المسلم...'), findsOneWidget);
    expect(find.text('أذكار الاستيقاظ من النوم'), findsOneWidget);
  });
}
