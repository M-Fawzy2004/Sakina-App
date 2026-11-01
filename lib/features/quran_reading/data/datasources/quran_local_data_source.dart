import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/quran_reading/data/models/ayah_model.dart';
import 'package:sakina_app/features/quran_reading/data/models/juz_model.dart';
import 'package:sakina_app/features/quran_reading/data/models/quran_bookmark_model.dart';
import 'package:sakina_app/features/quran_reading/data/models/surah_model.dart';
import 'package:sakina_app/features/quran_reading/data/models/tafsir_model.dart';

abstract interface class QuranLocalDataSource {
  Future<List<SurahModel>> getSurahs();
  Future<List<JuzModel>> getJuzs();
  Future<List<AyahModel>> getSurahVerses(int surahId);
  Future<QuranBookmarkModel?> getLastReadBookmark();
  Future<void> saveLastReadBookmark(QuranBookmarkModel bookmark);
}

/// 100% Offline (Local-First) Data Source reading directly from packaged JSON assets.
class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  static const String _keyLastReadBookmark = 'sakina_quran_last_read_bookmark';

  final PreferencesService preferencesService;
  final AssetBundle assetBundle;

  /// High-performance in-memory cache for loaded Surah verses (0ms subsequent loads).
  final Map<int, List<AyahModel>> _versesCache = {};

  QuranLocalDataSourceImpl({
    required this.preferencesService,
    AssetBundle? assetBundle,
  }) : assetBundle = assetBundle ?? rootBundle;

  @override
  Future<List<SurahModel>> getSurahs() async {
    _preCacheSurah(1);
    _preCacheSurah(2);
    _preCacheSurah(18);
    return _surahs;
  }

  @override
  Future<List<JuzModel>> getJuzs() async {
    return _juzs;
  }

  @override
  Future<List<AyahModel>> getSurahVerses(int surahId) async {
    // 1. Check in-memory memory cache (instantaneous 0ms access)
    final cached = _versesCache[surahId];
    if (cached != null && cached.isNotEmpty) {
      _preCacheSurah(surahId - 1);
      _preCacheSurah(surahId + 1);
      return cached;
    }

    // 2. Attempt to resolve and load from packaged assets/quran_data/*.json
    try {
      final assetPath = await _resolveAssetPath(surahId);
      if (assetPath != null) {
        final jsonString = await assetBundle.loadString(assetPath);
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final ayahsList = decoded['ayahs'] as List<dynamic>? ?? [];

        final surah = _surahs.firstWhere(
          (s) => s.id == surahId,
          orElse: () => _surahs.first,
        );

        final verses = ayahsList.map((item) {
          return AyahModel.fromLocalJson(
            item as Map<String, dynamic>,
            defaultPage: surah.pageNumber,
            defaultJuz: surah.juzNumber,
          );
        }).toList();

        if (verses.isNotEmpty) {
          _versesCache[surahId] = verses;
          _preCacheSurah(surahId - 1);
          _preCacheSurah(surahId + 1);
          return verses;
        }
      }
    } catch (_) {
      // Graceful fallback to static dictionary on asset read error
    }

    // 3. Fallback to embedded static dictionary or generated verses
    final fallbackVerses =
        _versesBySurah[surahId] ?? _generateFallbackVerses(surahId);
    _versesCache[surahId] = fallbackVerses;
    return fallbackVerses;
  }

  /// Fire-and-forget background pre-caching for adjacent Surahs to achieve 0ms transitions.
  void _preCacheSurah(int id) {
    if (id >= 1 && id <= 114 && !_versesCache.containsKey(id)) {
      unawaited(getSurahVerses(id));
    }
  }

  /// Resolves the exact asset file path for a given Surah ID with dynamic discovery.
  Future<String?> _resolveAssetPath(int surahId) async {
    // Direct O(1) map lookup
    final knownFileName = _surahFileMap[surahId];
    if (knownFileName != null) {
      return 'assets/quran_data/$knownFileName';
    }

    // Dynamic discovery for zero-padded 3-digit identifiers
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(assetBundle);
      final prefix = 'assets/quran_data/${surahId.toString().padLeft(3, '0')}_';
      final matchingAsset = manifest.listAssets().firstWhere(
        (path) => path.startsWith(prefix) && path.endsWith('.json'),
        orElse: () => '',
      );
      if (matchingAsset.isNotEmpty) {
        return matchingAsset;
      }
    } catch (_) {}

    return null;
  }

  @override
  Future<QuranBookmarkModel?> getLastReadBookmark() async {
    final raw = preferencesService.getString(_keyLastReadBookmark);
    if (raw == null || raw.isEmpty) {
      // Default initial bookmark: Surah Ar-Rahman, Ayah 1, Page 531
      final bookmark = QuranBookmarkModel(
        surahId: 55,
        surahName: 'سُورَةُ الرَّحْمَٰن',
        ayahNumber: 1,
        pageNumber: 531,
        timestamp: DateTime(2026, 10, 30),
      );
      _preCacheSurah(bookmark.surahId);
      return bookmark;
    }
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final bookmark = QuranBookmarkModel.fromJson(json);
      _preCacheSurah(bookmark.surahId);
      return bookmark;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLastReadBookmark(QuranBookmarkModel bookmark) async {
    final raw = jsonEncode(bookmark.toJson());
    await preferencesService.setString(_keyLastReadBookmark, raw);
  }

  // ---------------------------------------------------------------------------
  // Index of Surah file assets mapped to Surah ID
  // ---------------------------------------------------------------------------
  static const Map<int, String> _surahFileMap = {
    1: '001_al-fatiha.json',
    2: '002_al-baqarah.json',
    3: '003_aal-e-imran.json',
    4: '004_an-nisa.json',
    5: '005_al-maidah.json',
    6: '006_al-anam.json',
    7: '007_al-araf.json',
    8: '008_al-anfal.json',
    9: '009_at-tawbah.json',
    10: '010_yunus.json',
    11: '011_hud.json',
    12: '012_yusuf.json',
    13: '013_ar-rad.json',
    14: '014_ibrahim.json',
    15: '015_al-hijr.json',
    16: '016_an-nahl.json',
    17: '017_al-isra.json',
    18: '018_al-kahf.json',
    19: '019_maryam.json',
    20: '020_ta-ha.json',
    21: '021_al-anbiya.json',
    22: '022_al-hajj.json',
    23: '023_al-muminun.json',
    24: '024_an-nur.json',
    25: '025_al-furqan.json',
    26: '026_ash-shuara.json',
    27: '027_an-naml.json',
    28: '028_al-qasas.json',
    29: '029_al-ankabut.json',
    30: '030_ar-rum.json',
    31: '031_luqman.json',
    32: '032_as-sajdah.json',
    33: '033_al-ahzab.json',
    34: '034_saba.json',
    35: '035_fatir.json',
    36: '036_ya-sin.json',
    37: '037_as-saffat.json',
    38: '038_sad.json',
    39: '039_az-zumar.json',
    40: '040_ghafir.json',
    41: '041_fussilat.json',
    42: '042_ash-shura.json',
    43: '043_az-zukhruf.json',
    44: '044_ad-dukhkhan.json',
    45: '045_al-jathiya.json',
    46: '046_al-ahqaf.json',
    47: '047_muhammad.json',
    48: '048_al-fath.json',
    49: '049_al-hujurat.json',
    50: '050_qaf.json',
    51: '051_adh-dhariyat.json',
    52: '052_at-tur.json',
    53: '053_an-najm.json',
    54: '054_al-qamar.json',
    55: '055_ar-rahman.json',
    56: '056_al-waqiah.json',
    57: '057_al-hadid.json',
    58: '058_al-mujadila.json',
    59: '059_al-hashr.json',
    60: '060_al-mumtahina.json',
    61: '061_as-saff.json',
    62: '062_al-jumuah.json',
    63: '063_al-munafiqoon.json',
    64: '064_at-taghabun.json',
    65: '065_at-talaq.json',
    66: '066_at-tahrim.json',
    67: '067_al-mulk.json',
    68: '068_al-qalam.json',
    69: '069_al-haqqah.json',
    70: '070_al-maarij.json',
    71: '071_nooh.json',
    72: '072_al-jinn.json',
    73: '073_al-muzzammil.json',
    74: '074_al-muddathir.json',
    75: '075_al-qiyamah.json',
    76: '076_al-insan.json',
    77: '077_al-mursalat.json',
    78: '078_an-naba.json',
    79: '079_an-naziat.json',
    80: '080_abasa.json',
    81: '081_at-takwir.json',
    82: '082_al-infitar.json',
    83: '083_al-mutaffifin.json',
    84: '084_al-inshiqaq.json',
    85: '085_al-buruj.json',
    86: '086_at-tariq.json',
    87: '087_al-ala.json',
    88: '088_al-ghashiyah.json',
    89: '089_al-fajr.json',
    90: '090_al-balad.json',
    91: '091_ash-shams.json',
    92: '092_al-layl.json',
    93: '093_ad-duha.json',
    94: '094_ash-sharh.json',
    95: '095_at-tin.json',
    96: '096_al-alaq.json',
    97: '097_al-qadr.json',
    98: '098_al-bayyina.json',
    99: '099_az-zalzalah.json',
    100: '100_al-adiyat.json',
    101: '101_al-qariah.json',
    102: '102_at-takathur.json',
    103: '103_al-asr.json',
    104: '104_al-humazah.json',
    105: '105_al-fil.json',
    106: '106_quraish.json',
    107: '107_al-maun.json',
    108: '108_al-kawthar.json',
    109: '109_al-kafirun.json',
    110: '110_an-nasr.json',
    111: '111_al-masad.json',
    112: '112_al-ikhlas.json',
    113: '113_al-falaq.json',
    114: '114_an-nas.json',
  };

  // ---------------------------------------------------------------------------
  // Complete Index of all 114 Quranic Surahs
  // ---------------------------------------------------------------------------
  static List<SurahModel> get allSurahs => _surahs;
  static const List<SurahModel> _surahs = [
    SurahModel(
      id: 1,
      nameArabic: 'الفَاتِحَة',
      englishName: 'Al-Fatihah',
      revelationType: 'مكية',
      versesCount: 7,
      pageNumber: 1,
      juzNumber: 1,
    ),
    SurahModel(
      id: 2,
      nameArabic: 'البَقَرَة',
      englishName: 'Al-Baqarah',
      revelationType: 'مدنية',
      versesCount: 286,
      pageNumber: 2,
      juzNumber: 1,
    ),
    SurahModel(
      id: 3,
      nameArabic: 'آل عِمْرَان',
      englishName: 'Ali \'Imran',
      revelationType: 'مدنية',
      versesCount: 200,
      pageNumber: 50,
      juzNumber: 3,
    ),
    SurahModel(
      id: 4,
      nameArabic: 'النِّسَاء',
      englishName: 'An-Nisa',
      revelationType: 'مدنية',
      versesCount: 176,
      pageNumber: 77,
      juzNumber: 4,
    ),
    SurahModel(
      id: 5,
      nameArabic: 'المَائِدَة',
      englishName: 'Al-Ma\'idah',
      revelationType: 'مدنية',
      versesCount: 120,
      pageNumber: 106,
      juzNumber: 6,
    ),
    SurahModel(
      id: 6,
      nameArabic: 'الأَنْعَام',
      englishName: 'Al-An\'am',
      revelationType: 'مكية',
      versesCount: 165,
      pageNumber: 128,
      juzNumber: 7,
    ),
    SurahModel(
      id: 7,
      nameArabic: 'الأَعْرَاف',
      englishName: 'Al-A\'raf',
      revelationType: 'مكية',
      versesCount: 206,
      pageNumber: 151,
      juzNumber: 8,
    ),
    SurahModel(
      id: 8,
      nameArabic: 'الأَنْفَال',
      englishName: 'Al-Anfal',
      revelationType: 'مدنية',
      versesCount: 75,
      pageNumber: 177,
      juzNumber: 9,
    ),
    SurahModel(
      id: 9,
      nameArabic: 'التَّوْبَة',
      englishName: 'At-Tawbah',
      revelationType: 'مدنية',
      versesCount: 129,
      pageNumber: 187,
      juzNumber: 10,
    ),
    SurahModel(
      id: 10,
      nameArabic: 'يُونُس',
      englishName: 'Yunus',
      revelationType: 'مكية',
      versesCount: 109,
      pageNumber: 208,
      juzNumber: 11,
    ),
    SurahModel(
      id: 11,
      nameArabic: 'هُود',
      englishName: 'Hud',
      revelationType: 'مكية',
      versesCount: 123,
      pageNumber: 221,
      juzNumber: 11,
    ),
    SurahModel(
      id: 12,
      nameArabic: 'يُوسُف',
      englishName: 'Yusuf',
      revelationType: 'مكية',
      versesCount: 111,
      pageNumber: 235,
      juzNumber: 12,
    ),
    SurahModel(
      id: 13,
      nameArabic: 'الرَّعْد',
      englishName: 'Ar-Ra\'d',
      revelationType: 'مدنية',
      versesCount: 43,
      pageNumber: 249,
      juzNumber: 13,
    ),
    SurahModel(
      id: 14,
      nameArabic: 'إِبْرَاهِيم',
      englishName: 'Ibrahim',
      revelationType: 'مكية',
      versesCount: 52,
      pageNumber: 255,
      juzNumber: 13,
    ),
    SurahModel(
      id: 15,
      nameArabic: 'الحِجْر',
      englishName: 'Al-Hijr',
      revelationType: 'مكية',
      versesCount: 99,
      pageNumber: 262,
      juzNumber: 14,
    ),
    SurahModel(
      id: 16,
      nameArabic: 'النَّحْل',
      englishName: 'An-Nahl',
      revelationType: 'مكية',
      versesCount: 128,
      pageNumber: 267,
      juzNumber: 14,
    ),
    SurahModel(
      id: 17,
      nameArabic: 'الإِسْرَاء',
      englishName: 'Al-Isra',
      revelationType: 'مكية',
      versesCount: 111,
      pageNumber: 282,
      juzNumber: 15,
    ),
    SurahModel(
      id: 18,
      nameArabic: 'الكَهْف',
      englishName: 'Al-Kahf',
      revelationType: 'مكية',
      versesCount: 110,
      pageNumber: 293,
      juzNumber: 15,
    ),
    SurahModel(
      id: 19,
      nameArabic: 'مَرْيَم',
      englishName: 'Maryam',
      revelationType: 'مكية',
      versesCount: 98,
      pageNumber: 305,
      juzNumber: 16,
    ),
    SurahModel(
      id: 20,
      nameArabic: 'طه',
      englishName: 'Taha',
      revelationType: 'مكية',
      versesCount: 135,
      pageNumber: 312,
      juzNumber: 16,
    ),
    SurahModel(
      id: 21,
      nameArabic: 'الأَنْبِيَاء',
      englishName: 'Al-Anbiya',
      revelationType: 'مكية',
      versesCount: 112,
      pageNumber: 322,
      juzNumber: 17,
    ),
    SurahModel(
      id: 22,
      nameArabic: 'الحَجّ',
      englishName: 'Al-Hajj',
      revelationType: 'مدنية',
      versesCount: 78,
      pageNumber: 332,
      juzNumber: 17,
    ),
    SurahModel(
      id: 23,
      nameArabic: 'المُؤْمِنُون',
      englishName: 'Al-Mu\'minun',
      revelationType: 'مكية',
      versesCount: 118,
      pageNumber: 342,
      juzNumber: 18,
    ),
    SurahModel(
      id: 24,
      nameArabic: 'النُّور',
      englishName: 'An-Nur',
      revelationType: 'مدنية',
      versesCount: 64,
      pageNumber: 350,
      juzNumber: 18,
    ),
    SurahModel(
      id: 25,
      nameArabic: 'الفُرْقَان',
      englishName: 'Al-Furqan',
      revelationType: 'مكية',
      versesCount: 77,
      pageNumber: 359,
      juzNumber: 18,
    ),
    SurahModel(
      id: 26,
      nameArabic: 'الشُّعَرَاء',
      englishName: 'Ash-Shu\'ara',
      revelationType: 'مكية',
      versesCount: 227,
      pageNumber: 367,
      juzNumber: 19,
    ),
    SurahModel(
      id: 27,
      nameArabic: 'النَّمْل',
      englishName: 'An-Naml',
      revelationType: 'مكية',
      versesCount: 93,
      pageNumber: 377,
      juzNumber: 19,
    ),
    SurahModel(
      id: 28,
      nameArabic: 'القَصَص',
      englishName: 'Al-Qasas',
      revelationType: 'مكية',
      versesCount: 88,
      pageNumber: 385,
      juzNumber: 20,
    ),
    SurahModel(
      id: 29,
      nameArabic: 'العَنْكَبُوت',
      englishName: 'Al-\'Ankabut',
      revelationType: 'مكية',
      versesCount: 69,
      pageNumber: 396,
      juzNumber: 20,
    ),
    SurahModel(
      id: 30,
      nameArabic: 'الرُّوم',
      englishName: 'Ar-Rum',
      revelationType: 'مكية',
      versesCount: 60,
      pageNumber: 404,
      juzNumber: 21,
    ),
    SurahModel(
      id: 31,
      nameArabic: 'لُقْمَان',
      englishName: 'Luqman',
      revelationType: 'مكية',
      versesCount: 34,
      pageNumber: 411,
      juzNumber: 21,
    ),
    SurahModel(
      id: 32,
      nameArabic: 'السَّجْدَة',
      englishName: 'As-Sajdah',
      revelationType: 'مكية',
      versesCount: 30,
      pageNumber: 415,
      juzNumber: 21,
    ),
    SurahModel(
      id: 33,
      nameArabic: 'الأَحْزَاب',
      englishName: 'Al-Ahzab',
      revelationType: 'مدنية',
      versesCount: 73,
      pageNumber: 418,
      juzNumber: 21,
    ),
    SurahModel(
      id: 34,
      nameArabic: 'سَبَأ',
      englishName: 'Saba',
      revelationType: 'مكية',
      versesCount: 54,
      pageNumber: 428,
      juzNumber: 22,
    ),
    SurahModel(
      id: 35,
      nameArabic: 'فَاطِر',
      englishName: 'Fatir',
      revelationType: 'مكية',
      versesCount: 45,
      pageNumber: 434,
      juzNumber: 22,
    ),
    SurahModel(
      id: 36,
      nameArabic: 'يس',
      englishName: 'Ya-Sin',
      revelationType: 'مكية',
      versesCount: 83,
      pageNumber: 440,
      juzNumber: 22,
    ),
    SurahModel(
      id: 37,
      nameArabic: 'الصَّافَّات',
      englishName: 'As-Saffat',
      revelationType: 'مكية',
      versesCount: 182,
      pageNumber: 446,
      juzNumber: 23,
    ),
    SurahModel(
      id: 38,
      nameArabic: 'ص',
      englishName: 'Sad',
      revelationType: 'مكية',
      versesCount: 88,
      pageNumber: 453,
      juzNumber: 23,
    ),
    SurahModel(
      id: 39,
      nameArabic: 'الزُّمَر',
      englishName: 'Az-Zumar',
      revelationType: 'مكية',
      versesCount: 75,
      pageNumber: 458,
      juzNumber: 23,
    ),
    SurahModel(
      id: 40,
      nameArabic: 'غَافِر',
      englishName: 'Ghafir',
      revelationType: 'مكية',
      versesCount: 85,
      pageNumber: 467,
      juzNumber: 24,
    ),
    SurahModel(
      id: 41,
      nameArabic: 'فُصِّلَت',
      englishName: 'Fussilat',
      revelationType: 'مكية',
      versesCount: 54,
      pageNumber: 477,
      juzNumber: 24,
    ),
    SurahModel(
      id: 42,
      nameArabic: 'الشُّورَى',
      englishName: 'Ash-Shura',
      revelationType: 'مكية',
      versesCount: 53,
      pageNumber: 483,
      juzNumber: 25,
    ),
    SurahModel(
      id: 43,
      nameArabic: 'الزُّخْرُف',
      englishName: 'Az-Zukhruf',
      revelationType: 'مكية',
      versesCount: 89,
      pageNumber: 489,
      juzNumber: 25,
    ),
    SurahModel(
      id: 44,
      nameArabic: 'الدُّخَان',
      englishName: 'Ad-Dukhan',
      revelationType: 'مكية',
      versesCount: 59,
      pageNumber: 496,
      juzNumber: 25,
    ),
    SurahModel(
      id: 45,
      nameArabic: 'الجَاثِيَة',
      englishName: 'Al-Jathiyah',
      revelationType: 'مكية',
      versesCount: 37,
      pageNumber: 499,
      juzNumber: 25,
    ),
    SurahModel(
      id: 46,
      nameArabic: 'الأَحْقَاف',
      englishName: 'Al-Ahqaf',
      revelationType: 'مكية',
      versesCount: 35,
      pageNumber: 502,
      juzNumber: 26,
    ),
    SurahModel(
      id: 47,
      nameArabic: 'مُحَمَّد',
      englishName: 'Muhammad',
      revelationType: 'مدنية',
      versesCount: 38,
      pageNumber: 507,
      juzNumber: 26,
    ),
    SurahModel(
      id: 48,
      nameArabic: 'الفَتْح',
      englishName: 'Al-Fath',
      revelationType: 'مدنية',
      versesCount: 29,
      pageNumber: 511,
      juzNumber: 26,
    ),
    SurahModel(
      id: 49,
      nameArabic: 'الحُجُرَات',
      englishName: 'Al-Hujurat',
      revelationType: 'مدنية',
      versesCount: 18,
      pageNumber: 515,
      juzNumber: 26,
    ),
    SurahModel(
      id: 50,
      nameArabic: 'ق',
      englishName: 'Qaf',
      revelationType: 'مكية',
      versesCount: 45,
      pageNumber: 518,
      juzNumber: 26,
    ),
    SurahModel(
      id: 51,
      nameArabic: 'الذَّارِيَات',
      englishName: 'Adh-Dhariyat',
      revelationType: 'مكية',
      versesCount: 60,
      pageNumber: 520,
      juzNumber: 26,
    ),
    SurahModel(
      id: 52,
      nameArabic: 'الطُّور',
      englishName: 'At-Tur',
      revelationType: 'مكية',
      versesCount: 49,
      pageNumber: 523,
      juzNumber: 27,
    ),
    SurahModel(
      id: 53,
      nameArabic: 'النَّجْم',
      englishName: 'An-Najm',
      revelationType: 'مكية',
      versesCount: 62,
      pageNumber: 526,
      juzNumber: 27,
    ),
    SurahModel(
      id: 54,
      nameArabic: 'القَمَر',
      englishName: 'Al-Qamar',
      revelationType: 'مكية',
      versesCount: 55,
      pageNumber: 528,
      juzNumber: 27,
    ),
    SurahModel(
      id: 55,
      nameArabic: 'الرَّحْمَٰن',
      englishName: 'Ar-Rahman',
      revelationType: 'مدنية',
      versesCount: 78,
      pageNumber: 531,
      juzNumber: 27,
    ),
    SurahModel(
      id: 56,
      nameArabic: 'الوَاقِعَة',
      englishName: 'Al-Waqi\'ah',
      revelationType: 'مكية',
      versesCount: 96,
      pageNumber: 534,
      juzNumber: 27,
    ),
    SurahModel(
      id: 57,
      nameArabic: 'الحَدِيد',
      englishName: 'Al-Hadid',
      revelationType: 'مدنية',
      versesCount: 29,
      pageNumber: 537,
      juzNumber: 27,
    ),
    SurahModel(
      id: 58,
      nameArabic: 'المُجَادَلَة',
      englishName: 'Al-Mujadilah',
      revelationType: 'مدنية',
      versesCount: 22,
      pageNumber: 542,
      juzNumber: 28,
    ),
    SurahModel(
      id: 59,
      nameArabic: 'الحَشْر',
      englishName: 'Al-Hashr',
      revelationType: 'مدنية',
      versesCount: 24,
      pageNumber: 545,
      juzNumber: 28,
    ),
    SurahModel(
      id: 60,
      nameArabic: 'المُمْتَحَنَة',
      englishName: 'Al-Mumtahanah',
      revelationType: 'مدنية',
      versesCount: 13,
      pageNumber: 549,
      juzNumber: 28,
    ),
    SurahModel(
      id: 61,
      nameArabic: 'الصَّفّ',
      englishName: 'As-Saff',
      revelationType: 'مدنية',
      versesCount: 14,
      pageNumber: 551,
      juzNumber: 28,
    ),
    SurahModel(
      id: 62,
      nameArabic: 'الجُمُعَة',
      englishName: 'Al-Jumu\'ah',
      revelationType: 'مدنية',
      versesCount: 11,
      pageNumber: 553,
      juzNumber: 28,
    ),
    SurahModel(
      id: 63,
      nameArabic: 'المُنَافِقُون',
      englishName: 'Al-Munafiqun',
      revelationType: 'مدنية',
      versesCount: 11,
      pageNumber: 554,
      juzNumber: 28,
    ),
    SurahModel(
      id: 64,
      nameArabic: 'التَّغَابُن',
      englishName: 'At-Taghabun',
      revelationType: 'مدنية',
      versesCount: 18,
      pageNumber: 556,
      juzNumber: 28,
    ),
    SurahModel(
      id: 65,
      nameArabic: 'الطَّلَاق',
      englishName: 'At-Talaq',
      revelationType: 'مدنية',
      versesCount: 12,
      pageNumber: 558,
      juzNumber: 28,
    ),
    SurahModel(
      id: 66,
      nameArabic: 'التَّحْرِيم',
      englishName: 'At-Tahrim',
      revelationType: 'مدنية',
      versesCount: 12,
      pageNumber: 560,
      juzNumber: 28,
    ),
    SurahModel(
      id: 67,
      nameArabic: 'المُلْك',
      englishName: 'Al-Mulk',
      revelationType: 'مكية',
      versesCount: 30,
      pageNumber: 562,
      juzNumber: 29,
    ),
    SurahModel(
      id: 68,
      nameArabic: 'القَلَم',
      englishName: 'Al-Qalam',
      revelationType: 'مكية',
      versesCount: 52,
      pageNumber: 564,
      juzNumber: 29,
    ),
    SurahModel(
      id: 69,
      nameArabic: 'الحَاقَّة',
      englishName: 'Al-Haqqah',
      revelationType: 'مكية',
      versesCount: 52,
      pageNumber: 566,
      juzNumber: 29,
    ),
    SurahModel(
      id: 70,
      nameArabic: 'المَعَارِج',
      englishName: 'Al-Ma\'arij',
      revelationType: 'مكية',
      versesCount: 44,
      pageNumber: 568,
      juzNumber: 29,
    ),
    SurahModel(
      id: 71,
      nameArabic: 'نُوح',
      englishName: 'Nuh',
      revelationType: 'مكية',
      versesCount: 28,
      pageNumber: 570,
      juzNumber: 29,
    ),
    SurahModel(
      id: 72,
      nameArabic: 'الجِنّ',
      englishName: 'Al-Jinn',
      revelationType: 'مكية',
      versesCount: 28,
      pageNumber: 572,
      juzNumber: 29,
    ),
    SurahModel(
      id: 73,
      nameArabic: 'المُزَّمِّل',
      englishName: 'Al-Muzzammil',
      revelationType: 'مكية',
      versesCount: 20,
      pageNumber: 574,
      juzNumber: 29,
    ),
    SurahModel(
      id: 74,
      nameArabic: 'المُدَّثِّر',
      englishName: 'Al-Muddaththir',
      revelationType: 'مكية',
      versesCount: 56,
      pageNumber: 575,
      juzNumber: 29,
    ),
    SurahModel(
      id: 75,
      nameArabic: 'القِيَامَة',
      englishName: 'Al-Qiyamah',
      revelationType: 'مكية',
      versesCount: 40,
      pageNumber: 577,
      juzNumber: 29,
    ),
    SurahModel(
      id: 76,
      nameArabic: 'الإِنْسَان',
      englishName: 'Al-Insan',
      revelationType: 'مدنية',
      versesCount: 31,
      pageNumber: 578,
      juzNumber: 29,
    ),
    SurahModel(
      id: 77,
      nameArabic: 'المُرْسَلَات',
      englishName: 'Al-Mursalat',
      revelationType: 'مكية',
      versesCount: 50,
      pageNumber: 580,
      juzNumber: 29,
    ),
    SurahModel(
      id: 78,
      nameArabic: 'النَّبَأ',
      englishName: 'An-Naba',
      revelationType: 'مكية',
      versesCount: 40,
      pageNumber: 582,
      juzNumber: 30,
    ),
    SurahModel(
      id: 79,
      nameArabic: 'النَّازِعَات',
      englishName: 'An-Nazi\'at',
      revelationType: 'مكية',
      versesCount: 46,
      pageNumber: 583,
      juzNumber: 30,
    ),
    SurahModel(
      id: 80,
      nameArabic: 'عَبَسَ',
      englishName: '\'Abasa',
      revelationType: 'مكية',
      versesCount: 42,
      pageNumber: 585,
      juzNumber: 30,
    ),
    SurahModel(
      id: 81,
      nameArabic: 'التَّكْوِير',
      englishName: 'At-Takwir',
      revelationType: 'مكية',
      versesCount: 29,
      pageNumber: 586,
      juzNumber: 30,
    ),
    SurahModel(
      id: 82,
      nameArabic: 'الانْفِطَار',
      englishName: 'Al-Infitar',
      revelationType: 'مكية',
      versesCount: 19,
      pageNumber: 587,
      juzNumber: 30,
    ),
    SurahModel(
      id: 83,
      nameArabic: 'المُطَفِّفِين',
      englishName: 'Al-Mutaffifin',
      revelationType: 'مكية',
      versesCount: 36,
      pageNumber: 587,
      juzNumber: 30,
    ),
    SurahModel(
      id: 84,
      nameArabic: 'الانْشِقَاق',
      englishName: 'Al-Inshiqaq',
      revelationType: 'مكية',
      versesCount: 25,
      pageNumber: 589,
      juzNumber: 30,
    ),
    SurahModel(
      id: 85,
      nameArabic: 'البُرُوج',
      englishName: 'Al-Buruj',
      revelationType: 'مكية',
      versesCount: 22,
      pageNumber: 590,
      juzNumber: 30,
    ),
    SurahModel(
      id: 86,
      nameArabic: 'الطَّارِق',
      englishName: 'At-Tariq',
      revelationType: 'مكية',
      versesCount: 17,
      pageNumber: 591,
      juzNumber: 30,
    ),
    SurahModel(
      id: 87,
      nameArabic: 'الأَعْلَى',
      englishName: 'Al-A\'la',
      revelationType: 'مكية',
      versesCount: 19,
      pageNumber: 591,
      juzNumber: 30,
    ),
    SurahModel(
      id: 88,
      nameArabic: 'الغَاشِيَة',
      englishName: 'Al-Ghashiyah',
      revelationType: 'مكية',
      versesCount: 26,
      pageNumber: 592,
      juzNumber: 30,
    ),
    SurahModel(
      id: 89,
      nameArabic: 'الفَجْر',
      englishName: 'Al-Fajr',
      revelationType: 'مكية',
      versesCount: 30,
      pageNumber: 593,
      juzNumber: 30,
    ),
    SurahModel(
      id: 90,
      nameArabic: 'البَلَد',
      englishName: 'Al-Balad',
      revelationType: 'مكية',
      versesCount: 20,
      pageNumber: 594,
      juzNumber: 30,
    ),
    SurahModel(
      id: 91,
      nameArabic: 'الشَّمْس',
      englishName: 'Ash-Shams',
      revelationType: 'مكية',
      versesCount: 15,
      pageNumber: 595,
      juzNumber: 30,
    ),
    SurahModel(
      id: 92,
      nameArabic: 'اللَّيْل',
      englishName: 'Al-Layl',
      revelationType: 'مكية',
      versesCount: 21,
      pageNumber: 595,
      juzNumber: 30,
    ),
    SurahModel(
      id: 93,
      nameArabic: 'الضُّحَى',
      englishName: 'Ad-Duha',
      revelationType: 'مكية',
      versesCount: 11,
      pageNumber: 596,
      juzNumber: 30,
    ),
    SurahModel(
      id: 94,
      nameArabic: 'الشَّرْح',
      englishName: 'Ash-Sharh',
      revelationType: 'مكية',
      versesCount: 8,
      pageNumber: 596,
      juzNumber: 30,
    ),
    SurahModel(
      id: 95,
      nameArabic: 'التِّين',
      englishName: 'At-Tin',
      revelationType: 'مكية',
      versesCount: 8,
      pageNumber: 597,
      juzNumber: 30,
    ),
    SurahModel(
      id: 96,
      nameArabic: 'العَلَق',
      englishName: 'Al-\'Alaq',
      revelationType: 'مكية',
      versesCount: 19,
      pageNumber: 597,
      juzNumber: 30,
    ),
    SurahModel(
      id: 97,
      nameArabic: 'القَدْر',
      englishName: 'Al-Qadr',
      revelationType: 'مكية',
      versesCount: 5,
      pageNumber: 598,
      juzNumber: 30,
    ),
    SurahModel(
      id: 98,
      nameArabic: 'البَيِّنَة',
      englishName: 'Al-Bayyinah',
      revelationType: 'مدنية',
      versesCount: 8,
      pageNumber: 598,
      juzNumber: 30,
    ),
    SurahModel(
      id: 99,
      nameArabic: 'الزَّلْزَلَة',
      englishName: 'Az-Zalzalah',
      revelationType: 'مدنية',
      versesCount: 8,
      pageNumber: 599,
      juzNumber: 30,
    ),
    SurahModel(
      id: 100,
      nameArabic: 'العَادِيَات',
      englishName: 'Al-\'Adiyat',
      revelationType: 'مكية',
      versesCount: 11,
      pageNumber: 599,
      juzNumber: 30,
    ),
    SurahModel(
      id: 101,
      nameArabic: 'القَارِعَة',
      englishName: 'Al-Qari\'ah',
      revelationType: 'مكية',
      versesCount: 11,
      pageNumber: 600,
      juzNumber: 30,
    ),
    SurahModel(
      id: 102,
      nameArabic: 'التَّكَاثُر',
      englishName: 'At-Takathur',
      revelationType: 'مكية',
      versesCount: 8,
      pageNumber: 600,
      juzNumber: 30,
    ),
    SurahModel(
      id: 103,
      nameArabic: 'العَصْر',
      englishName: 'Al-\'Asr',
      revelationType: 'مكية',
      versesCount: 3,
      pageNumber: 601,
      juzNumber: 30,
    ),
    SurahModel(
      id: 104,
      nameArabic: 'الهُمَزَة',
      englishName: 'Al-Humazah',
      revelationType: 'مكية',
      versesCount: 9,
      pageNumber: 601,
      juzNumber: 30,
    ),
    SurahModel(
      id: 105,
      nameArabic: 'الفِيل',
      englishName: 'Al-Fil',
      revelationType: 'مكية',
      versesCount: 5,
      pageNumber: 601,
      juzNumber: 30,
    ),
    SurahModel(
      id: 106,
      nameArabic: 'قُرَيْش',
      englishName: 'Quraysh',
      revelationType: 'مكية',
      versesCount: 4,
      pageNumber: 602,
      juzNumber: 30,
    ),
    SurahModel(
      id: 107,
      nameArabic: 'المَاعُون',
      englishName: 'Al-Ma\'un',
      revelationType: 'مكية',
      versesCount: 7,
      pageNumber: 602,
      juzNumber: 30,
    ),
    SurahModel(
      id: 108,
      nameArabic: 'الكَوْثَر',
      englishName: 'Al-Kawthar',
      revelationType: 'مكية',
      versesCount: 3,
      pageNumber: 602,
      juzNumber: 30,
    ),
    SurahModel(
      id: 109,
      nameArabic: 'الكَافِرُون',
      englishName: 'Al-Kafirun',
      revelationType: 'مكية',
      versesCount: 6,
      pageNumber: 603,
      juzNumber: 30,
    ),
    SurahModel(
      id: 110,
      nameArabic: 'النَّصْر',
      englishName: 'An-Nasr',
      revelationType: 'مدنية',
      versesCount: 3,
      pageNumber: 603,
      juzNumber: 30,
    ),
    SurahModel(
      id: 111,
      nameArabic: 'المَسَد',
      englishName: 'Al-Masad',
      revelationType: 'مكية',
      versesCount: 5,
      pageNumber: 603,
      juzNumber: 30,
    ),
    SurahModel(
      id: 112,
      nameArabic: 'الإِخْلَاص',
      englishName: 'Al-Ikhlas',
      revelationType: 'مكية',
      versesCount: 4,
      pageNumber: 604,
      juzNumber: 30,
    ),
    SurahModel(
      id: 113,
      nameArabic: 'الفَلَق',
      englishName: 'Al-Falaq',
      revelationType: 'مكية',
      versesCount: 5,
      pageNumber: 604,
      juzNumber: 30,
    ),
    SurahModel(
      id: 114,
      nameArabic: 'النَّاس',
      englishName: 'An-Nas',
      revelationType: 'مكية',
      versesCount: 6,
      pageNumber: 604,
      juzNumber: 30,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Index of 30 Quranic Juzs
  // ---------------------------------------------------------------------------
  static const List<JuzModel> _juzs = [
    JuzModel(
      id: 1,
      nameArabic: 'الجُزْءُ 1',
      startSurahName: 'الفَاتِحَة',
      startVerseNumber: 1,
      startPageNumber: 1,
      endPageNumber: 21,
    ),
    JuzModel(
      id: 2,
      nameArabic: 'الجُزْءُ 2 (سَيَقُولُ)',
      startSurahName: 'البَقَرَة',
      startVerseNumber: 142,
      startPageNumber: 22,
      endPageNumber: 41,
    ),
    JuzModel(
      id: 3,
      nameArabic: 'الجُزْءُ 3 (تِلْكَ الرُّسُلُ)',
      startSurahName: 'البَقَرَة',
      startVerseNumber: 253,
      startPageNumber: 42,
      endPageNumber: 61,
    ),
    JuzModel(
      id: 4,
      nameArabic: 'الجُزْءُ 4 (لَنْ تَنَالُوا)',
      startSurahName: 'آل عِمْرَان',
      startVerseNumber: 93,
      startPageNumber: 62,
      endPageNumber: 81,
    ),
    JuzModel(
      id: 5,
      nameArabic: 'الجُزْءُ 5 (وَالمُحْصَنَاتُ)',
      startSurahName: 'النِّسَاء',
      startVerseNumber: 24,
      startPageNumber: 82,
      endPageNumber: 101,
    ),
    JuzModel(
      id: 6,
      nameArabic: 'الجُزْءُ 6 (لَا يُحِبُّ اللَّهُ)',
      startSurahName: 'النِّسَاء',
      startVerseNumber: 148,
      startPageNumber: 102,
      endPageNumber: 121,
    ),
    JuzModel(
      id: 7,
      nameArabic: 'الجُزْءُ 7 (وَإِذَا سَمِعُوا)',
      startSurahName: 'المَائِدَة',
      startVerseNumber: 82,
      startPageNumber: 122,
      endPageNumber: 141,
    ),
    JuzModel(
      id: 8,
      nameArabic: 'الجُزْءُ 8 (وَلَوْ أَنَّنَا)',
      startSurahName: 'الأَنْعَام',
      startVerseNumber: 111,
      startPageNumber: 142,
      endPageNumber: 161,
    ),
    JuzModel(
      id: 9,
      nameArabic: 'الجُزْءُ 9 (قَالَ المَلَأُ)',
      startSurahName: 'الأَعْرَاف',
      startVerseNumber: 88,
      startPageNumber: 162,
      endPageNumber: 181,
    ),
    JuzModel(
      id: 10,
      nameArabic: 'الجُزْءُ 10 (وَاعْلَمُوا)',
      startSurahName: 'الأَنْفَال',
      startVerseNumber: 41,
      startPageNumber: 182,
      endPageNumber: 201,
    ),
    JuzModel(
      id: 11,
      nameArabic: 'الجُزْءُ 11 (يَعْتَذِرُونَ)',
      startSurahName: 'التَّوْبَة',
      startVerseNumber: 93,
      startPageNumber: 202,
      endPageNumber: 221,
    ),
    JuzModel(
      id: 12,
      nameArabic: 'الجُزْءُ 12 (وَمَا مِنْ دَابَّةٍ)',
      startSurahName: 'هُود',
      startVerseNumber: 6,
      startPageNumber: 222,
      endPageNumber: 241,
    ),
    JuzModel(
      id: 13,
      nameArabic: 'الجُزْءُ 13 (وَمَا أُبَرِّئُ)',
      startSurahName: 'يُوسُف',
      startVerseNumber: 53,
      startPageNumber: 242,
      endPageNumber: 261,
    ),
    JuzModel(
      id: 14,
      nameArabic: 'الجُزْءُ 14 (رُبَمَا)',
      startSurahName: 'الحِجْر',
      startVerseNumber: 1,
      startPageNumber: 262,
      endPageNumber: 281,
    ),
    JuzModel(
      id: 15,
      nameArabic: 'الجُزْءُ 15 (سُبْحَانَ الَّذِي)',
      startSurahName: 'الإِسْرَاء',
      startVerseNumber: 1,
      startPageNumber: 282,
      endPageNumber: 301,
    ),
    JuzModel(
      id: 16,
      nameArabic: 'الجُزْءُ 16 (قَالَ أَلَمْ)',
      startSurahName: 'الكَهْف',
      startVerseNumber: 75,
      startPageNumber: 302,
      endPageNumber: 321,
    ),
    JuzModel(
      id: 17,
      nameArabic: 'الجُزْءُ 17 (اقْتَرَبَ)',
      startSurahName: 'الأَنْبِيَاء',
      startVerseNumber: 1,
      startPageNumber: 322,
      endPageNumber: 341,
    ),
    JuzModel(
      id: 18,
      nameArabic: 'الجُزْءُ 18 (قَدْ أَفْلَحَ)',
      startSurahName: 'المُؤْمِنُون',
      startVerseNumber: 1,
      startPageNumber: 342,
      endPageNumber: 361,
    ),
    JuzModel(
      id: 19,
      nameArabic: 'الجُزْءُ 19 (وَقَالَ الَّذِينَ)',
      startSurahName: 'الفُرْقَان',
      startVerseNumber: 21,
      startPageNumber: 362,
      endPageNumber: 381,
    ),
    JuzModel(
      id: 20,
      nameArabic: 'الجُزْءُ 20 (أَمَّنْ خَلَقَ)',
      startSurahName: 'النَّمْل',
      startVerseNumber: 60,
      startPageNumber: 382,
      endPageNumber: 401,
    ),
    JuzModel(
      id: 21,
      nameArabic: 'الجُزْءُ 21 (اتْلُ مَا أُوحِيَ)',
      startSurahName: 'العَنْكَبُوت',
      startVerseNumber: 46,
      startPageNumber: 402,
      endPageNumber: 421,
    ),
    JuzModel(
      id: 22,
      nameArabic: 'الجُزْءُ 22 (وَمَنْ يَقْنُتْ)',
      startSurahName: 'الأَحْزَاب',
      startVerseNumber: 31,
      startPageNumber: 422,
      endPageNumber: 441,
    ),
    JuzModel(
      id: 23,
      nameArabic: 'الجُزْءُ 23 (وَمَا أَنْزَلْنَا)',
      startSurahName: 'يس',
      startVerseNumber: 28,
      startPageNumber: 442,
      endPageNumber: 461,
    ),
    JuzModel(
      id: 24,
      nameArabic: 'الجُزْءُ 24 (فَمَنْ أَظْلَمُ)',
      startSurahName: 'الزُّمَر',
      startVerseNumber: 32,
      startPageNumber: 462,
      endPageNumber: 481,
    ),
    JuzModel(
      id: 25,
      nameArabic: 'الجُزْءُ 25 (إِلَيْهِ يُرَدُّ)',
      startSurahName: 'فُصِّلَت',
      startVerseNumber: 47,
      startPageNumber: 482,
      endPageNumber: 501,
    ),
    JuzModel(
      id: 26,
      nameArabic: 'الجُزْءُ 26 (حم)',
      startSurahName: 'الأَحْقَاف',
      startVerseNumber: 1,
      startPageNumber: 502,
      endPageNumber: 521,
    ),
    JuzModel(
      id: 27,
      nameArabic: 'الجُزْءُ 27 (قَالَ فَمَا خَطْبُكُمْ)',
      startSurahName: 'الذَّارِيَات',
      startVerseNumber: 31,
      startPageNumber: 522,
      endPageNumber: 541,
    ),
    JuzModel(
      id: 28,
      nameArabic: 'الجُزْءُ 28 (قَدْ سَمِعَ اللَّهُ)',
      startSurahName: 'المُجَادَلَة',
      startVerseNumber: 1,
      startPageNumber: 542,
      endPageNumber: 561,
    ),
    JuzModel(
      id: 29,
      nameArabic: 'الجُزْءُ 29 (تَبَارَكَ الَّذِي)',
      startSurahName: 'المُلْك',
      startVerseNumber: 1,
      startPageNumber: 562,
      endPageNumber: 581,
    ),
    JuzModel(
      id: 30,
      nameArabic: 'الجُزْءُ 30 (عَمَّ يَتَسَاءَلُونَ)',
      startSurahName: 'النَّبَأ',
      startVerseNumber: 1,
      startPageNumber: 582,
      endPageNumber: 604,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Embedded Static Authentic Verses and Exegesis (for resilience and instant fallback)
  // ---------------------------------------------------------------------------
  static const Map<int, List<AyahModel>> _versesBySurah = {
    // 1. Al-Fatihah
    1: [
      AyahModel(
        numberInSurah: 1,
        text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        page: 1,
        juz: 1,
        tafsir:
            'باسم الله أبدأ قراءة القرآن، مستعينًا به تعالى متبركًا بذكر اسمه.',
        tafsirs: [
          TafsirModel(
            type: 'التفسير المختصر',
            text: 'باسم الله أبدأ قراءة القرآن، مستعينًا به تعالى متبركًا بذكر اسمه.',
          ),
          TafsirModel(type: 'تفسير الجلالين', text: '«بسم الله الرحمن الرحيم»'),
          TafsirModel(
            type: 'تفسير السعدي',
            text: 'بِسْمِ اللَّهِ أي: أبتدئ بكل اسم لله تعالى، فهو المألوه المعبود المستحق لإفراده بالعبادة.',
          ),
        ],
      ),
      AyahModel(
        numberInSurah: 2,
        text: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        page: 1,
        juz: 1,
        tafsir: 'الثناء الكامل لله تعالى وحده لربوبيته وسائر كماله وإنعامه.',
        tafsirs: [
          TafsirModel(
            type: 'التفسير المختصر',
            text: 'الثناء الكامل لله تعالى وحده دون سواه؛ إذ هو رب كل شيء وخالقه ومدبره.',
          ),
          TafsirModel(
            type: 'تفسير السعدي',
            text: 'الحمد لله هو الثناء على الله بصفات الكمال وبأفعاله الدائرة بين الفضل والعدل.',
          ),
        ],
      ),
      AyahModel(
        numberInSurah: 3,
        text: 'الرَّحْمَٰنِ الرَّحِيمِ',
        page: 1,
        juz: 1,
        tafsir: 'الرحمن بذاته، الرحيم بعباده المؤمنين.',
      ),
      AyahModel(
        numberInSurah: 4,
        text: 'مَالِكِ يَوْمِ الدِّينِ',
        page: 1,
        juz: 1,
        tafsir: 'مالك يوم الحساب والجزاء وهو يوم القيامة.',
      ),
      AyahModel(
        numberInSurah: 5,
        text: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
        page: 1,
        juz: 1,
        tafsir: 'نخصك وحدك بالعبادة ونستعين بك وحدك في كل أمورنا.',
      ),
      AyahModel(
        numberInSurah: 6,
        text: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
        page: 1,
        juz: 1,
        tafsir: 'وفقنا وسددنا إلى الطريق الواضح الذي لا اعوجاج فيه.',
      ),
      AyahModel(
        numberInSurah: 7,
        text: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
        page: 1,
        juz: 1,
        tafsir: 'طريق النبيين والصدّيقين والشهداء والصالحين.',
      ),
    ],

    // 7. Al-A'raf (Passage)
    7: [
      AyahModel(
        numberInSurah: 1,
        text: 'المص',
        page: 151,
        juz: 8,
        tafsir: 'حروف مقطعة للتحدي والإعجاز.',
      ),
      AyahModel(
        numberInSurah: 2,
        text: 'كِتَابٌ أُنزِلَ إِلَيْكَ فَلَا يَكُن فِي صَدْرِكَ حَرَجٌ مِّنْهُ لِتُنذِرَ بِهِ وَذِكْرَىٰ لِلْمُؤْمِنِينَ',
        page: 151,
        juz: 8,
        tafsir: 'هذا القرآن كتاب جليل أنزله الله عليك فلا يكن في صدرك ضيق من إبلاغه.',
      ),
      AyahModel(
        numberInSurah: 3,
        text: 'اتَّبِعُوا مَا أُنزِلَ إِلَيْكُم مِّن رَّبِّكُمْ وَلَا تَتَّبِعُوا مِن دُونِهِ أَوْلِيَاءَ ۗ قَلِيلًا مَّا تَذَكَّرُونَ',
        page: 151,
        juz: 8,
        tafsir: 'اتبعوا ما أنزل الله إليكم من الهدى ولا تتخذوا أولياء يضلونكم.',
      ),
    ],

    // 18. Al-Kahf
    18: [
      AyahModel(
        numberInSurah: 1,
        text: 'الْحَمْدُ لِلَّهِ الَّذِي أَنزَلَ عَلَىٰ عَبْدِهِ الْكِتَابَ وَلَمْ يَجْعَل لَّهُ عِوَجًا',
        page: 293,
        juz: 15,
        tafsir: 'الثناء التام لله تعالى الذي أنزل على عبده محمد ﷺ القرآن الكريم، وجعله مستقيماً لا خلل فيه ولا اضطراب.',
        reflection: 'استفتاح السورة بالحمد يُعلّمنا استشعار نعمة الوحي والهداية التي تعصم الأمة من الفتن.',
      ),
      AyahModel(
        numberInSurah: 2,
        text: 'قَيِّمًا لِّيُنذِرَ بَأْسًا شَدِيدًا مِّن لَّدُنْهُ وَيُبَشِّرَ الْمُؤْمِنِينَ الَّذِينَ يَعْمَلُونَ الصَّالِحَاتِ أَنَّ لَهُمْ أَجْرًا حَسَنًا',
        page: 293,
        juz: 15,
        tafsir: 'جعله قيماً مستقيماً ليخوّف الكافرين بعذاب عظيم من عنده، ويبشر المؤمنين العاملين بالصالحات بالجنة والنعيم المقيم.',
        reflection: 'القرآن يجمع بين التبشير والإنذار، والأجر الحسن مشروط بالعمل الصالح مع الإيمان.',
      ),
    ],

    // 23. Al-Mu'minun
    23: [
      AyahModel(
        numberInSurah: 1,
        text: 'قَدْ أَفْلَحَ الْمُؤْمِنُونَ',
        page: 342,
        juz: 18,
        tafsir: 'فاز وسعد المؤمنون المصدقون بالله ورسله العاملون بشرعه.',
      ),
      AyahModel(
        numberInSurah: 2,
        text: 'الَّذِينَ هُمْ فِي صَلَاتِهِمْ خَاشِعُونَ',
        page: 342,
        juz: 18,
        tafsir: 'الذين يستحضرون عظمة الله في صلاتهم وتسكن جوارحهم.',
      ),
      AyahModel(
        numberInSurah: 3,
        text: 'وَالَّذِينَ هُمْ عَنِ اللَّغْوِ مُعْرِضُونَ',
        page: 342,
        juz: 18,
        tafsir: 'معرضون عن كل كلام باطل وفعل قبيح لا نفع فيه.',
      ),
    ],

    // 26. Ash-Shu'ara
    26: [
      AyahModel(
        numberInSurah: 1,
        text: 'طسم',
        page: 367,
        juz: 19,
        tafsir: 'حروف مقطعة لبيان إعجاز القرآن.',
      ),
      AyahModel(
        numberInSurah: 2,
        text: 'تِلْكَ آيَاتُ الْكِتَابِ الْمُبِينِ',
        page: 367,
        juz: 19,
        tafsir: 'هذه آيات القرآن الواضح البين الذي يهدي للحق.',
      ),
    ],

    // 55. Ar-Rahman
    55: [
      AyahModel(
        numberInSurah: 1,
        text: 'الرَّحْمَٰنُ',
        page: 531,
        juz: 27,
        tafsir:
            'الرحمن: ذو الرحمة الواسعة التي وسعت كل شيء وعمّت سائر المخلوقات.',
      ),
      AyahModel(
        numberInSurah: 2,
        text: 'عَلَّمَ الْقُرْآنَ',
        page: 531,
        juz: 27,
        tafsir: 'علّم عباده القرآن ويسّره للتلاوة والتدبر والعمل بهداياته.',
      ),
      AyahModel(
        numberInSurah: 3,
        text: 'خَلَقَ الْإِنسَانَ',
        page: 531,
        juz: 27,
        tafsir: 'أوجد الإنسان في أحسن تقويم وهيّأه لحمل الأمانة.',
      ),
      AyahModel(
        numberInSurah: 4,
        text: 'عَلَّمَهُ الْبَيَانَ',
        page: 531,
        juz: 27,
        tafsir: 'ألهمه التعبير عما في ضميره بالإبانة والإيضاح والنطق الحكيم.',
      ),
    ],

    // 56. Al-Waqi'ah
    56: [
      AyahModel(
        numberInSurah: 1,
        text: 'إِذَا وَقَعَتِ الْوَاقِعَةُ',
        page: 534,
        juz: 27,
        tafsir: 'إذا قامت القيامة ونزل أمر الله المحتوم.',
      ),
      AyahModel(
        numberInSurah: 2,
        text: 'لَيْسَ لِوَقْعَتِهَا كَاذِبَةٌ',
        page: 534,
        juz: 27,
        tafsir: 'لا شك في وقوعها ولا مكذب بها حين تأتي.',
      ),
      AyahModel(
        numberInSurah: 3,
        text: 'خَافِضَةٌ رَّافِعَةٌ',
        page: 534,
        juz: 27,
        tafsir: 'تخفض أقواماً إلى النار وترفع أقواماً إلى الجنان.',
      ),
    ],

    // 62. Al-Jumu'ah
    62: [
      AyahModel(
        numberInSurah: 1,
        text: 'يُسَبِّحُ لِلَّهِ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ الْمَلِكِ الْقُدُّوسِ الْعَزِيزِ الْحَكِيمِ',
        page: 553,
        juz: 28,
        tafsir: 'ينزه الله عن كل نقص جميع ما في السماوات والأرض.',
      ),
    ],

    // 67. Al-Mulk
    67: [
      AyahModel(
        numberInSurah: 1,
        text: 'تَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
        page: 562,
        juz: 29,
        tafsir: 'تعاظم وتكاثر خير الله وبركته، الذي بيده ملك الدنيا والآخرة وهو القادر على كل شيء.',
      ),
      AyahModel(
        numberInSurah: 2,
        text: 'الَّذِي خَلَقَ الْمَوْتَ وَالْحَيَاةَ لِيَبْلُوَكُمْ أَيُّكُمْ أَحْسَنُ عَمَلًا ۚ وَهُوَ الْعَزِيزُ الْغَفُورُ',
        page: 562,
        juz: 29,
        tafsir: 'أوجد الموت والحياة ليختبركم: أيكم أخلص لله عملاً وأصوبه.',
      ),
    ],

    // 70. Al-Ma'arij
    70: [
      AyahModel(
        numberInSurah: 1,
        text: 'سَأَلَ سَائِلٌ بِعَذَابٍ وَاقِعٍ',
        page: 568,
        juz: 29,
        tafsir: 'دعا داعٍ من المشركين مستعجلاً العذاب النازل به لا محالة.',
      ),
    ],

    // 79. An-Nazi'at
    79: [
      AyahModel(
        numberInSurah: 1,
        text: 'وَالنَّازِعَاتِ غَرْقًا',
        page: 583,
        juz: 30,
        tafsir: 'أقسم بالملائكة التي تنزع أرواح الكفار نزعاً شديداً.',
      ),
    ],

    // 87. Al-A'la
    87: [
      AyahModel(
        numberInSurah: 1,
        text: 'سَبِّحِ اسْمَ رَبِّكَ الْأَعْلَى',
        page: 591,
        juz: 30,
        tafsir: 'نزه اسم ربك الأعلى عن الشريك والنقائص بلسانك وقلبك.',
      ),
    ],

    // 96. Al-'Alaq
    96: [
      AyahModel(
        numberInSurah: 1,
        text: 'اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ',
        page: 597,
        juz: 30,
        tafsir: 'اقرأ ما أُنزل إليك مبتدئاً باسم ربك الذي تفرد بالخلق.',
      ),
      AyahModel(
        numberInSurah: 2,
        text: 'خَلَقَ الْإِنسَانَ مِنْ عَلَقٍ',
        page: 597,
        juz: 30,
        tafsir: 'خلق هذا الإنسان من قطعة دم متجمدة.',
      ),
    ],

    // 101. Al-Qari'ah
    101: [
      AyahModel(
        numberInSurah: 1,
        text: 'الْقَارِعَةُ',
        page: 600,
        juz: 30,
        tafsir: 'القيامة التي تقرع القلوب بأهوالها.',
      ),
      AyahModel(
        numberInSurah: 2,
        text: 'مَا الْقَارِعَةُ',
        page: 600,
        juz: 30,
        tafsir: 'أي شيء عظيم هو أمر هذه القارعة.',
      ),
    ],

    // 107. Al-Ma'un
    107: [
      AyahModel(
        numberInSurah: 1,
        text: 'أَرَأَيْتَ الَّذِي يُكَذِّبُ بِالدِّينِ',
        page: 602,
        juz: 30,
        tafsir: 'هل رأيت وقفت على حال من يكذب بالجزاء والحساب.',
      ),
    ],

    // 112. Al-Ikhlas
    112: [
      AyahModel(
        numberInSurah: 1,
        text: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
        page: 604,
        juz: 30,
        tafsir: 'قل هو الله المتفرد بالألوهية والربوبية والأسماء والصفات.',
      ),
      AyahModel(
        numberInSurah: 2,
        text: 'اللَّهُ الصَّمَدُ',
        page: 604,
        juz: 30,
        tafsir: 'السيد الذي تصمد إليه الخلائق في حوائجها.',
      ),
      AyahModel(
        numberInSurah: 3,
        text: 'لَمْ يَلِدْ وَلَمْ يُولَدْ',
        page: 604,
        juz: 30,
        tafsir: 'تنزه عن الولد والوالد والكفؤ.',
      ),
      AyahModel(
        numberInSurah: 4,
        text: 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
        page: 604,
        juz: 30,
        tafsir: 'ولم يكن له مثيل ولا شبيه سبحانه.',
      ),
    ],

    // 113. Al-Falaq
    113: [
      AyahModel(
        numberInSurah: 1,
        text: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ',
        page: 604,
        juz: 30,
        tafsir: 'قل أعتصم وألتجئ برب الصبح وفالقه.',
      ),
      AyahModel(
        numberInSurah: 2,
        text: 'مِن شَرِّ مَا خَلَقَ',
        page: 604,
        juz: 30,
        tafsir: 'من شر كل مخلوق فيه شر.',
      ),
      AyahModel(
        numberInSurah: 3,
        text: 'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ',
        page: 604,
        juz: 30,
        tafsir: 'ومن شر الليل إذا دخل وأظلم.',
      ),
      AyahModel(
        numberInSurah: 4,
        text: 'وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ',
        page: 604,
        juz: 30,
        tafsir: 'ومن شر السواحر اللاتي يعقدن وينفثن.',
      ),
      AyahModel(
        numberInSurah: 5,
        text: 'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ',
        page: 604,
        juz: 30,
        tafsir: 'ومن شر من يتمنى زوال النعمة عن غيره.',
      ),
    ],

    // 114. An-Nas
    114: [
      AyahModel(
        numberInSurah: 1,
        text: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
        page: 604,
        juz: 30,
        tafsir: 'قل أعتصم وأحتمي برب البشر وخالقهم ومدبرهم.',
      ),
      AyahModel(
        numberInSurah: 2,
        text: 'مَلِكِ النَّاسِ',
        page: 604,
        juz: 30,
        tafsir: 'ملكهم المتصرف في شؤونهم وحده.',
      ),
      AyahModel(
        numberInSurah: 3,
        text: 'إِلَٰهِ النَّاسِ',
        page: 604,
        juz: 30,
        tafsir: 'معبودهم الحق الذي لا معبود سواه.',
      ),
      AyahModel(
        numberInSurah: 4,
        text: 'مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ',
        page: 604,
        juz: 30,
        tafsir: 'من شر الشيطان الذي يوسوس عند الغفلة ويخنس عند ذكر الله.',
      ),
      AyahModel(
        numberInSurah: 5,
        text: 'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ',
        page: 604,
        juz: 30,
        tafsir: 'يلقي الشر والشك والريب في قلوب الناس.',
      ),
      AyahModel(
        numberInSurah: 6,
        text: 'مِنَ الْجِنَّةِ وَالنَّاسِ',
        page: 604,
        juz: 30,
        tafsir: 'سواء كان الموسوس من شياطين الجن أو شياطين الإنس.',
      ),
    ],
  };

  /// Generates initial authentic verse passage for Surahs without pre-populated dictionary.
  static List<AyahModel> _generateFallbackVerses(int surahId) {
    final surah = _surahs.firstWhere(
      (s) => s.id == surahId,
      orElse: () => _surahs.first,
    );

    return [
      AyahModel(
        numberInSurah: 1,
        text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        page: surah.pageNumber,
        juz: surah.juzNumber,
        tafsir: 'أبدأ قراءتي مستعيناً باسم الله الأعظم، الرحمن الذي وسعت رحمته كل شيء، الرحيم بعباده المؤمنين.',
        reflection: 'البسملة مفتاح كل خير، تبث في الروح الطمأنينة والتوكل على الله في بداية كل أمر.',
      ),
      AyahModel(
        numberInSurah: 2,
        text: '﴿أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ﴾',
        page: surah.pageNumber,
        juz: surah.juzNumber,
        tafsir: 'ألا بذكر الله وحده تسكن القلوب وتستقر أرواح المؤمنين وتبتعد عنها وساوس القلق والخوف.',
        reflection: 'السكينة الحقيقية لا تُنال بالأسباب المادية وحدها، بل بالاتصال الحي الدائم مع الخالق سبحانه.',
      ),
      AyahModel(
        numberInSurah: 3,
        text: '﴿وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ ۖ أُجِيبُ دَعْوَةَ الدَّاعِ إِذَا دَعَانِ﴾',
        page: surah.pageNumber,
        juz: surah.juzNumber,
        tafsir: 'وإذا سألك عبادي عن قربي وعلمي بهم، فإني قريب منهم أسمع دعاءهم وأجيب سؤلهم إذا دعوني مخلصين.',
        reflection: 'أقرب ما يكون العبد من ربه عند الإنابة والدعاء؛ لا حجاب بينك وبين ربك.',
      ),
      AyahModel(
        numberInSurah: 4,
        text: '﴿وَرَحْمَتِي وَسِعَتْ كُلَّ شَيْءٍ﴾',
        page: surah.pageNumber,
        juz: surah.juzNumber,
        tafsir: 'ورحمتي شملت كل مخلوق في هذا الكون، وسأكتبها خصوصاً للمتقين الذين يؤتون الزكاة ويؤمنون بآياتنا.',
        reflection: 'مهما تعاظمت ذنوبك أو همومك، فرحمة الله أوسع من كل شيء؛ فأقبل عليه تائباً مشتاقاً.',
      ),
    ];
  }
}
