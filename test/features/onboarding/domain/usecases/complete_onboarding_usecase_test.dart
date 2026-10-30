import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/constants/app_constants.dart';
import 'package:sakina_app/core/router/route_constants.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  late CompleteOnboardingUseCase useCase;
  late MockPreferencesService mockPreferencesService;

  setUp(() {
    mockPreferencesService = MockPreferencesService();
    useCase = CompleteOnboardingUseCase(preferencesService: mockPreferencesService);
  });

  test('should set onboarding completed flag to true and return maladh route', () async {
    when(() => mockPreferencesService.setBool(AppConstants.keyOnboardingCompleted, true))
        .thenAnswer((_) async => true);

    final result = await useCase(const NoParams());

    expect(result, const Right(AppRoutes.maladh));
    verify(() => mockPreferencesService.setBool(AppConstants.keyOnboardingCompleted, true)).called(1);
  });
}

