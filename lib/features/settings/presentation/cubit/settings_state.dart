import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';

class SettingsState extends Equatable {
  final AppThemeMode appThemeMode;
  final bool isLoading;
  final String? errorMessage;

  const SettingsState({
    this.appThemeMode = AppThemeMode.charcoal,
    this.isLoading = false,
    this.errorMessage,
  });

  ThemeMode get themeMode => appThemeMode.flutterThemeMode;

  SettingsState copyWith({
    AppThemeMode? appThemeMode,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SettingsState(
      appThemeMode: appThemeMode ?? this.appThemeMode,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [appThemeMode, isLoading, errorMessage];
}

