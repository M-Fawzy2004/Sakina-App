import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:sakina_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:sakina_app/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:sakina_app/features/settings/domain/usecases/set_theme_mode_usecase.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_cubit.dart';

class MockGetThemeModeUseCase extends Mock implements GetThemeModeUseCase {}
class MockSetThemeModeUseCase extends Mock implements SetThemeModeUseCase {}
class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockGetThemeModeUseCase mockGetThemeModeUseCase;
  late MockSetThemeModeUseCase mockSetThemeModeUseCase;
  late MockSettingsRepository mockSettingsRepository;
  late SettingsCubit cubit;

  setUpAll(() {
    registerFallbackValue(const SetThemeModeParams(mode: AppThemeMode.light));
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockGetThemeModeUseCase = MockGetThemeModeUseCase();
    mockSetThemeModeUseCase = MockSetThemeModeUseCase();
    mockSettingsRepository = MockSettingsRepository();

    cubit = SettingsCubit(
      getThemeModeUseCase: mockGetThemeModeUseCase,
      setThemeModeUseCase: mockSetThemeModeUseCase,
      repository: mockSettingsRepository,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('SettingsCubit', () {
    test('loadSettings updates state with persisted theme mode and accent color', () async {
      when(() => mockGetThemeModeUseCase(any()))
          .thenAnswer((_) async => const Right(AppThemeMode.light));
      when(() => mockSettingsRepository.getPrimaryAccentColor())
          .thenAnswer((_) async => const Right(Color(0xFF10B981)));

      await cubit.loadSettings();

      expect(cubit.state.appThemeMode, AppThemeMode.light);
      expect(cubit.state.primaryAccentColor, const Color(0xFF10B981));
      verify(() => mockGetThemeModeUseCase(any())).called(1);
      verify(() => mockSettingsRepository.getPrimaryAccentColor()).called(1);
    });

    test('setThemeMode updates state immediately and persists asynchronously', () async {
      when(() => mockSetThemeModeUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      await cubit.setThemeMode(AppThemeMode.light);

      expect(cubit.state.appThemeMode, AppThemeMode.light);
      verify(() => mockSetThemeModeUseCase(const SetThemeModeParams(mode: AppThemeMode.light))).called(1);
    });

    test('setPrimaryAccentColor updates state and persists in repository', () async {
      const testColor = Color(0xFF06B6D4);
      when(() => mockSettingsRepository.setPrimaryAccentColor(testColor))
          .thenAnswer((_) async => const Right(null));

      await cubit.setPrimaryAccentColor(testColor);

      expect(cubit.state.primaryAccentColor, testColor);
      verify(() => mockSettingsRepository.setPrimaryAccentColor(testColor)).called(1);
    });

    test('resetToDefaults resets theme to charcoal and color to champagneGold', () async {
      when(() => mockSettingsRepository.resetSettings())
          .thenAnswer((_) async => const Right(null));

      // First change state
      cubit.emit(cubit.state.copyWith(
        appThemeMode: AppThemeMode.light,
        primaryAccentColor: const Color(0xFF10B981),
      ));

      await cubit.resetToDefaults();

      expect(cubit.state.appThemeMode, AppThemeMode.charcoal);
      expect(cubit.state.primaryAccentColor, AppColors.champagneGold);
      verify(() => mockSettingsRepository.resetSettings()).called(1);
    });
  });
}

