import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:sakina_app/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:sakina_app/features/settings/domain/usecases/set_theme_mode_usecase.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetThemeModeUseCase getThemeModeUseCase;
  final SetThemeModeUseCase setThemeModeUseCase;

  SettingsCubit({
    required this.getThemeModeUseCase,
    required this.setThemeModeUseCase,
  }) : super(const SettingsState());

  /// Loads persisted user preferences.
  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));
    final result = await getThemeModeUseCase(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (themeMode) => emit(state.copyWith(
        isLoading: false,
        appThemeMode: themeMode,
      )),
    );
  }

  /// Sets the application theme mode with immediate reactive dispatch.
  Future<void> setThemeMode(AppThemeMode mode) async {
    // 1. Instant optimistic UI update for zero lag
    emit(state.copyWith(appThemeMode: mode));

    // 2. Persist in storage asynchronously
    final result = await setThemeModeUseCase(SetThemeModeParams(mode: mode));
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {},
    );
  }
}

