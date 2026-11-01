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
  imlaei(
    title: 'الرَّسْمُ الإِمْلائِيُّ المَرِن',
    description: 'خَطٌّ قِيَاسِيٌّ مُبَسَّطٌ لِلتَّيْسِيرِ وَسُرْعَةِ التَّدَبُّرِ',
    badgeText: 'مُيَسَّر',
    fontFamily: 'Cairo',
  ),
  amiri(
    title: 'الخَطُّ الأَمِيرِيُّ القُرْآنِيُّ',
    description: 'طِبَاعَةٌ كِلاسِيكِيَّةٌ فَاخِرَةٌ تَنْبِضُ بِأَصَالَةِ النَّسْخِ',
    badgeText: 'كِلاسِيكِي',
    fontFamily: 'Amiri',
  ),
  indopak(
    title: 'الرَّسْمُ النَّسْتَعْلِيق / المَشْرِقِيُّ',
    description: 'رَسْمُ المَصَاحِفِ التَّقْلِيدِيِّ بِبِلادِ المَشْرِقِ وَآسِيَا',
    badgeText: 'مَشْرِقِي',
    fontFamily: 'Amiri',
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
  obsidian(
    title: 'الَّليْلُ المَلَكِيُّ',
    description: 'سَوَادٌ مُطْلَقٌ OLED مَعَ ذَهَبٍ خَالِصٍ',
    backgroundColor: AppColors.obsidianCore,
    cardColor: AppColors.carbonSlate,
    accentColor: AppColors.champagneGold,
    textColor: AppColors.paleRadiance,
  ),
  emerald(
    title: 'سُكُونُ المِحْرَابِ',
    description: 'رَوْحَانِيَّةُ الزُّمُرُّدِ لِلتَّدَبُّرِ وَالتَّرْتِيلِ',
    backgroundColor: AppColors.deepSanctuary,
    cardColor: AppColors.surfaceElevated,
    accentColor: AppColors.emeraldGlow,
    textColor: AppColors.pureChalk,
  ),
  amber(
    title: 'نُورُ السَّحَرِ',
    description: 'عَنْبَرٌ دَافِئٌ مُرِيحٌ لِلْعَيْنَيْنِ فِي اللَّيْلِ',
    backgroundColor: AppColors.carbonSlate,
    cardColor: AppColors.surfaceElevated,
    accentColor: AppColors.softAmber,
    textColor: AppColors.pureChalk,
  ),
  parchment(
    title: 'رَقُّ السَّكِينَةِ',
    description: 'رَقٌّ كَرِيمِيٌّ مُرِيحٌ لِلْعَيْنِ كَالْمُصْحَفِ الشَّرِيفِ',
    backgroundColor: AppColors.parchmentCore,
    cardColor: AppColors.parchmentCard,
    accentColor: AppColors.warmGold,
    textColor: AppColors.inkDeep,
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
  Color get secondaryTextColor =>
      isLight ? AppColors.inkMuted : AppColors.mutedSilver;
  Color get itemBackgroundColor =>
      isLight ? AppColors.parchmentElevated : AppColors.frostedGlass;
  Color get borderColor =>
      isLight ? AppColors.parchmentBorder : AppColors.goldBorderStroke;
}

/// Line spacing choices to ensure Tashkeel (diacritics) readability:
enum QuranLineSpacing {
  normal(title: 'عَادِي', height: 2.0),
  relaxed(title: 'مُرِيح', height: 2.3),
  spacious(title: 'وَاسِع', height: 2.6);

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
    this.style = QuranReadingStyle.verseByVerse,
    this.scriptStyle = QuranScriptStyle.uthmani,
    this.fontSize = QuranFontSize.medium,
    this.theme = QuranReaderTheme.obsidian,
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

