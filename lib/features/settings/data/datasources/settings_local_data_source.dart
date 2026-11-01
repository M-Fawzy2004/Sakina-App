import 'package:flutter/material.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';

abstract interface class SettingsLocalDataSource {
  Future<AppThemeMode> getThemeMode();
  Future<void> setThemeMode(AppThemeMode mode);
  Future<Color> getPrimaryAccentColor();
  Future<void> setPrimaryAccentColor(Color color);
  Future<void> resetSettings();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _themeModeKey = 'sakina_app_theme_mode';
  static const String _accentColorKey = 'sakina_app_primary_accent_color';

  final PreferencesService preferencesService;

  const SettingsLocalDataSourceImpl({required this.preferencesService});

  @override
  Future<AppThemeMode> getThemeMode() async {
    final rawKey = preferencesService.getString(_themeModeKey);
    return AppThemeMode.fromKey(rawKey);
  }

  @override
  Future<void> setThemeMode(AppThemeMode mode) async {
    await preferencesService.setString(_themeModeKey, mode.key);
  }

  @override
  Future<Color> getPrimaryAccentColor() async {
    final rawInt = preferencesService.getInt(_accentColorKey);
    if (rawInt == null) {
      return AppColors.champagneGold;
    }
    return Color(rawInt);
  }

  @override
  Future<void> setPrimaryAccentColor(Color color) async {
    await preferencesService.setInt(_accentColorKey, color.toARGB32());
  }

  @override
  Future<void> resetSettings() async {
    await preferencesService.remove(_themeModeKey);
    await preferencesService.remove(_accentColorKey);
  }
}
