import 'package:sakina_app/features/inaba_recovery/domain/entities/inaba_overview_entity.dart';

class InabaOverviewModel extends InabaOverviewEntity {
  const InabaOverviewModel({
    required super.streakDays,
    required super.bestStreakDays,
    required super.streakProgress,
    required super.totalGoodDeedsCompleted,
    required super.totalReflectionsCount,
    required super.currentSpiritualLevelTitle,
    required super.recoveryPathStatus,
    required super.lastTawbahDate,
  });

  factory InabaOverviewModel.fromJson(Map<String, dynamic> json) {
    return InabaOverviewModel(
      streakDays: json['streak_days'] as int? ?? 14,
      bestStreakDays: json['best_streak_days'] as int? ?? 21,
      streakProgress: (json['streak_progress'] as num?)?.toDouble() ?? 0.70,
      totalGoodDeedsCompleted: json['total_good_deeds'] as int? ?? 42,
      totalReflectionsCount: json['total_reflections'] as int? ?? 7,
      currentSpiritualLevelTitle:
          json['current_level_title'] as String? ?? 'الالتزام',
      recoveryPathStatus:
          json['recovery_path_status'] as String? ?? 'حتى الآن في طريق النقاء',
      lastTawbahDate: json['last_tawbah_date'] != null
          ? DateTime.parse(json['last_tawbah_date'] as String)
          : DateTime.now().subtract(const Duration(days: 14)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'streak_days': streakDays,
      'best_streak_days': bestStreakDays,
      'streak_progress': streakProgress,
      'total_good_deeds': totalGoodDeedsCompleted,
      'total_reflections': totalReflectionsCount,
      'current_level_title': currentSpiritualLevelTitle,
      'recovery_path_status': recoveryPathStatus,
      'last_tawbah_date': lastTawbahDate.toIso8601String(),
    };
  }

  factory InabaOverviewModel.fromEntity(InabaOverviewEntity entity) {
    return InabaOverviewModel(
      streakDays: entity.streakDays,
      bestStreakDays: entity.bestStreakDays,
      streakProgress: entity.streakProgress,
      totalGoodDeedsCompleted: entity.totalGoodDeedsCompleted,
      totalReflectionsCount: entity.totalReflectionsCount,
      currentSpiritualLevelTitle: entity.currentSpiritualLevelTitle,
      recoveryPathStatus: entity.recoveryPathStatus,
      lastTawbahDate: entity.lastTawbahDate,
    );
  }
}
