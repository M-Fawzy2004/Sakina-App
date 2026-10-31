import 'package:equatable/equatable.dart';

/// Represents a spiritual progression level in the Tree of Light ("شجرة النور").
class SpiritualLevelEntity extends Equatable {
  final int levelIndex;
  final String title;
  final int minDays;
  final int maxDays;
  final String description;
  final bool isUnlocked;
  final bool isCurrent;

  const SpiritualLevelEntity({
    required this.levelIndex,
    required this.title,
    required this.minDays,
    required this.maxDays,
    required this.description,
    required this.isUnlocked,
    required this.isCurrent,
  });

  @override
  List<Object?> get props => [
        levelIndex,
        title,
        minDays,
        maxDays,
        description,
        isUnlocked,
        isCurrent,
      ];
}

