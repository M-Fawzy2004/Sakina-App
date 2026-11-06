import 'package:shared_preferences/shared_preferences.dart';

abstract interface class PreferencesService {
  Future<bool> setString(String key, String value);
  String? getString(String key);
  Future<bool> setInt(String key, int value);
  int? getInt(String key);
  Future<bool> setBool(String key, bool value);
  bool? getBool(String key);
  Future<bool> setDouble(String key, double value);
  double? getDouble(String key);
  Future<bool> setStringList(String key, List<String> value);
  List<String>? getStringList(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
}

class PreferencesServiceImpl implements PreferencesService {
  final SharedPreferences preferences;

  const PreferencesServiceImpl(this.preferences);

  @override
  Future<bool> setString(String key, String value) => preferences.setString(key, value);

  @override
  String? getString(String key) => preferences.getString(key);

  @override
  Future<bool> setInt(String key, int value) => preferences.setInt(key, value);

  @override
  int? getInt(String key) => preferences.getInt(key);

  @override
  Future<bool> setBool(String key, bool value) => preferences.setBool(key, value);

  @override
  bool? getBool(String key) => preferences.getBool(key);

  @override
  Future<bool> setDouble(String key, double value) => preferences.setDouble(key, value);

  @override
  double? getDouble(String key) => preferences.getDouble(key);

  @override
  Future<bool> setStringList(String key, List<String> value) =>
      preferences.setStringList(key, value);

  @override
  List<String>? getStringList(String key) => preferences.getStringList(key);

  @override
  Future<bool> remove(String key) => preferences.remove(key);

  @override
  Future<bool> clear() => preferences.clear();
}

