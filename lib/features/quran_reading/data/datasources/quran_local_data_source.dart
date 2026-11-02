import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/static/quran_fallback_verses_seed_data.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/static/quran_juzs_seed_data.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/static/quran_surahs_seed_data.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/static/surah_file_map.dart';
import 'package:sakina_app/features/quran_reading/data/models/ayah_model.dart';
import 'package:sakina_app/features/quran_reading/data/models/juz_model.dart';
import 'package:sakina_app/features/quran_reading/data/models/quran_bookmark_model.dart';
import 'package:sakina_app/features/quran_reading/data/models/surah_model.dart';

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

  static List<SurahModel> get allSurahs => kDefaultSurahsList;

  @override
  Future<List<SurahModel>> getSurahs() async {
    _preCacheSurah(1);
    _preCacheSurah(2);
    _preCacheSurah(18);
    return kDefaultSurahsList;
  }

  @override
  Future<List<JuzModel>> getJuzs() async {
    return kDefaultJuzsList;
  }

  @override
  Future<List<AyahModel>> getSurahVerses(int surahId) async {
    // 1. Check in-memory cache (instantaneous 0ms access)
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

        final surah = kDefaultSurahsList.firstWhere(
          (s) => s.id == surahId,
          orElse: () => kDefaultSurahsList.first,
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
    final fallbackVerses = kFallbackVersesBySurah[surahId] ??
        generateDefaultFallbackVerses(
          kDefaultSurahsList.firstWhere(
            (s) => s.id == surahId,
            orElse: () => kDefaultSurahsList.first,
          ),
        );
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
    final knownFileName = kSurahFileMap[surahId];
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
}
