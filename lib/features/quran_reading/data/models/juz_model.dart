import 'package:sakina_app/features/quran_reading/domain/entities/juz_entity.dart';

/// Data Transfer Object representing a Quranic Juz with JSON serialization.
class JuzModel extends JuzEntity {
  const JuzModel({
    required super.id,
    required super.nameArabic,
    required super.startSurahName,
    required super.startVerseNumber,
    required super.startPageNumber,
    required super.endPageNumber,
  });

  factory JuzModel.fromJson(Map<String, dynamic> json) {
    return JuzModel(
      id: json['id'] as int,
      nameArabic: json['name_arabic'] as String,
      startSurahName: json['start_surah_name'] as String,
      startVerseNumber: json['start_verse_number'] as int,
      startPageNumber: json['start_page_number'] as int,
      endPageNumber: json['end_page_number'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_arabic': nameArabic,
        'start_surah_name': startSurahName,
        'start_verse_number': startVerseNumber,
        'start_page_number': startPageNumber,
        'end_page_number': endPageNumber,
      };

  JuzEntity toEntity() => JuzEntity(
        id: id,
        nameArabic: nameArabic,
        startSurahName: startSurahName,
        startVerseNumber: startVerseNumber,
        startPageNumber: startPageNumber,
        endPageNumber: endPageNumber,
      );
}

