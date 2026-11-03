import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/istighfar/data/datasources/istighfar_local_data_source.dart';
import 'package:sakina_app/features/istighfar/domain/entities/istighfar_item.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/get_istighfar_items_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/get_istighfar_stats_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/increment_istighfar_count_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/reset_istighfar_count_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/set_istighfar_target_usecase.dart';
import 'package:sakina_app/features/istighfar/presentation/cubit/istighfar_cubit.dart';
import 'package:sakina_app/features/istighfar/presentation/widgets/components/animated_sibha_bead_string.dart';
import 'package:sakina_app/features/istighfar/presentation/widgets/istighfar_screen.dart';

class MockGetIstighfarItemsUseCase extends Mock
    implements GetIstighfarItemsUseCase {}

class MockIncrementIstighfarCountUseCase extends Mock
    implements IncrementIstighfarCountUseCase {}

class MockResetIstighfarCountUseCase extends Mock
    implements ResetIstighfarCountUseCase {}

class MockGetIstighfarStatsUseCase extends Mock
    implements GetIstighfarStatsUseCase {}

class MockSetIstighfarTargetUseCase extends Mock
    implements SetIstighfarTargetUseCase {}

class MockIstighfarLocalDataSource extends Mock
    implements IstighfarLocalDataSource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(const IncrementIstighfarCountParams(itemId: 'fallback'));
    registerFallbackValue(const ResetIstighfarCountParams(itemId: 'fallback'));
  });

  late MockGetIstighfarItemsUseCase mockGetItems;
  late MockIncrementIstighfarCountUseCase mockIncrement;
  late MockResetIstighfarCountUseCase mockReset;
  late MockGetIstighfarStatsUseCase mockGetStats;
  late MockSetIstighfarTargetUseCase mockSetTarget;
  late MockIstighfarLocalDataSource mockDataSource;

  const testItems = [
    IstighfarItem(
      id: 'istighfar_1',
      arabic: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ',
      shortTitle: 'الاستغفار',
      virtue: 'مغفرة الذنوب',
      currentCycleCount: 7,
      targetCount: 33,
      lifetimeCount: 100,
    ),
    IstighfarItem(
      id: 'subhanallah',
      arabic: 'سُبْحَانَ اللَّهِ',
      shortTitle: 'التسبيح',
      virtue: 'نخلة في الجنة',
      currentCycleCount: 0,
      targetCount: 33,
      lifetimeCount: 50,
    ),
  ];

  setUp(() {
    mockGetItems = MockGetIstighfarItemsUseCase();
    mockIncrement = MockIncrementIstighfarCountUseCase();
    mockReset = MockResetIstighfarCountUseCase();
    mockGetStats = MockGetIstighfarStatsUseCase();
    mockSetTarget = MockSetIstighfarTargetUseCase();
    mockDataSource = MockIstighfarLocalDataSource();

    when(() => mockGetItems(const NoParams()))
        .thenAnswer((_) async => const Right(testItems));
    when(() => mockGetStats(const NoParams()))
        .thenAnswer((_) async => const Right(150));
    when(() => mockIncrement(any()))
        .thenAnswer((_) async => Right(testItems.first.copyWith(currentCycleCount: 8)));
    when(() => mockReset(any()))
        .thenAnswer((_) async => Right(testItems.first.copyWith(currentCycleCount: 0)));
    when(() => mockDataSource.setSelectedItemId(any()))
        .thenAnswer((_) async {});

    if (sl.isRegistered<IstighfarCubit>()) {
      sl.unregister<IstighfarCubit>();
    }

    sl.registerFactory<IstighfarCubit>(
      () => IstighfarCubit(
        getItemsUseCase: mockGetItems,
        incrementCountUseCase: mockIncrement,
        resetCountUseCase: mockReset,
        getStatsUseCase: mockGetStats,
        setTargetUseCase: mockSetTarget,
        localDataSource: mockDataSource,
      ),
    );
  });

  tearDown(() {
    if (sl.isRegistered<IstighfarCubit>()) {
      sl.unregister<IstighfarCubit>();
    }
  });

  testWidgets('IstighfarScreen renders header, phrase display, counter disc, and chips',
      (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          theme: AppTheme.charcoalLuxury,
          home: const IstighfarScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('مَسْبَحَةُ الاسْتِغْفَارِ'), findsOneWidget);
    expect(find.text('أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ'), findsOneWidget);
    expect(find.text('«مغفرة الذنوب»'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('/ 33'), findsOneWidget);
    expect(find.text('الاستغفار'), findsOneWidget);
    expect(find.text('التسبيح'), findsOneWidget);
  });

  testWidgets('tapping counter disc triggers increment', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          theme: AppTheme.charcoalLuxury,
          home: const IstighfarScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap on the counter disc
    await tester.tap(find.text('7'));
    await tester.pumpAndSettle();

    verify(() => mockIncrement(any())).called(1);
  });

  testWidgets('dragging sibha beads horizontally triggers increment', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          theme: AppTheme.charcoalLuxury,
          home: const IstighfarScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final sibhaFinder = find.byType(AnimatedSibhaBeadString);
    expect(sibhaFinder, findsOneWidget);

    await tester.drag(sibhaFinder, const Offset(-60, 0));
    await tester.pumpAndSettle();

    verify(() => mockIncrement(any())).called(1);
  });
}
