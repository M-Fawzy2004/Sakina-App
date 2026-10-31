import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';

/// Data Transfer Object representing a Quran reading bookmark with JSON serialization.
class QuranBookmarkModel extends QuranBookmarkEntity {
  const QuranBookmarkModel({
    required super.surahId,
    required super.surahName,
    required super.ayahNumber,
    required super.pageNumber,
    required super.timestamp,
  });

  factory QuranBookmarkModel.fromJson(Map<String, dynamic> json) {
    return QuranBookmarkModel(
      surahId: json['surah_id'] as int,
      surahName: json['surah_name'] as String,
      ayahNumber: json['ayah_number'] as int,
      pageNumber: json['page_number'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'surah_id': surahId,
        'surah_name': surahName,
        'ayah_number': ayahNumber,
        'page_number': pageNumber,
        'timestamp': timestamp.toIso8601String(),
      };

  QuranBookmarkEntity toEntity() => QuranBookmarkEntity(
        surahId: surahId,
        surahName: surahName,
        ayahNumber: ayahNumber,
        pageNumber: pageNumber,
        timestamp: timestamp,
      );
}

