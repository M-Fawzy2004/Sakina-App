import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_category_entity.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_item_entity.dart';
import 'package:sakina_app/features/athkar/domain/failures/athkar_failure.dart';
import 'package:sakina_app/features/athkar/domain/usecases/get_athkar_by_category_usecase.dart';
import 'package:sakina_app/features/athkar/domain/usecases/get_athkar_categories_usecase.dart';
import 'package:sakina_app/features/athkar/presentation/cubit/athkar_cubit.dart';
import 'package:sakina_app/features/athkar/presentation/cubit/athkar_state.dart';

class MockGetAthkarCategoriesUseCase extends Mock
    implements GetAthkarCategoriesUseCase {}

class MockGetAthkarByCategoryUseCase extends Mock
    implements GetAthkarByCategoryUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AthkarCubit cubit;
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
      count: 1,
      description: 'سيد الاستغفار',
      reference: 'البخاري',
      content: 'اللهم أنت ربي لا إله إلا أنت',
    ),
    AthkarItemEntity(
      category: 'أذكار الصباح',
      count: 3,
      description: '',
      reference: '',
      content: 'رضيت بالله رباً',
    ),
  ];

  setUp(() {
    mockGetCategoriesUseCase = MockGetAthkarCategoriesUseCase();
    mockGetByCategoryUseCase = MockGetAthkarByCategoryUseCase();

    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const GetAthkarByCategoryParams(category: 'أذكار الصباح'),
    );

    cubit = AthkarCubit(
      getCategoriesUseCase: mockGetCategoriesUseCase,
      getAthkarByCategoryUseCase: mockGetByCategoryUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be AthkarInitial', () {
    expect(cubit.state, const AthkarInitial());
  });

  test('loadAthkar emits AthkarLoaded directly on success without loading screen', () async {
    when(() => mockGetCategoriesUseCase(any()))
        .thenAnswer((_) async => const Right(testCategories));
    when(() => mockGetByCategoryUseCase(any()))
        .thenAnswer((_) async => const Right(testMorningItems));

    final expected = [
      const AthkarLoaded(
        categories: testCategories,
        selectedCategory: 'أذكار الصباح',
        activeAthkar: testMorningItems,
        progressMap: {},
      ),
    ];

    expectLater(cubit.stream, emitsInOrder(expected));

    await cubit.loadAthkar();
  });

  test('loadAthkar emits AthkarError when categories use case fails', () async {
    when(() => mockGetCategoriesUseCase(any())).thenAnswer(
        (_) async => const Left(AthkarFailure(message: 'خطأ في التحميل')));

    final expected = [
      const AthkarError(message: 'خطأ في التحميل'),
    ];

    expectLater(cubit.stream, emitsInOrder(expected));

    await cubit.loadAthkar();
  });

  test('tapThikr increments progress count for the given item index', () async {
    when(() => mockGetCategoriesUseCase(any()))
        .thenAnswer((_) async => const Right(testCategories));
    when(() => mockGetByCategoryUseCase(any()))
        .thenAnswer((_) async => const Right(testMorningItems));

    await cubit.loadAthkar();

    expect(cubit.state, isA<AthkarLoaded>());

    // Tap index 1 (count is 3)
    cubit.tapThikr(1);
    final state1 = cubit.state as AthkarLoaded;
    expect(state1.progressMap[1], 1);

    cubit.tapThikr(1);
    final state2 = cubit.state as AthkarLoaded;
    expect(state2.progressMap[1], 2);

    // Reset item
    cubit.resetThikr(1);
    final state3 = cubit.state as AthkarLoaded;
    expect(state3.progressMap[1], null);
  });

  test('resetCategory resets all completed counts', () async {
    when(() => mockGetCategoriesUseCase(any()))
        .thenAnswer((_) async => const Right(testCategories));
    when(() => mockGetByCategoryUseCase(any()))
        .thenAnswer((_) async => const Right(testMorningItems));

    await cubit.loadAthkar();
    cubit.tapThikr(0);
    cubit.tapThikr(1);

    final before = cubit.state as AthkarLoaded;
    expect(before.progressMap.isNotEmpty, isTrue);

    cubit.resetCategory();
    final after = cubit.state as AthkarLoaded;
    expect(after.progressMap.isEmpty, isTrue);
  });
}

