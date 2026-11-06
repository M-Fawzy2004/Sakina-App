import 'package:intl/intl.dart';

/// Pure domain utility calculating astronomical Hijri & Gregorian dates
/// for celestial cards and prayer schedules.
abstract final class PrayerDateFormatter {
  static const List<String> _arabicDaysOfWeek = [
    'الإِثْنَيْنِ',
    'الثُّلَاثَاءِ',
    'الأَرْبِعَاءِ',
    'الخَمِيسِ',
    'الجُمُعَةِ',
    'السَّبْتِ',
    'الأَحَدِ',
  ];

  static const List<String> _arabicGregorianMonths = [
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

  static const List<String> _hijriMonthNames = [
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

  /// Returns the venerable Arabic name of the weekday (e.g. "الجُمُعَةِ").
  static String getDayNameArabic(DateTime date) {
    final weekday = date.weekday; // 1: Mon .. 7: Sun
    if (weekday >= 1 && weekday <= 7) {
      return _arabicDaysOfWeek[weekday - 1];
    }
    return 'اليَوْمِ';
  }

  /// Returns the Arabic name of the Gregorian month (e.g. "نُوفَمْبِر").
  static String getGregorianMonthNameArabic(DateTime date) {
    final m = date.month;
    if (m >= 1 && m <= 12) {
      return _arabicGregorianMonths[m - 1];
    }
    return '';
  }

  /// Formats the Gregorian date numerically as "yyyy-MM-dd" (e.g. "2026-11-06").
  static String formatGregorianNumeric(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Computes accurate tabular astronomical Hijri calendar components.
  static ({int year, int month, int day, String formattedNumeric, String monthName})
      computeHijri(DateTime date) {
    final y = date.year;
    final m = date.month;
    final d = date.day;

    final a = ((14 - m) / 12).floor();
    final y2 = y + 4800 - a;
    final m2 = m + 12 * a - 3;
    final jdn = d +
        ((153 * m2 + 2) / 5).floor() +
        365 * y2 +
        (y2 / 4).floor() -
        (y2 / 100).floor() +
        (y2 / 400).floor() -
        32045;

    final l = jdn - 1948440 + 10632;
    final n = ((l - 1) / 10631).floor();
    final l2 = l - 10631 * n + 354;
    final j = (((10985 - l2) / 5316)).floor() * (((50 * l2) / 17719)).floor() +
        ((l2 / 5670)).floor() * (((43 * l2) / 15238)).floor();
    final l3 = l2 -
        (((30 - j) / 15)).floor() * (((17719 * j) / 50)).floor() -
        ((j / 16)).floor() * (((15238 * j) / 43)).floor() +
        29;
    final hMonth = ((24 * l3) / 709).floor();
    final hDay = l3 - ((709 * hMonth) / 24).floor();
    final hYear = 30 * n + j - 30;

    final monthName = (hMonth >= 1 && hMonth <= 12)
        ? _hijriMonthNames[hMonth - 1]
        : 'جُمَادَى الأُولَى';

    final hMonthPadded = hMonth.toString().padLeft(2, '0');
    final hDayPadded = hDay.toString().padLeft(2, '0');
    final formattedNumeric = '$hYear-$hMonthPadded-$hDayPadded';

    return (
      year: hYear,
      month: hMonth,
      day: hDay,
      formattedNumeric: formattedNumeric,
      monthName: monthName,
    );
  }
}

