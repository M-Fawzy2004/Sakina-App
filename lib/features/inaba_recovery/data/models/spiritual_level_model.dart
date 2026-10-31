import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_level_entity.dart';

class SpiritualLevelModel extends SpiritualLevelEntity {
  const SpiritualLevelModel({
    required super.levelIndex,
    required super.title,
    required super.minDays,
    required super.maxDays,
    required super.description,
    required super.isUnlocked,
    required super.isCurrent,
  });

  factory SpiritualLevelModel.fromJson(Map<String, dynamic> json) {
    return SpiritualLevelModel(
      levelIndex: json['level_index'] as int,
      title: json['title'] as String,
      minDays: json['min_days'] as int,
      maxDays: json['max_days'] as int,
      description: json['description'] as String,
      isUnlocked: json['is_unlocked'] as bool? ?? false,
      isCurrent: json['is_current'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level_index': levelIndex,
      'title': title,
      'min_days': minDays,
      'max_days': maxDays,
      'description': description,
      'is_unlocked': isUnlocked,
      'is_current': isCurrent,
    };
  }
}

