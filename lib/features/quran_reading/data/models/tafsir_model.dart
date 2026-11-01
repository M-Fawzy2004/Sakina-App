import 'package:sakina_app/features/quran_reading/domain/entities/tafsir_entity.dart';

/// Data Transfer Object representing a Tafsir (Exegesis) entry from local JSON.
class TafsirModel extends TafsirEntity {
  const TafsirModel({
    required super.type,
    required super.text,
  });

  factory TafsirModel.fromJson(Map<String, dynamic> json) {
    return TafsirModel(
      type: json['type'] as String? ?? 'التفسير المختصر',
      text: json['text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'text': text,
      };

  TafsirEntity toEntity() => TafsirEntity(
        type: type,
        text: text,
      );
}

