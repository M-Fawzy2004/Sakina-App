import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sakina_app/features/sunnah_books/data/models/hadith_model.dart';
import 'package:sakina_app/features/sunnah_books/data/models/sunnah_book_model.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_page_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';

abstract interface class SunnahLocalDataSource {
  Future<List<SunnahBookEntity>> loadCatalog();
  Future<HadithPageEntity> getBookHadiths({
    required String bookKey,
    int? chapterId,
    required int page,
    required int pageSize,
  });
  Future<HadithPageEntity> searchHadiths({
    required String bookKey,
    required String query,
    required int page,
    required int pageSize,
  });
  void preWarmBook(String bookKey);
}

class SunnahLocalDataSourceImpl implements SunnahLocalDataSource {
  static const String _kCatalogPath = 'assets/sunnah_books/sunnah_catalog.json';
  static const String _kPreviewsPath = 'assets/sunnah_books/sunnah_previews.json';
  static const String _kBooksGzPrefix = 'assets/sunnah_books/';

  List<SunnahBookEntity>? _cachedCatalog;
  Map<String, List<HadithEntity>>? _cachedPreviews;
  final Map<String, List<HadithEntity>> _cachedHadithsPerBook = {};
  final Map<String, Future<List<HadithEntity>>> _loadingFutures = {};

  @override
  Future<List<SunnahBookEntity>> loadCatalog() async {
    if (_cachedCatalog != null) {
      return _cachedCatalog!;
    }

    final jsonString = await rootBundle.loadString(_kCatalogPath);
    final dynamic decoded = json.decode(jsonString);

    if (decoded is Map<String, dynamic>) {
      final booksRaw = decoded['books'] as List? ?? [];
      final books = booksRaw
          .whereType<Map<String, dynamic>>()
          .map((b) => SunnahBookModel.fromJson(b))
          .toList();

      _cachedCatalog = List.unmodifiable(books);
      unawaited(_loadPreviewsIfNeeded());
      preWarmBook('bukhari');
      preWarmBook('muslim');
      return _cachedCatalog!;
    }

    return [];
  }

  @override
  void preWarmBook(String bookKey) {
    unawaited(_ensureBookLoaded(bookKey));
  }

  @override
  Future<HadithPageEntity> getBookHadiths({
    required String bookKey,
    int? chapterId,
    required int page,
    required int pageSize,
  }) async {
    // 1. If full book is already decoded in memory, use it
    final cached = _cachedHadithsPerBook[bookKey];
    if (cached != null) {
      List<HadithEntity> filtered = cached;
      if (chapterId != null && chapterId > 0) {
        filtered = cached.where((h) => h.chapterId == chapterId).toList();
      }
      return _paginate(items: filtered, page: page, pageSize: pageSize);
    }

    // 2. If page 1 and no specific chapter, return preview immediately (0ms)
    if (page == 1 && (chapterId == null || chapterId <= 0)) {
      await _loadPreviewsIfNeeded();
      final preview = _cachedPreviews?[bookKey];
      if (preview != null && preview.isNotEmpty) {
        unawaited(_ensureBookLoaded(bookKey));
        if (_cachedCatalog == null) {
          await loadCatalog();
        }
        final bookMeta = _cachedCatalog?.where((b) => b.key == bookKey).firstOrNull;
        return _paginate(
          items: preview,
          page: page,
          pageSize: pageSize,
          overrideTotalCount: bookMeta?.hadithsCount,
        );
      }
    }

    // 3. Otherwise wait for full book decode
    final allHadiths = await _ensureBookLoaded(bookKey);
    List<HadithEntity> filtered = allHadiths;
    if (chapterId != null && chapterId > 0) {
      filtered = allHadiths.where((h) => h.chapterId == chapterId).toList();
    }

    return _paginate(
      items: filtered,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<HadithPageEntity> searchHadiths({
    required String bookKey,
    required String query,
    required int page,
    required int pageSize,
  }) async {
    final allHadiths = await _ensureBookLoaded(bookKey);
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return _paginate(items: allHadiths, page: page, pageSize: pageSize);
    }

    final normalizedQuery = _normalizeArabic(trimmed.toLowerCase());

    final matching = allHadiths.where((h) {
      final normArabic = _normalizeArabic(h.arabic.toLowerCase());
      return normArabic.contains(normalizedQuery);
    }).toList();

    return _paginate(
      items: matching,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<void> _loadPreviewsIfNeeded() async {
    if (_cachedPreviews != null) return;
    try {
      final jsonString = await rootBundle.loadString(_kPreviewsPath);
      final dynamic decoded = json.decode(jsonString);
      if (decoded is Map<String, dynamic>) {
        final Map<String, List<HadithEntity>> map = {};
        for (final entry in decoded.entries) {
          if (entry.value is List) {
            map[entry.key] = (entry.value as List)
                .whereType<Map<String, dynamic>>()
                .map((h) => HadithModel.fromJson(h))
                .toList();
          }
        }
        _cachedPreviews = map;
      }
    } catch (_) {
      _cachedPreviews = {};
    }
  }

  Future<List<HadithEntity>> _ensureBookLoaded(String bookKey) {
    final existing = _cachedHadithsPerBook[bookKey];
    if (existing != null) {
      return Future.value(existing);
    }

    final inProgress = _loadingFutures[bookKey];
    if (inProgress != null) {
      return inProgress;
    }

    final future = _loadBookFromAsset(bookKey);
    _loadingFutures[bookKey] = future;
    return future;
  }

  Future<List<HadithEntity>> _loadBookFromAsset(String bookKey) async {
    try {
      final assetPath = '$_kBooksGzPrefix$bookKey.json.gz';
      final byteData = await rootBundle.load(assetPath);
      final gzBytes = byteData.buffer.asUint8List();

      final List<HadithEntity> hadiths = await compute(_decodeGzHadiths, gzBytes);
      _cachedHadithsPerBook[bookKey] = List.unmodifiable(hadiths);
      return _cachedHadithsPerBook[bookKey]!;
    } finally {
      _loadingFutures.remove(bookKey);
    }
  }

  HadithPageEntity _paginate({
    required List<HadithEntity> items,
    required int page,
    required int pageSize,
    int? overrideTotalCount,
  }) {
    final totalCount = overrideTotalCount ?? items.length;
    final startIndex = (page - 1) * pageSize;

    if (startIndex >= items.length) {
      return HadithPageEntity(
        hadiths: const [],
        page: page,
        pageSize: pageSize,
        totalCount: totalCount,
        hasMore: false,
      );
    }

    final endIndex = min(startIndex + pageSize, items.length);
    final pageHadiths = items.sublist(startIndex, endIndex);
    final hasMore = endIndex < totalCount;

    return HadithPageEntity(
      hadiths: pageHadiths,
      page: page,
      pageSize: pageSize,
      totalCount: totalCount,
      hasMore: hasMore,
    );
  }

  static String _normalizeArabic(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u0640]'), '')
        .replaceAll(RegExp(r'[إأآا]'), 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي');
  }
}

/// Standalone top-level isolate decoder function for compute()
List<HadithEntity> _decodeGzHadiths(Uint8List gzBytes) {
  final decompressed = gzip.decode(gzBytes);
  final jsonString = utf8.decode(decompressed);
  final dynamic decoded = json.decode(jsonString);

  if (decoded is! Map<String, dynamic>) {
    return [];
  }

  final hadithsRaw = decoded['hadiths'] as List? ?? [];
  return hadithsRaw
      .whereType<Map<String, dynamic>>()
      .map((h) => HadithModel.fromJson(h))
      .toList();
}
