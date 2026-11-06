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
  final DateTime? completedAt;

  const RecoveryPlanDayStepEntity({
    required this.dayNumber,
    required this.title,
    required this.practicalAction,
    required this.recommendedDhikr,
    required this.scripturalEvidence,
    this.isCompleted = false,
    this.completedAt,
  });

  bool get isCompletedToday {
    if (!isCompleted || completedAt == null) return false;
    final now = DateTime.now();
    return now.year == completedAt!.year &&
        now.month == completedAt!.month &&
        now.day == completedAt!.day;
  }

  RecoveryPlanDayStepEntity copyWith({
    int? dayNumber,
    String? title,
    String? practicalAction,
    String? recommendedDhikr,
    String? scripturalEvidence,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return RecoveryPlanDayStepEntity(
      dayNumber: dayNumber ?? this.dayNumber,
      title: title ?? this.title,
      practicalAction: practicalAction ?? this.practicalAction,
      recommendedDhikr: recommendedDhikr ?? this.recommendedDhikr,
      scripturalEvidence: scripturalEvidence ?? this.scripturalEvidence,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'dayNumber': dayNumber,
        'title': title,
        'practicalAction': practicalAction,
        'recommendedDhikr': recommendedDhikr,
        'scripturalEvidence': scripturalEvidence,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
      };

  factory RecoveryPlanDayStepEntity.fromJson(Map<String, dynamic> json) {
    return RecoveryPlanDayStepEntity(
      dayNumber: json['dayNumber'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      practicalAction: json['practicalAction'] as String? ?? '',
      recommendedDhikr: json['recommendedDhikr'] as String? ?? '',
      scripturalEvidence: json['scripturalEvidence'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
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
  int get totalStepsCount => steps.length;

  double get progress =>
      steps.isEmpty ? 0.0 : completedStepsCount / steps.length;

  bool get isFullyCompleted =>
      steps.isNotEmpty && completedStepsCount == steps.length;

  /// Checks whether a specific day's milestone is unlocked.
  /// Day 1 is always unlocked.
  /// Day N is unlocked ONLY IF day N-1 is completed AND day N-1 was NOT completed on the current calendar day
  /// (enforcing the strict spiritual rule of completing at most one step per calendar day).
  bool isStepUnlocked(int dayNumber, {DateTime? now}) {
    if (dayNumber <= 1) return true;
    final prevIndex = steps.indexWhere((s) => s.dayNumber == dayNumber - 1);
    if (prevIndex == -1) return false;
    final prevStep = steps[prevIndex];
    if (!prevStep.isCompleted) return false;
    final completedAt = prevStep.completedAt;
    if (completedAt == null) return true;
    final current = now ?? DateTime.now();
    final isSameDay = current.year == completedAt.year &&
        current.month == completedAt.month &&
        current.day == completedAt.day;
    return !isSameDay && current.isAfter(completedAt);
  }

  /// Checks if step N is specifically locked until tomorrow because step N-1 was completed today.
  bool isStepLockedUntilTomorrow(int dayNumber, {DateTime? now}) {
    if (dayNumber <= 1) return false;
    final prevIndex = steps.indexWhere((s) => s.dayNumber == dayNumber - 1);
    if (prevIndex == -1) return false;
    final prevStep = steps[prevIndex];
    if (!prevStep.isCompleted) return false;
    final completedAt = prevStep.completedAt;
    if (completedAt == null) return false;
    final current = now ?? DateTime.now();
    return current.year == completedAt.year &&
        current.month == completedAt.month &&
        current.day == completedAt.day;
  }

  /// The step that is either completed today or the next active incomplete step.
  RecoveryPlanDayStepEntity get activeOrTodayStep {
    if (steps.isEmpty) {
      return const RecoveryPlanDayStepEntity(
        dayNumber: 1,
        title: '',
        practicalAction: '',
        recommendedDhikr: '',
        scripturalEvidence: '',
      );
    }
    final todayCompleted = steps.where((s) => s.isCompletedToday).toList();
    if (todayCompleted.isNotEmpty) {
      return todayCompleted.last;
    }
    final nextIncomplete = steps.where((s) => !s.isCompleted).toList();
    if (nextIncomplete.isNotEmpty) {
      return nextIncomplete.first;
    }
    return steps.last;
  }

  bool get hasStepCompletedToday => steps.any((s) => s.isCompletedToday);

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

