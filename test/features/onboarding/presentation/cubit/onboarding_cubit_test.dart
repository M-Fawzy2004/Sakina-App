import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/router/route_constants.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:sakina_app/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:sakina_app/features/onboarding/presentation/cubit/onboarding_state.dart';

class MockCompleteOnboardingUseCase extends Mock implements CompleteOnboardingUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late OnboardingCubit onboardingCubit;
  late MockCompleteOnboardingUseCase mockCompleteOnboardingUseCase;

  setUp(() {
    mockCompleteOnboardingUseCase = MockCompleteOnboardingUseCase();
    onboardingCubit = OnboardingCubit(completeOnboardingUseCase: mockCompleteOnboardingUseCase);
  });

  tearDown(() {
    onboardingCubit.close();
  });

  test('initial state should be OnboardingActive with index 0 and 3 items', () {
    expect(onboardingCubit.state, isA<OnboardingActive>());
    final state = onboardingCubit.state as OnboardingActive;
    expect(state.currentIndex, 0);
    expect(state.items.length, 3);
    expect(state.isLastPage, false);
  });

  test('onPageChanged should emit OnboardingActive with new index', () {
    onboardingCubit.onPageChanged(1);
    final state = onboardingCubit.state as OnboardingActive;
    expect(state.currentIndex, 1);
    expect(state.isLastPage, false);

    onboardingCubit.onPageChanged(2);
    final lastState = onboardingCubit.state as OnboardingActive;
    expect(lastState.currentIndex, 2);
    expect(lastState.isLastPage, true);
    expect(lastState.currentItem.buttonText, 'ابْدَأْ رِحْلَتَكَ 🕊️');
  });

  test('completeOnboarding should emit OnboardingCompleted when usecase succeeds', () async {
    when(() => mockCompleteOnboardingUseCase(const NoParams()))
        .thenAnswer((_) async => const Right(AppRoutes.quran));

    final expectedStates = [
      const OnboardingCompleted(destinationRoute: AppRoutes.quran),
    ];

    expectLater(onboardingCubit.stream, emitsInOrder(expectedStates));

    await onboardingCubit.completeOnboarding();
  });
}

