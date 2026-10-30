import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/router/route_constants.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/splash/domain/usecases/check_initial_app_state_usecase.dart';
import 'package:sakina_app/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:sakina_app/features/splash/presentation/cubit/splash_state.dart';

class MockCheckInitialAppStateUseCase extends Mock implements CheckInitialAppStateUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SplashCubit splashCubit;
  late MockCheckInitialAppStateUseCase mockCheckInitialAppStateUseCase;

  setUp(() {
    mockCheckInitialAppStateUseCase = MockCheckInitialAppStateUseCase();
    splashCubit = SplashCubit(checkInitialAppStateUseCase: mockCheckInitialAppStateUseCase);
  });

  tearDown(() {
    splashCubit.close();
  });

  test('initial state should be SplashInitial', () {
    expect(splashCubit.state, const SplashInitial());
  });

  test('should emit [SplashAnimating, SplashCompleted] when check succeeds', () async {
    when(() => mockCheckInitialAppStateUseCase(const NoParams()))
        .thenAnswer((_) async => const Right(AppRoutes.quran));

    final expectedStates = [
      const SplashAnimating(),
      const SplashCompleted(destinationRoute: AppRoutes.quran),
    ];

    expectLater(splashCubit.stream, emitsInOrder(expectedStates));

    await splashCubit.initializeApp();
  });

  test('should emit [SplashAnimating, SplashFailure] when check fails', () async {
    when(() => mockCheckInitialAppStateUseCase(const NoParams()))
        .thenAnswer((_) async => const Left(CacheFailure(message: 'Storage error')));

    final expectedStates = [
      const SplashAnimating(),
      const SplashFailure(message: 'Storage error'),
    ];

    expectLater(splashCubit.stream, emitsInOrder(expectedStates));

    await splashCubit.initializeApp();
  });
}

