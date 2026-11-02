import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sakina_app/features/hisn_muslim/data/datasources/static/hisn_arabic_titles_map.dart';
import 'package:sakina_app/features/hisn_muslim/data/models/hisn_dua_model.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_chapter_entity.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_dua_entity.dart';

abstract interface class HisnLocalDataSource {
  Future<List<HisnChapterEntity>> loadChapters();
  Future<HisnChapterEntity> getChapterById(int id);
  Future<List<HisnDuaEntity>> searchDuas(String query);
}

class HisnLocalDataSourceImpl implements HisnLocalDataSource {
  static const String _kHisnJsonPath = 'assets/azkar/hisnulmuslim.json';
  List<HisnChapterEntity>? _cachedChapters;

  @override
  Future<List<HisnChapterEntity>> loadChapters() async {
    if (_cachedChapters != null) {
      return _cachedChapters!;
    }

    final jsonString = await rootBundle.loadString(_kHisnJsonPath);
    final dynamic decoded = json.decode(jsonString);

    if (decoded is! List) {
      _cachedChapters = [];
      return [];
    }

    final Map<String, List<HisnDuaEntity>> grouped = {};
    int duaCounter = 1;

    for (final rawItem in decoded) {
      if (rawItem is! Map<String, dynamic>) continue;
      final title = (rawItem['title'] as String? ?? '').trim();
      final meta = HisnArabicTitlesMap.getMeta(title);

      final currentList = grouped.putIfAbsent(title, () => []);
      final chapterId = grouped.keys.length;

      final dua = HisnDuaModel.fromJson(
        rawItem,
        id: duaCounter++,
        chapterId: chapterId,
        chapterTitleAr: meta.titleAr,
      );
      currentList.add(dua);
    }

    final List<HisnChapterEntity> chapters = [];
    int chapterIndex = 1;

    for (final entry in grouped.entries) {
      final rawTitle = entry.key;
      final items = entry.value;
      final meta = HisnArabicTitlesMap.getMeta(rawTitle);

      chapters.add(
        HisnChapterEntity(
          id: chapterIndex++,
          title: rawTitle,
          titleAr: meta.titleAr,
          category: meta.category,
          items: List.unmodifiable(items),
        ),
      );
    }

    _cachedChapters = List.unmodifiable(chapters);
    return _cachedChapters!;
  }

  @override
  Future<HisnChapterEntity> getChapterById(int id) async {
    final chapters = await loadChapters();
    return chapters.firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception('Chapter with ID $id not found in Hisn al-Muslim'),
    );
  }

  @override
  Future<List<HisnDuaEntity>> searchDuas(String query) async {
    final chapters = await loadChapters();
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return [];

    final normalizedQuery = _normalizeArabic(trimmed);
    final List<HisnDuaEntity> results = [];

    for (final chapter in chapters) {
      final normTitleAr = _normalizeArabic(chapter.titleAr.toLowerCase());
      final normTitleEn = chapter.title.toLowerCase();
      final titleMatches = normTitleAr.contains(normalizedQuery) || normTitleEn.contains(trimmed);

      for (final dua in chapter.items) {
        if (titleMatches) {
          results.add(dua);
          continue;
        }

        final normArabic = _normalizeArabic(dua.arabic.toLowerCase());
        final normEnglish = dua.english.toLowerCase();

        if (normArabic.contains(normalizedQuery) || normEnglish.contains(trimmed)) {
          results.add(dua);
        }
      }
    }

    return results;
  }

  String _normalizeArabic(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u0640]'), '') // Remove tashkeel/harakat and tatweel
        .replaceAll(RegExp(r'[إأآا]'), 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي');
  }
}
