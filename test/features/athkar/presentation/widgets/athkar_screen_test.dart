import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_category_entity.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_item_entity.dart';
import 'package:sakina_app/features/athkar/domain/usecases/get_athkar_by_category_usecase.dart';
import 'package:sakina_app/features/athkar/domain/usecases/get_athkar_categories_usecase.dart';
import 'package:sakina_app/features/athkar/presentation/cubit/athkar_cubit.dart';
import 'package:sakina_app/features/athkar/presentation/widgets/athkar_screen.dart';

class MockGetAthkarCategoriesUseCase extends Mock
    implements GetAthkarCategoriesUseCase {}

class MockGetAthkarByCategoryUseCase extends Mock
    implements GetAthkarByCategoryUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGetAthkarCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetAthkarByCategoryUseCase mockGetByCategoryUseCase;

  const testCategories = [
    AthkarCategoryEntity(
      name: 'أذكار الصباح',
      count: 2,
      description: 'نور الصباح وبركة اليوم',
      iconKey: 'morning',
    ),
    AthkarCategoryEntity(
      name: 'أذكار المساء',
      count: 1,
      description: 'حصن المساء',
      iconKey: 'evening',
    ),
  ];

  const testMorningItems = [
    AthkarItemEntity(
      category: 'أذكار الصباح',
      count: 3,
      description: 'من قالها حين يصبح كان حقاً على الله أن يرضيه',
      reference: 'رواه الترمذي',
      content: 'رضيت بالله رباً وبالإسلام ديناً وبمحمد نبياً',
    ),
  ];

  setUp(() {
    mockGetCategoriesUseCase = MockGetAthkarCategoriesUseCase();
    mockGetByCategoryUseCase = MockGetAthkarByCategoryUseCase();

    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const GetAthkarByCategoryParams(category: 'أذكار الصباح'),
    );

    when(() => mockGetCategoriesUseCase(any()))
        .thenAnswer((_) async => const Right(testCategories));
    when(() => mockGetByCategoryUseCase(any()))
        .thenAnswer((_) async => const Right(testMorningItems));

    if (sl.isRegistered<AthkarCubit>()) {
      sl.unregister<AthkarCubit>();
    }

    sl.registerFactory<AthkarCubit>(
      () => AthkarCubit(
        getCategoriesUseCase: mockGetCategoriesUseCase,
        getAthkarByCategoryUseCase: mockGetByCategoryUseCase,
      ),
    );
  });

  tearDown(() {
    if (sl.isRegistered<AthkarCubit>()) {
      sl.unregister<AthkarCubit>();
    }
  });

  Widget createTestWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.charcoalLuxury,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        ),
      ),
    );
  }

  group('AthkarScreen Widget Tests', () {
    testWidgets('renders header, categories, progress card, and thikr items', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const AthkarScreen()),
      );
      await tester.pumpAndSettle();

      // Header verification
      expect(find.text('الأَذْكَارُ وَالمَسَابِحُ'), findsOneWidget);
      expect(find.text('حِصْنُ المُسْلِمِ وَأَوْرَادُ السَّكِينَةِ'), findsOneWidget);

      // Category Chips
      expect(find.text('أذكار الصباح'), findsWidgets);
      expect(find.text('أذكار المساء'), findsWidgets);

      // Thikr Content
      expect(find.text('رضيت بالله رباً وبالإسلام ديناً وبمحمد نبياً'), findsOneWidget);
      expect(find.text('من قالها حين يصبح كان حقاً على الله أن يرضيه'), findsOneWidget);

      final counterFinder = find.text('المُتَبَقِّي: 3');
      expect(counterFinder, findsOneWidget);

      // Ensure visible and Tap Counter
      await tester.ensureVisible(counterFinder);
      await tester.pumpAndSettle();

      await tester.tap(counterFinder);
      await tester.pumpAndSettle();

      expect(find.text('المُتَبَقِّي: 2'), findsOneWidget);
    });
  });
}
