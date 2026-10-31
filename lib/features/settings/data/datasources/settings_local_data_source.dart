import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';

abstract interface class SettingsLocalDataSource {
  Future<AppThemeMode> getThemeMode();
  Future<void> setThemeMode(AppThemeMode mode);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _themeModeKey = 'sakina_app_theme_mode';

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
}

