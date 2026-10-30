abstract final class ApiEndpoints {
  // Quran.com API v4
  static const String quranBaseUrl = 'https://api.quran.com/api/v4';
  static const String chapters = '$quranBaseUrl/chapters';
  static const String versesByChapter = '$quranBaseUrl/verses/by_chapter';
  static const String tafsir = '$quranBaseUrl/tafsirs';

  // EveryAyah Audio Streaming CDN
  static const String everyAyahAudioBase = 'https://everyayah.com/data';
  
  // Aladhan Prayer Times & Hijri Calendar
  static const String aladhanBaseUrl = 'https://api.aladhan.com/v1';
  static const String timingsByCity = '$aladhanBaseUrl/timingsByCity';
  static const String hijriCalendar = '$aladhanBaseUrl/gToH';
}

