import 'package:sakina_app/features/inaba_recovery/domain/entities/repentance_step_entity.dart';

class RepentanceStepModel extends RepentanceStepEntity {
  const RepentanceStepModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.evidence,
    required super.isCompleted,
  });

  factory RepentanceStepModel.fromJson(Map<String, dynamic> json) {
    return RepentanceStepModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      evidence: json['evidence'] as String,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'evidence': evidence,
      'is_completed': isCompleted,
    };
  }

  factory RepentanceStepModel.fromEntity(RepentanceStepEntity entity) {
    return RepentanceStepModel(
      id: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      evidence: entity.evidence,
      isCompleted: entity.isCompleted,
    );
  }
}

