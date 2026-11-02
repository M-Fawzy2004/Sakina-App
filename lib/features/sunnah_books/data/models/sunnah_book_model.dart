import 'package:sakina_app/features/sunnah_books/data/models/sunnah_chapter_model.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';

class SunnahBookModel extends SunnahBookEntity {
  const SunnahBookModel({
    required super.id,
    required super.key,
    required super.titleAr,
    required super.titleEn,
    required super.authorAr,
    required super.authorEn,
    required super.introductionAr,
    required super.hadithsCount,
    required super.chaptersCount,
    required super.chapters,
  });

  factory SunnahBookModel.fromJson(Map<String, dynamic> json) {
    final rawChapters = json['chapters'] as List? ?? [];
    final chapters = rawChapters
        .whereType<Map<String, dynamic>>()
        .map((c) => SunnahChapterModel.fromJson(c))
        .toList();

    return SunnahBookModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      key: (json['key'] as String? ?? '').trim(),
      titleAr: (json['titleAr'] as String? ?? '').trim(),
      titleEn: (json['titleEn'] as String? ?? '').trim(),
      authorAr: (json['authorAr'] as String? ?? '').trim(),
      authorEn: (json['authorEn'] as String? ?? '').trim(),
      introductionAr: (json['introductionAr'] as String? ?? '').trim(),
      hadithsCount: (json['hadithsCount'] as num?)?.toInt() ?? 0,
      chaptersCount: (json['chaptersCount'] as num?)?.toInt() ?? chapters.length,
      chapters: List.unmodifiable(chapters),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'authorAr': authorAr,
      'authorEn': authorEn,
      'introductionAr': introductionAr,
      'hadithsCount': hadithsCount,
      'chaptersCount': chaptersCount,
      'chapters': chapters.map((c) => (c as SunnahChapterModel).toJson()).toList(),
    };
  }
}

