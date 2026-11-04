import 'package:equatable/equatable.dart';

/// Represents the high-level spiritual recovery metrics and streak status of the user.
class InabaOverviewEntity extends Equatable {
  final int streakDays;
  final int bestStreakDays;
  final double streakProgress;
  final int totalGoodDeedsCompleted;
  final int totalReflectionsCount;
  final String currentSpiritualLevelTitle;
  final String recoveryPathStatus;
  final DateTime lastTawbahDate;
  final bool isPathActivated;
  final int currentActiveDay;

  const InabaOverviewEntity({
    required this.streakDays,
    required this.bestStreakDays,
    required this.streakProgress,
    required this.totalGoodDeedsCompleted,
    required this.totalReflectionsCount,
    required this.currentSpiritualLevelTitle,
    required this.recoveryPathStatus,
    required this.lastTawbahDate,
    this.isPathActivated = false,
    this.currentActiveDay = 1,
  });

  InabaOverviewEntity copyWith({
    int? streakDays,
    int? bestStreakDays,
    double? streakProgress,
    int? totalGoodDeedsCompleted,
    int? totalReflectionsCount,
    String? currentSpiritualLevelTitle,
    String? recoveryPathStatus,
    DateTime? lastTawbahDate,
    bool? isPathActivated,
    int? currentActiveDay,
  }) {
    return InabaOverviewEntity(
      streakDays: streakDays ?? this.streakDays,
      bestStreakDays: bestStreakDays ?? this.bestStreakDays,
      streakProgress: streakProgress ?? this.streakProgress,
      totalGoodDeedsCompleted:
          totalGoodDeedsCompleted ?? this.totalGoodDeedsCompleted,
      totalReflectionsCount:
          totalReflectionsCount ?? this.totalReflectionsCount,
      currentSpiritualLevelTitle:
          currentSpiritualLevelTitle ?? this.currentSpiritualLevelTitle,
      recoveryPathStatus: recoveryPathStatus ?? this.recoveryPathStatus,
      lastTawbahDate: lastTawbahDate ?? this.lastTawbahDate,
      isPathActivated: isPathActivated ?? this.isPathActivated,
      currentActiveDay: currentActiveDay ?? this.currentActiveDay,
    );
  }

  @override
  List<Object?> get props => [
        streakDays,
        bestStreakDays,
        streakProgress,
        totalGoodDeedsCompleted,
        totalReflectionsCount,
        currentSpiritualLevelTitle,
        recoveryPathStatus,
        lastTawbahDate,
        isPathActivated,
        currentActiveDay,
      ];
}
