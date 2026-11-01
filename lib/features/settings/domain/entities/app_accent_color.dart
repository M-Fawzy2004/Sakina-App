import 'package:flutter/material.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Curated luxury spiritual primary accent colors for Sakina Sanctuary.
class AppAccentColor {
  final String id;
  final String title;
  final String subtitle;
  final Color color;

  const AppAccentColor({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  static const AppAccentColor gold = AppAccentColor(
    id: 'gold',
    title: 'الذَّهَبُ المَلَكِيُّ',
    subtitle: 'اللون الافتراضي الفاخر',
    color: AppColors.champagneGold, // 0xFFE2B774
  );

  static const AppAccentColor emerald = AppAccentColor(
    id: 'emerald',
    title: 'الزُّمُرُّدُ النَّضِرُ',
    subtitle: 'سكينة الروضة الشريفة',
    color: Color(0xFF10B981),
  );

  static const AppAccentColor turquoise = AppAccentColor(
    id: 'turquoise',
    title: 'الفَيْرُوزُ السَّمَاوِيُّ',
    subtitle: 'صفاء السماء والروح',
    color: Color(0xFF06B6D4),
  );

  static const AppAccentColor sapphire = AppAccentColor(
    id: 'sapphire',
    title: 'اللَّازَوَرْدُ المَلَكِيُّ',
    subtitle: 'عمق الليل والهدوء',
    color: Color(0xFF3B82F6),
  );

  static const AppAccentColor amethyst = AppAccentColor(
    id: 'amethyst',
    title: 'اليَاقُوتُ الأُرْجُوَانِيُّ',
    subtitle: 'فخامة ملكية هادئة',
    color: Color(0xFFA855F7),
  );

  static const AppAccentColor amber = AppAccentColor(
    id: 'amber',
    title: 'العَنْبَرُ الدَّافِئُ',
    subtitle: 'دفء إشراق الصباح',
    color: Color(0xFFF59E0B),
  );

  static const AppAccentColor rose = AppAccentColor(
    id: 'rose',
    title: 'الوَرْدُ المَشْرِقِيُّ',
    subtitle: 'رقة ونقاء بصري',
    color: Color(0xFFEC4899),
  );

  static const AppAccentColor pearl = AppAccentColor(
    id: 'pearl',
    title: 'الفِضَّةُ اللُّؤْلُؤِيَّةُ',
    subtitle: 'نور القمر الوضاء',
    color: Color(0xFFE2E8F0),
  );

  static const List<AppAccentColor> allAccents = [
    gold,
    emerald,
    turquoise,
    sapphire,
    amethyst,
    amber,
    rose,
    pearl,
  ];

  static AppAccentColor fromColor(Color color) {
    return allAccents.firstWhere(
      (a) => a.color.toARGB32() == color.toARGB32(),
      orElse: () => gold,
    );
  }
}
