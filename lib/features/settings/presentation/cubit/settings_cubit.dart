import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:sakina_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:sakina_app/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:sakina_app/features/settings/domain/usecases/set_theme_mode_usecase.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetThemeModeUseCase getThemeModeUseCase;
  final SetThemeModeUseCase setThemeModeUseCase;
  final SettingsRepository? repository;

  SettingsCubit({
    required this.getThemeModeUseCase,
    required this.setThemeModeUseCase,
    this.repository,
  }) : super(const SettingsState());

  /// Loads persisted user preferences (theme mode and primary accent color).
  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));
    final themeResult = await getThemeModeUseCase(const NoParams());
    final themeMode = themeResult.fold(
      (_) => AppThemeMode.charcoal,
      (mode) => mode,
    );

    Color accentColor = AppColors.champagneGold;
    double scale = 1.0;
    if (repository != null) {
      final colorResult = await repository!.getPrimaryAccentColor();
      accentColor = colorResult.fold(
        (_) => AppColors.champagneGold,
        (color) => color,
      );

      final scaleResult = await repository!.getAppTextScale();
      scale = scaleResult.fold(
        (_) => 1.0,
        (s) => s,
      );
    }

    emit(state.copyWith(
      isLoading: false,
      appThemeMode: themeMode,
      primaryAccentColor: accentColor,
      textScaleFactor: scale,
    ));
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

  /// Sets the primary accent color with immediate reactive dispatch.
  Future<void> setPrimaryAccentColor(Color color) async {
    // 1. Instant optimistic UI update
    emit(state.copyWith(primaryAccentColor: color));

    // 2. Persist in storage asynchronously
    if (repository != null) {
      final result = await repository!.setPrimaryAccentColor(color);
      result.fold(
        (failure) => emit(state.copyWith(errorMessage: failure.message)),
        (_) {},
      );
    }
  }

  /// Sets the application font text scale factor across all screens.
  Future<void> setTextScaleFactor(double scale) async {
    // 1. Instant optimistic UI update
    emit(state.copyWith(textScaleFactor: scale));

    // 2. Persist in storage asynchronously
    if (repository != null) {
      final result = await repository!.setAppTextScale(scale);
      result.fold(
        (failure) => emit(state.copyWith(errorMessage: failure.message)),
        (_) {},
      );
    }
  }

  /// Resets all appearance preferences back to initial default values.
  Future<void> resetToDefaults() async {
    // 1. Instant optimistic UI reset
    emit(state.copyWith(
      appThemeMode: AppThemeMode.charcoal,
      primaryAccentColor: AppColors.champagneGold,
      textScaleFactor: 1.0,
    ));

    // 2. Reset persistence in storage
    if (repository != null) {
      await repository!.resetSettings();
    }
  }
}
