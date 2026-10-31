import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:sakina_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:sakina_app/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:sakina_app/features/settings/domain/usecases/set_theme_mode_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockRepository;
  late GetThemeModeUseCase getThemeModeUseCase;
  late SetThemeModeUseCase setThemeModeUseCase;

  setUp(() {
    mockRepository = MockSettingsRepository();
    getThemeModeUseCase = GetThemeModeUseCase(repository: mockRepository);
    setThemeModeUseCase = SetThemeModeUseCase(repository: mockRepository);
  });

  group('GetThemeModeUseCase', () {
    test('returns AppThemeMode.light when repository succeeds', () async {
      when(() => mockRepository.getThemeMode())
          .thenAnswer((_) async => const Right(AppThemeMode.light));

      final result = await getThemeModeUseCase(const NoParams());

      expect(result, const Right(AppThemeMode.light));
      verify(() => mockRepository.getThemeMode()).called(1);
    });

    test('returns CacheFailure when repository fails', () async {
      when(() => mockRepository.getThemeMode())
          .thenAnswer((_) async => const Left(CacheFailure(message: 'Storage error')));

      final result = await getThemeModeUseCase(const NoParams());

      expect(result, const Left(CacheFailure(message: 'Storage error')));
      verify(() => mockRepository.getThemeMode()).called(1);
    });
  });

  group('SetThemeModeUseCase', () {
    test('calls repository.setThemeMode with correct mode', () async {
      when(() => mockRepository.setThemeMode(AppThemeMode.light))
          .thenAnswer((_) async => const Right(null));

      final result = await setThemeModeUseCase(const SetThemeModeParams(mode: AppThemeMode.light));

      expect(result, const Right(null));
      verify(() => mockRepository.setThemeMode(AppThemeMode.light)).called(1);
    });
  });
}

