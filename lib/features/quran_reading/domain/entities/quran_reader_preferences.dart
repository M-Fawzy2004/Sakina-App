import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Available Quran reading presentation layouts:
/// - [verseByVerse]: Classic line-by-line verses with rosette badges and hair dividers
/// - [continuous]: Flowing uninterrupted Mushaf text with inline end-of-ayah rosettes
enum QuranReadingStyle {
  verseByVerse(
    title: 'آيَةٌ بِآيَةٍ',
    description: 'سَرْدٌ سَطْرِيٌّ مُنَفَصِلٌ لِكُلِّ آيَةٍ مَعَ شَارَتِهَا',
  ),
  continuous(
    title: 'مُصْحَفٌ مُتَّصِلٌ',
    description: 'قِرَاءَةٌ مُتَتَابِعَةٌ لِلآيَاتِ خَلْفَ بَعْضِهَا كَالمُصْحَفِ الشَّرِيفِ',
  );

  final String title;
  final String description;

  const QuranReadingStyle({
    required this.title,
    required this.description,
  });
}

/// Calligraphic and typography script styles for Holy Quran text:
enum QuranScriptStyle {
  uthmani(
    title: 'الرَّسْمُ العُثْمَانِيُّ',
    description: 'حَفْص عَنْ عَاصِم - مُصْحَفُ المَدِينَةِ المُنَوَّرَةِ',
    badgeText: 'مُعْتَمَد',
    fontFamily: 'Amiri',
  ),
  amiri(
    title: 'خَطُّ النَّسْخِ القُرْآنِيُّ',
    description: 'طِبَاعَةٌ وَاضِحَةٌ كِلاسِيكِيَّةٌ لِرَاحَةِ القِرَاءَةِ',
    badgeText: 'نَسْخ',
    fontFamily: 'Noto Naskh Arabic',
  ),
  indopak(
    title: 'الرَّسْمُ المَشْرِقِيُّ (النَّسْتَعْلِيق)',
    description: 'رَسْمُ المَصَاحِفِ التَّقْلِيدِيِّ بِبِلادِ المَشْرِقِ وَآسِيَا',
    badgeText: 'مَشْرِقِي',
    fontFamily: 'Scheherazade New',
  );

  final String title;
  final String description;
  final String badgeText;
  final String fontFamily;

  const QuranScriptStyle({
    required this.title,
    required this.description,
    required this.badgeText,
    required this.fontFamily,
  });
}

/// The four discrete calibrated font sizes for Quranic scripture:
enum QuranFontSize {
  small(
    title: 'صَغِير',
    scaleDelta: -4.0,
    displaySp: 18,
  ),
  medium(
    title: 'مُتَوَسِّط',
    scaleDelta: 0.0,
    displaySp: 22,
  ),
  large(
    title: 'كَبِير',
    scaleDelta: 4.0,
    displaySp: 26,
  ),
  extraLarge(
    title: 'كَبِيرٌ جِدًّا',
    scaleDelta: 8.0,
    displaySp: 30,
  );

  final String title;
  final double scaleDelta;
  final int displaySp;

  const QuranFontSize({
    required this.title,
    required this.scaleDelta,
    required this.displaySp,
  });
}

/// Sacred Atmospheric Ambience Themes for the Reader:
enum QuranReaderTheme {
  charcoal(
    title: 'الفَحْمِيُّ الحَدِيثُ',
    description: 'رَمَادِيٌّ دَاكِنٌ نَقِيٌّ بِمَظْهَرٍ عَصْرِيٍّ رَاقٍ (الأسَاسِيُّ)',
    backgroundColor: AppColors.charcoalCore,
    cardColor: AppColors.charcoalCard,
    accentColor: AppColors.charcoalAccent,
    textColor: AppColors.pureChalk,
  ),
  obsidian(
    title: 'الَّليْلُ المَلَكِيُّ',
    description: 'سَوَادٌ مُطْلَقٌ OLED مَعَ ذَهَبٍ خَالِصٍ',
    backgroundColor: AppColors.obsidianCore,
    cardColor: AppColors.carbonSlate,
    accentColor: AppColors.champagneGold,
    textColor: AppColors.paleRadiance,
  ),
  emerald(
    title: 'زُمُرُّدُ الفِرْدَوْسِ',
    description: 'رَوْحَانِيَّةُ الزُّمُرُّدِ لِلتَّدَبُّرِ وَالتَّرْتِيلِ',
    backgroundColor: AppColors.emeraldSanctuaryCore,
    cardColor: AppColors.emeraldSanctuaryCard,
    accentColor: AppColors.emeraldGlow,
    textColor: AppColors.pureChalk,
  ),
  parchment(
    title: 'رَقُّ السَّكِينَةِ',
    description: 'رَقٌّ كَرِيمِيٌّ مُرِيحٌ لِلْعَيْنِ كَالْمُصْحَفِ الشَّرِيفِ',
    backgroundColor: AppColors.parchmentCore,
    cardColor: AppColors.parchmentCard,
    accentColor: AppColors.warmGold,
    textColor: AppColors.inkDeep,
  ),
  amber(
    title: 'نُورُ السَّحَرِ',
    description: 'عَنْبَرٌ دَافِئٌ مُرِيحٌ لِلْعَيْنَيْنِ فِي اللَّيْلِ',
    backgroundColor: AppColors.carbonSlate,
    cardColor: AppColors.surfaceElevated,
    accentColor: AppColors.softAmber,
    textColor: AppColors.pureChalk,
  ),
  sapphire(
    title: 'سَمَاءُ اللَّيْلِ',
    description: 'أَزْرَقُ نِيلِيٌّ عَمِيقٌ مَعَ إِضَاءَةٍ قَمَرِيَّةٍ نَاصِعَةٍ',
    backgroundColor: Color(0xFF070F1E),
    cardColor: Color(0xFF0F1B2E),
    accentColor: Color(0xFF38BDF8),
    textColor: AppColors.pureChalk,
  ),
  sepia(
    title: 'مُصْحَفُ الأَجْدَادِ',
    description: 'سِيبْيَا دَافِئَةٌ عَتِيقَةٌ تُحَاكِي صَفَحَاتِ المَخْطُوطَاتِ',
    backgroundColor: Color(0xFF191410),
    cardColor: Color(0xFF261F1A),
    accentColor: Color(0xFFE28743),
    textColor: Color(0xFFF6EEDB),
  );

  final String title;
  final String description;
  final Color backgroundColor;
  final Color cardColor;
  final Color accentColor;
  final Color textColor;

  const QuranReaderTheme({
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.cardColor,
    required this.accentColor,
    required this.textColor,
  });

  bool get isLight => this == QuranReaderTheme.parchment;
  Color get secondaryTextColor => switch (this) {
        QuranReaderTheme.parchment => AppColors.inkMuted,
        QuranReaderTheme.charcoal => AppColors.charcoalMuted,
        QuranReaderTheme.emerald => AppColors.emeraldSanctuaryMuted,
        _ => AppColors.mutedSilver,
      };
  Color get itemBackgroundColor => switch (this) {
        QuranReaderTheme.parchment => AppColors.parchmentElevated,
        QuranReaderTheme.charcoal => AppColors.charcoalElevated,
        QuranReaderTheme.emerald => AppColors.emeraldSanctuaryElevated,
        _ => AppColors.frostedGlass,
      };
  Color get borderColor => switch (this) {
        QuranReaderTheme.parchment => AppColors.parchmentBorder,
        QuranReaderTheme.charcoal => AppColors.charcoalBorder,
        QuranReaderTheme.emerald => AppColors.emeraldSanctuaryBorder,
        _ => AppColors.goldBorderStroke,
      };
}

/// Line spacing choices to ensure Tashkeel (diacritics) readability:
enum QuranLineSpacing {
  normal(title: 'عَادِي', height: 1.8),
  relaxed(title: 'مُرِيح', height: 2.0),
  spacious(title: 'وَاسِع', height: 2.25);

  final String title;
  final double height;

  const QuranLineSpacing({
    required this.title,
    required this.height,
  });
}

/// Immutable configuration model capturing all luxury reader preferences.
class QuranReaderPreferences extends Equatable {
  final QuranReadingStyle style;
  final QuranScriptStyle scriptStyle;
  final QuranFontSize fontSize;
  final QuranReaderTheme theme;
  final QuranLineSpacing lineSpacing;
  final bool showDividers;
  final bool isAutoScrollEnabled;
  final double autoScrollSpeed;
  final bool isKeepScreenAwake;

  const QuranReaderPreferences({
    this.style = QuranReadingStyle.continuous,
    this.scriptStyle = QuranScriptStyle.uthmani,
    this.fontSize = QuranFontSize.medium,
    this.theme = QuranReaderTheme.charcoal,
    this.lineSpacing = QuranLineSpacing.relaxed,
    this.showDividers = true,
    this.isAutoScrollEnabled = false,
    this.autoScrollSpeed = 1.0,
    this.isKeepScreenAwake = true,
  });

  QuranReaderPreferences copyWith({
    QuranReadingStyle? style,
    QuranScriptStyle? scriptStyle,
    QuranFontSize? fontSize,
    QuranReaderTheme? theme,
    QuranLineSpacing? lineSpacing,
    bool? showDividers,
    bool? isAutoScrollEnabled,
    double? autoScrollSpeed,
    bool? isKeepScreenAwake,
  }) {
    return QuranReaderPreferences(
      style: style ?? this.style,
      scriptStyle: scriptStyle ?? this.scriptStyle,
      fontSize: fontSize ?? this.fontSize,
      theme: theme ?? this.theme,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      showDividers: showDividers ?? this.showDividers,
      isAutoScrollEnabled: isAutoScrollEnabled ?? this.isAutoScrollEnabled,
      autoScrollSpeed: autoScrollSpeed ?? this.autoScrollSpeed,
      isKeepScreenAwake: isKeepScreenAwake ?? this.isKeepScreenAwake,
    );
  }

  @override
  List<Object?> get props => [
        style,
        scriptStyle,
        fontSize,
        theme,
        lineSpacing,
        showDividers,
        isAutoScrollEnabled,
        autoScrollSpeed,
        isKeepScreenAwake,
      ];
}

