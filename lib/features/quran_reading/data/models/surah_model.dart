import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

/// Data Transfer Object representing a Quranic Surah with JSON serialization.
class SurahModel extends SurahEntity {
  const SurahModel({
    required super.id,
    required super.nameArabic,
    required super.englishName,
    required super.revelationType,
    required super.versesCount,
    required super.pageNumber,
    required super.juzNumber,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'] as int,
      nameArabic: json['name_arabic'] as String,
      englishName: json['english_name'] as String,
      revelationType: json['revelation_type'] as String,
      versesCount: json['verses_count'] as int,
      pageNumber: json['page_number'] as int,
      juzNumber: json['juz_number'] as int,
    );
  }

  /// Parses chapter directly from Quran Foundation / Quran.com API v4 response.
  factory SurahModel.fromQuranFoundationJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final nameArabic = (json['name_arabic'] as String?)?.trim() ?? '';
    final englishName = (json['name_simple'] as String?) ??
        (json['name_complex'] as String?) ??
        'Surah $id';
    final place = (json['revelation_place'] as String?)?.toLowerCase();
    final revelationType = (place == 'makkah' || place == 'meccan') ? 'مكية' : 'مدنية';
    final versesCount = (json['verses_count'] as num?)?.toInt() ?? 0;
    final pagesList = json['pages'] as List<dynamic>?;
    final pageNumber = (pagesList != null && pagesList.isNotEmpty)
        ? (pagesList.first as num).toInt()
        : (json['page_number'] as num?)?.toInt() ?? 1;
    // Approximating juz number from page if not provided
    final juzNumber = (json['juz_number'] as num?)?.toInt() ??
        ((pageNumber - 1) ~/ 20 + 1).clamp(1, 30);

    return SurahModel(
      id: id,
      nameArabic: nameArabic,
      englishName: englishName,
      revelationType: revelationType,
      versesCount: versesCount,
      pageNumber: pageNumber,
      juzNumber: juzNumber,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_arabic': nameArabic,
        'english_name': englishName,
        'revelation_type': revelationType,
        'verses_count': versesCount,
        'page_number': pageNumber,
        'juz_number': juzNumber,
      };

  SurahEntity toEntity() => SurahEntity(
        id: id,
        nameArabic: nameArabic,
        englishName: englishName,
        revelationType: revelationType,
        versesCount: versesCount,
        pageNumber: pageNumber,
        juzNumber: juzNumber,
      );
}

