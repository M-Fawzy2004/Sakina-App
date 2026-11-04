import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';

/// Local persistence manager for Holy Quran Reader preferences.
/// Guarantees that font size, manuscript style, calligraphy script, theme,
/// and comfort options are permanently remembered and can be cleanly restored to defaults.
abstract final class QuranReaderPreferencesStorage {
  static const String keyStyle = 'sakina_quran_pref_style_v1';
  static const String keyScriptStyle = 'sakina_quran_pref_script_v1';
  static const String keyFontSize = 'sakina_quran_pref_font_size_v1';
  static const String keyTheme = 'sakina_quran_pref_theme_v1';
  static const String keyLineSpacing = 'sakina_quran_pref_spacing_v1';
  static const String keyShowDividers = 'sakina_quran_pref_dividers_v1';
  static const String keyAutoScrollSpeed = 'sakina_quran_pref_speed_v1';
  static const String keyKeepAwake = 'sakina_quran_pref_awake_v1';

  /// Loads persisted Quran reader preferences, falling back to serene defaults.
  static QuranReaderPreferences load(PreferencesService prefs) {
    final styleName = prefs.getString(keyStyle);
    final scriptName = prefs.getString(keyScriptStyle);
    final fontName = prefs.getString(keyFontSize);
    final themeName = prefs.getString(keyTheme);
    final spacingName = prefs.getString(keyLineSpacing);
    final showDividers = prefs.getBool(keyShowDividers) ?? true;
    final autoScrollSpeed = prefs.getDouble(keyAutoScrollSpeed) ?? 1.0;
    final keepAwake = prefs.getBool(keyKeepAwake) ?? true;

    final style = QuranReadingStyle.values.firstWhere(
      (e) => e.name == styleName,
      orElse: () => QuranReadingStyle.continuous,
    );

    final script = QuranScriptStyle.values.firstWhere(
      (e) => e.name == scriptName,
      orElse: () => QuranScriptStyle.uthmani,
    );

    final font = QuranFontSize.values.firstWhere(
      (e) => e.name == fontName,
      orElse: () => QuranFontSize.medium,
    );

    final theme = QuranReaderTheme.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => QuranReaderTheme.charcoal,
    );

    final spacing = QuranLineSpacing.values.firstWhere(
      (e) => e.name == spacingName,
      orElse: () => QuranLineSpacing.relaxed,
    );

    return QuranReaderPreferences(
      style: style,
      scriptStyle: script,
      fontSize: font,
      theme: theme,
      lineSpacing: spacing,
      showDividers: showDividers,
      isAutoScrollEnabled: false,
      autoScrollSpeed: autoScrollSpeed,
      isKeepScreenAwake: keepAwake,
    );
  }

  /// Persists reader preferences into local device storage.
  static Future<void> save(
    PreferencesService prefs,
    QuranReaderPreferences preferences,
  ) async {
    await prefs.setString(keyStyle, preferences.style.name);
    await prefs.setString(keyScriptStyle, preferences.scriptStyle.name);
    await prefs.setString(keyFontSize, preferences.fontSize.name);
    await prefs.setString(keyTheme, preferences.theme.name);
    await prefs.setString(keyLineSpacing, preferences.lineSpacing.name);
    await prefs.setBool(keyShowDividers, preferences.showDividers);
    await prefs.setDouble(keyAutoScrollSpeed, preferences.autoScrollSpeed);
    await prefs.setBool(keyKeepAwake, preferences.isKeepScreenAwake);
  }

  /// Resets all reader preferences back to factory defaults.
  static Future<void> reset(PreferencesService prefs) async {
    await prefs.remove(keyStyle);
    await prefs.remove(keyScriptStyle);
    await prefs.remove(keyFontSize);
    await prefs.remove(keyTheme);
    await prefs.remove(keyLineSpacing);
    await prefs.remove(keyShowDividers);
    await prefs.remove(keyAutoScrollSpeed);
    await prefs.remove(keyKeepAwake);
  }
}
