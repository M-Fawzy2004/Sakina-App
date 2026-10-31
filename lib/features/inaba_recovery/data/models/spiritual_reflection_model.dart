import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_reflection_entity.dart';

class SpiritualReflectionModel extends SpiritualReflectionEntity {
  const SpiritualReflectionModel({
    required super.id,
    required super.title,
    required super.content,
    required super.createdAt,
    required super.moodTag,
  });

  factory SpiritualReflectionModel.fromJson(Map<String, dynamic> json) {
    return SpiritualReflectionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      moodTag: json['mood_tag'] as String? ?? 'ندم ورجاء',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'mood_tag': moodTag,
    };
  }

  factory SpiritualReflectionModel.fromEntity(SpiritualReflectionEntity entity) {
    return SpiritualReflectionModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      createdAt: entity.createdAt,
      moodTag: entity.moodTag,
    );
  }
}

