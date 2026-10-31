import 'package:flutter/material.dart';

/// Supported application theme modes for Sakina Sanctuary.
enum AppThemeMode {
  dark(
    title: 'الوَضْعُ الدَّاكِنُ',
    subtitle: 'سَوَادٌ مَلَكِيٌّ OLED مُرِيحٌ فِي اللَّيْلِ',
    key: 'dark',
  ),
  light(
    title: 'رَقُّ السَّكِينَةِ (الفَاتِحُ)',
    subtitle: 'لَوْنٌ كَرِيمِيٌّ دَافِئٌ مُرِيحٌ لِلْعَيْنِ نَهَارًا',
    key: 'light',
  ),
  system(
    title: 'تِلْقَائِيُّ النِّظَامِ',
    subtitle: 'مُتَوَافِقٌ تِلْقَائِيًّا مَعَ إِعْدَادَاتِ الهَاتِفِ',
    key: 'system',
  );

  final String title;
  final String subtitle;
  final String key;

  const AppThemeMode({
    required this.title,
    required this.subtitle,
    required this.key,
  });

  ThemeMode get flutterThemeMode => switch (this) {
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.system => ThemeMode.system,
      };

  static AppThemeMode fromKey(String? key) {
    return switch (key) {
      'light' => AppThemeMode.light,
      'system' => AppThemeMode.system,
      _ => AppThemeMode.dark, // Default to Dark OLED
    };
  }
}

