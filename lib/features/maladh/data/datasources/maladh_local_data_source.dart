import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/maladh/data/models/maladh_header_model.dart';
import 'package:sakina_app/features/maladh/domain/services/cairo_prayer_times_calculator.dart';

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

    if (hour >= 4 && hour < 12) {
      greetingTitle = 'صَبَاحُ السَّكِينَةِ وَالطُّمَأْنِينَةِ';
      greetingSubtitle = 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ';
    } else if (hour >= 12 && hour < 15) {
      greetingTitle = 'طُمَأْنِينَةُ النَّهَارِ وَذِكْرُ اللهِ';
      greetingSubtitle = 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ';
    } else if (hour >= 15 && hour < 18) {
      greetingTitle = 'سَكِينَةُ العَصْرِ وَبَرَكَةُ الوَقْتِ';
      greetingSubtitle = 'سُبْحَانَ اللَّهِ حِينَ تُمْسُونَ وَحِينَ تُصْبِحُونَ';
    } else if (hour >= 18 && hour < 21) {
      greetingTitle = 'مَسَاءُ السَّكِينَةِ وَالرَّحْمَةِ';
      greetingSubtitle = 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، رَبِّ لَكَ الْحَمْدُ';
    } else {
      greetingTitle = 'سَكِينَةُ اللَّيْلِ وَأُنْسُ القُرْآنِ';
      greetingSubtitle = 'وَالمُسْتَغْفِرِينَ بِالأَسْحَارِ 🕊️';
    }

    final prayerInfo = CairoPrayerTimesCalculator.calculate(now);
    final String nextPrayerName = prayerInfo.nextPrayerName;
    final String nextPrayerRemaining = _formatRemainingTime(prayerInfo.remainingToNext.inMinutes);

    // 2. Sequential Daily Ayah from Surah Al-Baqarah
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final selectedVerse = _baqarahDailyVerses[dayOfYear % _baqarahDailyVerses.length];

    // 3. Hijri & Gregorian Arabic Dates
    final hijriDate = _computeHijriDate(now);
    final gregorianDate = _formatArabicGregorianDate(now);

    // 4. Streak Continuity & Preferred Reciter Audio
    final storedStreak = preferencesService.getInt(_keyStreakDays) ?? 3;
    final preferredReciterId = preferencesService.getString('sakina_settings_reciter_id') ?? 'Alafasy_128kbps';
    final resolvedAudioUrl = selectedVerse.audioUrl.replaceAll('Alafasy_128kbps', preferredReciterId);

    return MaladhHeaderModel(
      greetingTitle: greetingTitle,
      greetingSubtitle: greetingSubtitle,
      hijriDate: hijriDate,
      gregorianDate: gregorianDate,
      dailyVerseText: selectedVerse.verse,
      dailyVerseSurah: selectedVerse.surah,
      dailyVerseAudioUrl: resolvedAudioUrl,
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

  /// Authentic sequential daily verses from noble Surah Al-Baqarah and curated inspirational gems.
  static const List<({String verse, String surah, String audioUrl})> _baqarahDailyVerses = [
    (
      verse: 'الم ۝ ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ',
      surah: 'سُورَةُ البَقَرَةِ • آيَة 1-2',
      audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/002001.mp3',
    ),
    (
      verse: 'الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ',
      surah: 'سُورَةُ البَقَرَةِ • آيَة 3',
      audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/002003.mp3',
    ),
    (
      verse: 'وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنزِلَ إِلَيْكَ وَمَا أُنزِلَ مِن قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ',
      surah: 'سُورَةُ البَقَرَةِ • آيَة 4',
      audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/002004.mp3',
    ),
    (
      verse: 'أُولَٰئِكَ عَلَىٰ هُدًى مِّن رَّبِّهِمْ ۖ وَأُولَٰئِكَ هُمُ الْمُفْلِحُونَ',
      surah: 'سُورَةُ البَقَرَةِ • آيَة 5',
      audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/002005.mp3',
    ),
    (
      verse: 'فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ',
      surah: 'سُورَةُ البَقَرَةِ • آيَة 152',
      audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/002152.mp3',
    ),
    (
      verse: 'يَا أَيُّهَا الَّذِينَ آمَنُوا اسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ ۚ إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
      surah: 'سُورَةُ البَقَرَةِ • آيَة 153',
      audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/002153.mp3',
    ),
    (
      verse: 'وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ ۖ أُجِيبُ دَعْوَةَ الدَّاعِ إِذَا دَعَانِ',
      surah: 'سُورَةُ البَقَرَةِ • آيَة 186',
      audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/002186.mp3',
    ),
    (
      verse: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ',
      surah: 'سُورَةُ البَقَرَةِ • آيَة 255',
      audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/002255.mp3',
    ),
    (
      verse: 'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا ۚ لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ',
      surah: 'سُورَةُ البَقَرَةِ • آيَة 286',
      audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/002286.mp3',
    ),
    (
      verse: 'وَفِي ذَٰلِكَ فَلْيَتَنَافَسِ الْمُتَنَافِسُونَ',
      surah: 'سُورَةُ المُطَفِّفِينَ • آيَة 26',
      audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/083026.mp3',
    ),
  ];

  String _computeHijriDate(DateTime date) {
    // 1. Shift to Cairo Timezone (UTC+2)
    final cairoDate = date.toUtc().add(const Duration(hours: 2));
    // 2. Calibrate to Egyptian Dar Al-Ifta official moon sighting (+1 day offset)
    final adjustedDate = cairoDate.add(const Duration(days: 1));

    final y = adjustedDate.year;
    final m = adjustedDate.month;
    final d = adjustedDate.day;

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

    final monthName = (hMonth >= 1 && hMonth <= 12) ? hijriMonths[hMonth - 1] : 'جُمَادَى الأُولَى';
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
