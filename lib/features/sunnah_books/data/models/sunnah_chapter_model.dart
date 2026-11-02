import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_chapter_entity.dart';

class SunnahChapterModel extends SunnahChapterEntity {
  const SunnahChapterModel({
    required super.id,
    required super.bookId,
    required super.arabic,
    required super.english,
  });

  factory SunnahChapterModel.fromJson(Map<String, dynamic> json) {
    return SunnahChapterModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      bookId: (json['bookId'] as num?)?.toInt() ?? 0,
      arabic: (json['arabic'] as String? ?? '').trim(),
      english: (json['english'] as String? ?? '').trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'arabic': arabic,
      'english': english,
    };
  }
}

