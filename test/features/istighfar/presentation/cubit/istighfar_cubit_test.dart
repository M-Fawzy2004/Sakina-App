import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/istighfar/data/datasources/istighfar_local_data_source.dart';
import 'package:sakina_app/features/istighfar/domain/entities/istighfar_item.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/get_istighfar_items_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/get_istighfar_stats_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/increment_istighfar_count_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/reset_istighfar_count_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/set_istighfar_target_usecase.dart';
import 'package:sakina_app/features/istighfar/presentation/cubit/istighfar_cubit.dart';
import 'package:sakina_app/features/istighfar/presentation/cubit/istighfar_state.dart';

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

  late MockGetIstighfarItemsUseCase mockGetItems;
  late MockIncrementIstighfarCountUseCase mockIncrement;
  late MockResetIstighfarCountUseCase mockReset;
  late MockGetIstighfarStatsUseCase mockGetStats;
  late MockSetIstighfarTargetUseCase mockSetTarget;
  late MockIstighfarLocalDataSource mockDataSource;
  late IstighfarCubit cubit;

  const testItem = IstighfarItem(
    id: 'istighfar_1',
    arabic: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ',
    shortTitle: 'الاستغفار',
    virtue: 'مغفرة الذنوب',
    currentCycleCount: 5,
    targetCount: 33,
    lifetimeCount: 50,
  );

  setUp(() {
    mockGetItems = MockGetIstighfarItemsUseCase();
    mockIncrement = MockIncrementIstighfarCountUseCase();
    mockReset = MockResetIstighfarCountUseCase();
    mockGetStats = MockGetIstighfarStatsUseCase();
    mockSetTarget = MockSetIstighfarTargetUseCase();
    mockDataSource = MockIstighfarLocalDataSource();

    cubit = IstighfarCubit(
      getItemsUseCase: mockGetItems,
      incrementCountUseCase: mockIncrement,
      resetCountUseCase: mockReset,
      getStatsUseCase: mockGetStats,
      setTargetUseCase: mockSetTarget,
      localDataSource: mockDataSource,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('IstighfarCubit Tests', () {
    test('initial state is IstighfarInitial', () {
      expect(cubit.state, const IstighfarInitial());
    });

    test('loadIstighfarData emits IstighfarLoaded on success', () async {
      when(() => mockGetItems(const NoParams()))
          .thenAnswer((_) async => const Right([testItem]));
      when(() => mockGetStats(const NoParams()))
          .thenAnswer((_) async => const Right(50));

      await cubit.loadIstighfarData();

      expect(cubit.state, isA<IstighfarLoaded>());
      final loaded = cubit.state as IstighfarLoaded;
      expect(loaded.items.length, 1);
      expect(loaded.selectedItemId, 'istighfar_1');
      expect(loaded.totalLifetimeCount, 50);
    });

    test('incrementCurrentCount updates count in state', () async {
      when(() => mockGetItems(const NoParams()))
          .thenAnswer((_) async => const Right([testItem]));
      when(() => mockGetStats(const NoParams()))
          .thenAnswer((_) async => const Right(50));
      when(() => mockIncrement(const IncrementIstighfarCountParams(itemId: 'istighfar_1')))
          .thenAnswer((_) async => Right(testItem.copyWith(currentCycleCount: 6, lifetimeCount: 51)));

      await cubit.loadIstighfarData();
      await cubit.incrementCurrentCount();

      final loaded = cubit.state as IstighfarLoaded;
      expect(loaded.selectedItem.currentCycleCount, 6);
      expect(loaded.totalLifetimeCount, 51);
    });

    test('resetCurrentCycle resets cycle to 0 in state', () async {
      when(() => mockGetItems(const NoParams()))
          .thenAnswer((_) async => const Right([testItem]));
      when(() => mockGetStats(const NoParams()))
          .thenAnswer((_) async => const Right(50));
      when(() => mockReset(const ResetIstighfarCountParams(itemId: 'istighfar_1')))
          .thenAnswer((_) async => Right(testItem.copyWith(currentCycleCount: 0)));

      await cubit.loadIstighfarData();
      await cubit.resetCurrentCycle();

      final loaded = cubit.state as IstighfarLoaded;
      expect(loaded.selectedItem.currentCycleCount, 0);
    });
  });
}

