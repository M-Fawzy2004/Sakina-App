import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:sakina_app/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:sakina_app/features/settings/domain/usecases/set_theme_mode_usecase.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_cubit.dart';

class MockGetThemeModeUseCase extends Mock implements GetThemeModeUseCase {}
class MockSetThemeModeUseCase extends Mock implements SetThemeModeUseCase {}

void main() {
  late MockGetThemeModeUseCase mockGetThemeModeUseCase;
  late MockSetThemeModeUseCase mockSetThemeModeUseCase;
  late SettingsCubit cubit;

  setUpAll(() {
    registerFallbackValue(const SetThemeModeParams(mode: AppThemeMode.light));
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockGetThemeModeUseCase = MockGetThemeModeUseCase();
    mockSetThemeModeUseCase = MockSetThemeModeUseCase();

    cubit = SettingsCubit(
      getThemeModeUseCase: mockGetThemeModeUseCase,
      setThemeModeUseCase: mockSetThemeModeUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('SettingsCubit', () {
    test('loadSettings updates state with persisted theme mode', () async {
      when(() => mockGetThemeModeUseCase(any()))
          .thenAnswer((_) async => const Right(AppThemeMode.light));

      await cubit.loadSettings();

      expect(cubit.state.appThemeMode, AppThemeMode.light);
      verify(() => mockGetThemeModeUseCase(any())).called(1);
    });

    test('setThemeMode updates state immediately and persists asynchronously', () async {
      when(() => mockSetThemeModeUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      await cubit.setThemeMode(AppThemeMode.light);

      expect(cubit.state.appThemeMode, AppThemeMode.light);
      verify(() => mockSetThemeModeUseCase(const SetThemeModeParams(mode: AppThemeMode.light))).called(1);
    });
  });
}

