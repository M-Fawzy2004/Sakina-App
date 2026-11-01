import 'package:sakina_app/core/constants/api_endpoints.dart';

/// Supported EveryAyah reciter profiles for direct MP3 streaming.
class EveryAyahReciter {
  final String id;
  final String nameArabic;
  final String englishName;

  const EveryAyahReciter({
    required this.id,
    required this.nameArabic,
    required this.englishName,
  });

  static const defaultReciter = EveryAyahReciter(
    id: 'Alafasy_128kbps',
    nameArabic: 'مِشَارِي رَاشِد العَفَاسِي',
    englishName: 'Mishary Rashid Alafasy',
  );

  static const List<EveryAyahReciter> availableReciters = [
    defaultReciter,
    EveryAyahReciter(
      id: 'Abdul_Basit_Murattal_192kbps',
      nameArabic: 'عَبْدُ البَاسِطِ عَبْدُ الصَّمَد (مُرَتَّل)',
      englishName: 'Abdul Basit (Murattal)',
    ),
    EveryAyahReciter(
      id: 'Husary_128kbps',
      nameArabic: 'مَحْمُود خَلِيل الحُصَرِي',
      englishName: 'Mahmoud Khalil Al-Husary',
    ),
    EveryAyahReciter(
      id: 'Minshawy_Murattal_128kbps',
      nameArabic: 'مُحَمَّد صِدِّيق المِنْشَاوِي (مُرَتَّل)',
      englishName: 'Mohamed Siddiq Al-Minshawi',
    ),
    EveryAyahReciter(
      id: 'Ghamadi_40kbps',
      nameArabic: 'سَعْد الغَامِدِي',
      englishName: 'Saad Al-Ghamdi',
    ),
  ];
}

/// Pure domain helper that generates deterministic Per-Ayah audio URLs
/// directly from the EveryAyah CDN:
/// `https://everyayah.com/data/{reciter_id}/{surah_padded}{ayah_padded}.mp3`
abstract final class EveryAyahAudioUrlBuilder {
  static const String defaultReciterId = 'Alafasy_128kbps';

  /// Generates the deterministic EveryAyah streaming CDN URL.
  /// Both [surahNumber] and [ayahNumber] are padded to 3 digits (e.g. 001001.mp3).
  static String buildUrl({
    required int surahNumber,
    required int ayahNumber,
    String reciterId = defaultReciterId,
  }) {
    final surahPadded = surahNumber.toString().padLeft(3, '0');
    final ayahPadded = ayahNumber.toString().padLeft(3, '0');
    return '${ApiEndpoints.everyAyahAudioBase}/$reciterId/$surahPadded$ayahPadded.mp3';
  }
}

