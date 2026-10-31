import 'package:sakina_app/features/inaba_recovery/domain/entities/good_deed_entity.dart';

class GoodDeedModel extends GoodDeedEntity {
  const GoodDeedModel({
    required super.id,
    required super.title,
    required super.category,
    required super.rewardDescription,
    required super.completionCount,
    required super.isCompletedToday,
    required super.iconKey,
  });

  factory GoodDeedModel.fromJson(Map<String, dynamic> json) {
    return GoodDeedModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      rewardDescription: json['reward_description'] as String,
      completionCount: json['completion_count'] as int? ?? 0,
      isCompletedToday: json['is_completed_today'] as bool? ?? false,
      iconKey: json['icon_key'] as String? ?? 'heart',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'reward_description': rewardDescription,
      'completion_count': completionCount,
      'is_completed_today': isCompletedToday,
      'icon_key': iconKey,
    };
  }

  factory GoodDeedModel.fromEntity(GoodDeedEntity entity) {
    return GoodDeedModel(
      id: entity.id,
      title: entity.title,
      category: entity.category,
      rewardDescription: entity.rewardDescription,
      completionCount: entity.completionCount,
      isCompletedToday: entity.isCompletedToday,
      iconKey: entity.iconKey,
    );
  }
}

