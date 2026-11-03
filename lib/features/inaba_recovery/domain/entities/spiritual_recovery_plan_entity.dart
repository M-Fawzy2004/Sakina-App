import 'package:flutter/foundation.dart';

/// Single daily milestone or action step within a spiritual recovery plan.
@immutable
class RecoveryPlanDayStepEntity {
  final int dayNumber;
  final String title;
  final String practicalAction;
  final String recommendedDhikr;
  final String scripturalEvidence;
  final bool isCompleted;

  const RecoveryPlanDayStepEntity({
    required this.dayNumber,
    required this.title,
    required this.practicalAction,
    required this.recommendedDhikr,
    required this.scripturalEvidence,
    this.isCompleted = false,
  });

  RecoveryPlanDayStepEntity copyWith({
    int? dayNumber,
    String? title,
    String? practicalAction,
    String? recommendedDhikr,
    String? scripturalEvidence,
    bool? isCompleted,
  }) {
    return RecoveryPlanDayStepEntity(
      dayNumber: dayNumber ?? this.dayNumber,
      title: title ?? this.title,
      practicalAction: practicalAction ?? this.practicalAction,
      recommendedDhikr: recommendedDhikr ?? this.recommendedDhikr,
      scripturalEvidence: scripturalEvidence ?? this.scripturalEvidence,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'dayNumber': dayNumber,
        'title': title,
        'practicalAction': practicalAction,
        'recommendedDhikr': recommendedDhikr,
        'scripturalEvidence': scripturalEvidence,
        'isCompleted': isCompleted,
      };

  factory RecoveryPlanDayStepEntity.fromJson(Map<String, dynamic> json) {
    return RecoveryPlanDayStepEntity(
      dayNumber: json['dayNumber'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      practicalAction: json['practicalAction'] as String? ?? '',
      recommendedDhikr: json['recommendedDhikr'] as String? ?? '',
      scripturalEvidence: json['scripturalEvidence'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

/// A complete structured repentance & spiritual recovery roadmap.
@immutable
class SpiritualRecoveryPlanEntity {
  final String id;
  final String title;
  final String badge;
  final String durationText;
  final String description;
  final String iconKey;
  final List<RecoveryPlanDayStepEntity> steps;

  const SpiritualRecoveryPlanEntity({
    required this.id,
    required this.title,
    required this.badge,
    required this.durationText,
    required this.description,
    required this.iconKey,
    required this.steps,
  });

  int get completedStepsCount => steps.where((s) => s.isCompleted).length;

  double get progress =>
      steps.isEmpty ? 0.0 : completedStepsCount / steps.length;

  bool get isFullyCompleted =>
      steps.isNotEmpty && completedStepsCount == steps.length;

  SpiritualRecoveryPlanEntity copyWith({
    String? id,
    String? title,
    String? badge,
    String? durationText,
    String? description,
    String? iconKey,
    List<RecoveryPlanDayStepEntity>? steps,
  }) {
    return SpiritualRecoveryPlanEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      badge: badge ?? this.badge,
      durationText: durationText ?? this.durationText,
      description: description ?? this.description,
      iconKey: iconKey ?? this.iconKey,
      steps: steps ?? this.steps,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'badge': badge,
        'durationText': durationText,
        'description': description,
        'iconKey': iconKey,
        'steps': steps.map((s) => s.toJson()).toList(),
      };

  factory SpiritualRecoveryPlanEntity.fromJson(Map<String, dynamic> json) {
    final rawSteps = json['steps'] as List<dynamic>? ?? [];
    return SpiritualRecoveryPlanEntity(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      badge: json['badge'] as String? ?? '',
      durationText: json['durationText'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconKey: json['iconKey'] as String? ?? 'shield',
      steps: rawSteps
          .map((s) =>
              RecoveryPlanDayStepEntity.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}

