import 'package:flutter/material.dart';

/// Supported application theme modes for Sakina Sanctuary.
enum AppThemeMode {
  charcoal(
    title: 'الفَحْمِيُّ الحَدِيثُ',
    subtitle: 'رَمَادِيٌّ دَاكِنٌ نَقِيٌّ (الأسَاسِيُّ)',
    key: 'charcoal',
  ),
  dark(
    title: 'الَّليْلُ المَلَكِيُّ',
    subtitle: 'سَوَادٌ مُطْلَقٌ OLED مَعَ ذَهَبٍ خَالِصٍ',
    key: 'dark',
  ),
  light(
    title: 'رَقُّ السَّكِينَةِ',
    subtitle: 'كَرِيمِيٌّ دَافِئٌ مُرِيحٌ لِلْعَيْنِ نَهَارًا',
    key: 'light',
  ),
  emerald(
    title: 'زُمُرُّدُ الفِرْدَوْسِ',
    subtitle: 'رَوْحَانِيَّةُ الزُّمُرُّدِ لِلسَّكِينَةِ وَالتَّدَبُّرِ',
    key: 'emerald',
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
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.system => ThemeMode.system,
        _ => ThemeMode.dark,
      };

  static AppThemeMode fromKey(String? key) {
    return switch (key) {
      'charcoal' => AppThemeMode.charcoal,
      'dark' => AppThemeMode.dark,
      'light' => AppThemeMode.light,
      'emerald' => AppThemeMode.emerald,
      'system' => AppThemeMode.system,
      _ => AppThemeMode.charcoal, // Default to Modern Charcoal Slate
    };
  }
}
