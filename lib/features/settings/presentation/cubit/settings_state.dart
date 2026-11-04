import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';

class SettingsState extends Equatable {
  final AppThemeMode appThemeMode;
  final Color primaryAccentColor;
  final double textScaleFactor;
  final bool isLoading;
  final String? errorMessage;

  const SettingsState({
    this.appThemeMode = AppThemeMode.charcoal,
    this.primaryAccentColor = AppColors.champagneGold,
    this.textScaleFactor = 1.0,
    this.isLoading = false,
    this.errorMessage,
  });

  ThemeMode get themeMode => appThemeMode.flutterThemeMode;

  SettingsState copyWith({
    AppThemeMode? appThemeMode,
    Color? primaryAccentColor,
    double? textScaleFactor,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SettingsState(
      appThemeMode: appThemeMode ?? this.appThemeMode,
      primaryAccentColor: primaryAccentColor ?? this.primaryAccentColor,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        appThemeMode,
        primaryAccentColor,
        textScaleFactor,
        isLoading,
        errorMessage,
      ];
}
