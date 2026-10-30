import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/maladh/data/models/maladh_header_model.dart';

abstract interface class MaladhLocalDataSource {
  Future<MaladhHeaderModel> getHeaderData();
}

class MaladhLocalDataSourceImpl implements MaladhLocalDataSource {
  static const String _keyStreakDays = 'sakina_spiritual_streak_days';

  final PreferencesService preferencesService;

  const MaladhLocalDataSourceImpl({required this.preferencesService});

  @override
  Future<MaladhHeaderModel> getHeaderData() async {
    final now = DateTime.now();
    final hour = now.hour;

    // 1. Time-aware Serene Greeting & Next Prayer Determination
    final String greetingTitle;
    final String greetingSubtitle;
    final String nextPrayerName;
    final int minutesUntilPrayer;

    if (hour >= 4 && hour < 12) {
      greetingTitle = 'صَبَاحُ السَّكِينَةِ وَالطُّمَأْنِينَةِ';
      greetingSubtitle = 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ';
      nextPrayerName = 'الظُّهْرُ';
      minutesUntilPrayer = ((12 - hour) * 60 - now.minute).clamp(10, 360);
    } else if (hour >= 12 && hour < 15) {
      greetingTitle = 'طُمَأْنِينَةُ النَّهَارِ وَذِكْرُ اللهِ';
      greetingSubtitle = 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ';
      nextPrayerName = 'الْعَصْرُ';
      minutesUntilPrayer = ((15 - hour) * 60 + 30 - now.minute).clamp(10, 210);
    } else if (hour >= 15 && hour < 18) {
      greetingTitle = 'سَكِينَةُ العَصْرِ وَبَرَكَةُ الوَقْتِ';
      greetingSubtitle = 'سُبْحَانَ اللَّهِ حِينَ تُمْسُونَ وَحِينَ تُصْبِحُونَ';
      nextPrayerName = 'الْمَغْرِبُ';
      minutesUntilPrayer = ((18 - hour) * 60 - now.minute).clamp(10, 180);
    } else if (hour >= 18 && hour < 21) {
      greetingTitle = 'مَسَاءُ السَّكِينَةِ وَالرَّحْمَةِ';
      greetingSubtitle = 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، رَبِّ لَكَ الْحَمْدُ';
      nextPrayerName = 'الْعِشَاءُ';
      minutesUntilPrayer = ((20 - hour) * 60 + 30 - now.minute).clamp(10, 150);
    } else {
      greetingTitle = 'سَكِينَةُ اللَّيْلِ وَأُنْسُ القُرْآنِ';
      greetingSubtitle = 'وَالمُسْتَغْفِرِينَ بِالأَسْحَارِ 🕊️';
      nextPrayerName = 'الْفَجْرُ';
      final hoursUntilFajr = hour >= 21 ? (28 - hour) : (4 - hour);
      minutesUntilPrayer = (hoursUntilFajr * 60 - now.minute).clamp(10, 420);
    }

    // Format remaining time elegantly into hours & minutes
    final String nextPrayerRemaining = _formatRemainingTime(minutesUntilPrayer);

    // 2. Daily Verse Reflection Selection
    final reflections = _dailyReflections;
    final verseIndex = now.day % reflections.length;
    final selectedVerse = reflections[verseIndex];

    // 3. Hijri & Gregorian Arabic Dates
    final hijriDate = _computeHijriDate(now);
    final gregorianDate = _formatArabicGregorianDate(now);

    // 4. Streak Continuity
    final storedStreak = preferencesService.getInt(_keyStreakDays) ?? 3;

    return MaladhHeaderModel(
      greetingTitle: greetingTitle,
      greetingSubtitle: greetingSubtitle,
      hijriDate: hijriDate,
      gregorianDate: gregorianDate,
      dailyVerseText: selectedVerse.verse,
      dailyVerseSurah: selectedVerse.surah,
      nextPrayerName: nextPrayerName,
      nextPrayerTimeRemaining: nextPrayerRemaining,
      streakDays: storedStreak,
    );
  }

  String _formatRemainingTime(int totalMinutes) {
    if (totalMinutes < 60) {
      return 'بَعْدَ $totalMinutes دَقِيقَة';
    }

    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;

    if (mins == 0) {
      return 'بَعْدَ $hours سَاعَات';
    }

    return 'بَعْدَ $hours س و $mins د';
  }

  static const List<({String verse, String surah})> _dailyReflections = [
    (
      verse: '﴿أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ﴾',
      surah: 'سُورَةُ الرَّعْدِ • آيَة 28',
    ),
    (
      verse: '﴿فَأَنزَلَ اللَّهُ سَكِينَتَهُ عَلَيْهِ وَأَيَّدَهُ بِجُنُودٍ لَّمْ تَرَوْهَا﴾',
      surah: 'سُورَةُ التَّوْبَةِ • آيَة 40',
    ),
    (
      verse: '﴿وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ﴾',
      surah: 'سُورَةُ البَقَرَةِ • آيَة 186',
    ),
    (
      verse: '﴿إِنَّ مَعَ الْعُسْرِ يُسْرًا﴾',
      surah: 'سُورَةُ الشَّرْحِ • آيَة 6',
    ),
    (
      verse: '﴿وَرَحْمَتِي وَسِعَتْ كُلَّ شَيْءٍ﴾',
      surah: 'سُورَةُ الأَعْرَافِ • آيَة 156',
    ),
    (
      verse: '﴿وَقَالَ رَبُّكُمُ ادْعُونِي أَسْتَجِبْ لَكُمْ﴾',
      surah: 'سُورَةُ غَافِرٍ • آيَة 60',
    ),
    (
      verse: '﴿فَاصْبِرْ صَبْرًا جَمِيلًا﴾',
      surah: 'سُورَةُ المَعَارِجِ • آيَة 5',
    ),
  ];

  String _computeHijriDate(DateTime date) {
    final y = date.year;
    final m = date.month;
    final d = date.day;

    int a = ((14 - m) / 12).floor();
    int y2 = y + 4800 - a;
    int m2 = m + 12 * a - 3;
    int jdn = d + ((153 * m2 + 2) / 5).floor() + 365 * y2 + (y2 / 4).floor() - (y2 / 100).floor() + (y2 / 400).floor() - 32045;

    int l = jdn - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    int j = (((10985 - l) / 5316)).floor() * (((50 * l) / 17719)).floor() + ((l / 5670)).floor() * (((43 * l) / 15238)).floor();
    l = l - (((30 - j) / 15)).floor() * (((17719 * j) / 50)).floor() - ((j / 16)).floor() * (((15238 * j) / 43)).floor() + 29;
    int hMonth = ((24 * l) / 709).floor();
    int hDay = l - ((709 * hMonth) / 24).floor();
    int hYear = 30 * n + j - 30;

    const hijriMonths = [
      'مُحَرَّم',
      'صَفَر',
      'رَبِيع الأَوَّل',
      'رَبِيع الآخِر',
      'جُمَادَى الأُولَى',
      'جُمَادَى الآخِرَة',
      'رَجَب',
      'شَعْبَان',
      'رَمَضَان',
      'شَوَّال',
      'ذُو القِعْدَة',
      'ذُو الحِجَّة',
    ];

    final monthName = (hMonth >= 1 && hMonth <= 12) ? hijriMonths[hMonth - 1] : 'شَعْبَان';
    return '$hDay $monthName $hYear هـ';
  }

  String _formatArabicGregorianDate(DateTime date) {
    const arabicWeekdays = [
      'الإِثْنَيْن',
      'الثُّلَاثَاء',
      'الأَرْبِعَاء',
      'الخَمِيس',
      'الجُمُعَة',
      'السَّبْت',
      'الأَحَد',
    ];

    const arabicMonths = [
      'يَنَايِر',
      'فِبْرَايِر',
      'مَارِس',
      'أَبْرِيل',
      'مَايُو',
      'يُونْيُو',
      'يُولْيُو',
      'أَغُسْطُس',
      'سِبْتَمْبِر',
      'أُكْتُوبِر',
      'نُوفَمْبِر',
      'دِيسَمْبِر',
    ];

    final weekday = arabicWeekdays[date.weekday - 1];
    final day = date.day;
    final month = arabicMonths[date.month - 1];

    return '$weekday، $day $month';
  }
}
