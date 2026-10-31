import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';

/// Data Transfer Object representing a Quranic Ayah with JSON serialization.
class AyahModel extends AyahEntity {
  const AyahModel({
    required super.numberInSurah,
    required super.text,
    required super.page,
    required super.juz,
    super.isSajdah,
    super.tafsir,
    super.reflection,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      numberInSurah: json['number_in_surah'] as int,
      text: json['text'] as String,
      page: json['page'] as int,
      juz: json['juz'] as int,
      isSajdah: json['is_sajdah'] as bool? ?? false,
      tafsir: json['tafsir'] as String?,
      reflection: json['reflection'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'number_in_surah': numberInSurah,
        'text': text,
        'page': page,
        'juz': juz,
        'is_sajdah': isSajdah,
        'tafsir': tafsir,
        'reflection': reflection,
      };

  AyahEntity toEntity() => AyahEntity(
        numberInSurah: numberInSurah,
        text: text,
        page: page,
        juz: juz,
        isSajdah: isSajdah,
        tafsir: tafsir,
        reflection: reflection,
      );
}

