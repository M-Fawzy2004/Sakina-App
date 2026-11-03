import 'package:equatable/equatable.dart';

/// Immutable domain entity representing a sacred Istighfar or Tasbeeh phrase
/// along with its current cycle progress and lifetime local count.
class IstighfarItem extends Equatable {
  final String id;
  final String arabic;
  final String shortTitle;
  final String virtue;
  final int currentCycleCount;
  final int targetCount;
  final int lifetimeCount;
  final int lapsCompleted;

  const IstighfarItem({
    required this.id,
    required this.arabic,
    required this.shortTitle,
    required this.virtue,
    this.currentCycleCount = 0,
    this.targetCount = 33,
    this.lifetimeCount = 0,
    this.lapsCompleted = 0,
  });

  IstighfarItem copyWith({
    String? id,
    String? arabic,
    String? shortTitle,
    String? virtue,
    int? currentCycleCount,
    int? targetCount,
    int? lifetimeCount,
    int? lapsCompleted,
  }) {
    return IstighfarItem(
      id: id ?? this.id,
      arabic: arabic ?? this.arabic,
      shortTitle: shortTitle ?? this.shortTitle,
      virtue: virtue ?? this.virtue,
      currentCycleCount: currentCycleCount ?? this.currentCycleCount,
      targetCount: targetCount ?? this.targetCount,
      lifetimeCount: lifetimeCount ?? this.lifetimeCount,
      lapsCompleted: lapsCompleted ?? this.lapsCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        arabic,
        shortTitle,
        virtue,
        currentCycleCount,
        targetCount,
        lifetimeCount,
        lapsCompleted,
      ];
}

