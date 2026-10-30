import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/constants/app_constants.dart';
import 'package:sakina_app/core/router/route_constants.dart';
import 'package:sakina_app/core/services/storage/database_helper.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/splash/domain/usecases/check_initial_app_state_usecase.dart';
import 'package:sqflite/sqflite.dart';

class MockPreferencesService extends Mock implements PreferencesService {}
class MockDatabaseHelper extends Mock implements DatabaseHelper {}
class MockDatabase extends Mock implements Database {}

void main() {
  late CheckInitialAppStateUseCase useCase;
  late MockPreferencesService mockPreferencesService;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockDatabase mockDatabase;

  setUp(() {
    mockPreferencesService = MockPreferencesService();
    mockDatabaseHelper = MockDatabaseHelper();
    mockDatabase = MockDatabase();

    useCase = CheckInitialAppStateUseCase(
      preferencesService: mockPreferencesService,
      databaseHelper: mockDatabaseHelper,
    );
  });

  test('should return onboarding route when onboarding is not yet completed', () async {
    when(() => mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
    when(() => mockPreferencesService.getBool(AppConstants.keyOnboardingCompleted))
        .thenReturn(false);

    final result = await useCase(const NoParams());

    expect(result, const Right(AppRoutes.onboarding));
    verify(() => mockDatabaseHelper.database).called(1);
    verify(() => mockPreferencesService.getBool(AppConstants.keyOnboardingCompleted)).called(1);
  });

  test('should return quran route when onboarding is already completed', () async {
    when(() => mockDatabaseHelper.database).thenAnswer((_) async => mockDatabase);
    when(() => mockPreferencesService.getBool(AppConstants.keyOnboardingCompleted))
        .thenReturn(true);

    final result = await useCase(const NoParams());

    expect(result, const Right(AppRoutes.quran));
    verify(() => mockDatabaseHelper.database).called(1);
    verify(() => mockPreferencesService.getBool(AppConstants.keyOnboardingCompleted)).called(1);
  });
}
