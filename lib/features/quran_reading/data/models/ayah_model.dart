import 'package:sakina_app/features/quran_reading/data/models/tafsir_model.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';

/// Data Transfer Object representing a Quranic Ayah with JSON serialization and multi-script support.
class AyahModel extends AyahEntity {
  const AyahModel({
    required super.numberInSurah,
    required super.text,
    super.textUthmani,
    super.textImlaei,
    super.textIndoPak,
    required super.page,
    required super.juz,
    super.isSajdah,
    super.tafsir,
    super.reflection,
    super.tafsirs = const [],
  });

  /// Parses an Ayah directly from offline Surah JSON file packaged in assets/quran_data/*.json.
  factory AyahModel.fromLocalJson(
    Map<String, dynamic> json, {
    required int defaultPage,
    required int defaultJuz,
  }) {
    final ayahNumber = (json['ayah_number'] as num?)?.toInt() ??
        (json['number_in_surah'] as num?)?.toInt() ??
        (json['verse_number'] as num?)?.toInt() ??
        1;
    final text = json['text'] as String? ?? json['text_uthmani'] as String? ?? '';
    final rawTafsir = json['tafsir'];
    final List<TafsirModel> parsedTafsirs = [];
    String? firstTafsirText;

    if (rawTafsir is List) {
      for (final item in rawTafsir) {
        if (item is Map<String, dynamic>) {
          final t = TafsirModel.fromJson(item);
          parsedTafsirs.add(t);
          if (firstTafsirText == null || t.type == 'التفسير المختصر') {
            firstTafsirText = t.text;
          }
        }
      }
    } else if (rawTafsir is String && rawTafsir.trim().isNotEmpty) {
      firstTafsirText = rawTafsir;
      parsedTafsirs.add(TafsirModel(type: 'التفسير المختصر', text: rawTafsir));
    }

    final page = (json['page'] as num?)?.toInt() ??
        (json['page_number'] as num?)?.toInt() ??
        defaultPage;
    final juz = (json['juz'] as num?)?.toInt() ??
        (json['juz_number'] as num?)?.toInt() ??
        defaultJuz;

    return AyahModel(
      numberInSurah: ayahNumber,
      text: text,
      textUthmani: text,
      page: page,
      juz: juz,
      isSajdah: json['is_sajdah'] as bool? ?? false,
      tafsir: firstTafsirText,
      reflection: json['reflection'] as String?,
      tafsirs: parsedTafsirs,
    );
  }

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    final text = json['text'] as String? ?? json['text_uthmani'] as String? ?? '';
    final rawTafsir = json['tafsir'];
    final List<TafsirModel> parsedTafsirs = [];
    String? firstTafsirText;

    if (rawTafsir is List) {
      for (final item in rawTafsir) {
        if (item is Map<String, dynamic>) {
          parsedTafsirs.add(TafsirModel.fromJson(item));
        }
      }
      if (parsedTafsirs.isNotEmpty) {
        firstTafsirText = parsedTafsirs.first.text;
      }
    } else if (rawTafsir is String) {
      firstTafsirText = rawTafsir;
      parsedTafsirs.add(TafsirModel(type: 'التفسير المختصر', text: rawTafsir));
    }

    return AyahModel(
      numberInSurah: json['number_in_surah'] as int? ?? json['verse_number'] as int? ?? 1,
      text: text,
      textUthmani: json['text_uthmani'] as String?,
      textImlaei: json['text_imlaei'] as String?,
      textIndoPak: json['text_indopak'] as String?,
      page: json['page'] as int? ?? json['page_number'] as int? ?? 1,
      juz: json['juz'] as int? ?? json['juz_number'] as int? ?? 1,
      isSajdah: json['is_sajdah'] as bool? ?? false,
      tafsir: firstTafsirText,
      reflection: json['reflection'] as String?,
      tafsirs: parsedTafsirs,
    );
  }

  Map<String, dynamic> toJson() => {
        'number_in_surah': numberInSurah,
        'text': text,
        'text_uthmani': textUthmani,
        'text_imlaei': textImlaei,
        'text_indopak': textIndoPak,
        'page': page,
        'juz': juz,
        'is_sajdah': isSajdah,
        'tafsir': tafsir,
        'reflection': reflection,
        'tafsirs': tafsirs.map((t) => {'type': t.type, 'text': t.text}).toList(),
      };

  AyahEntity toEntity() => AyahEntity(
        numberInSurah: numberInSurah,
        text: text,
        textUthmani: textUthmani,
        textImlaei: textImlaei,
        textIndoPak: textIndoPak,
        page: page,
        juz: juz,
        isSajdah: isSajdah,
        tafsir: tafsir,
        reflection: reflection,
        tafsirs: tafsirs,
      );
}
