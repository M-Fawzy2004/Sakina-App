import 'package:equatable/equatable.dart';

/// Pure domain entity encapsulating daily Quranic reading goal progress.
class MaladhDailyGoal extends Equatable {
  final int completedPages;
  final int totalPages;
  final int streakDays;
  final String remainingNote;

  const MaladhDailyGoal({
    required this.completedPages,
    required this.totalPages,
    required this.streakDays,
    required this.remainingNote,
  });

  double get progressPercentage =>
      totalPages > 0 ? (completedPages / totalPages).clamp(0.0, 1.0) : 0.0;

  int get progressPercentInt => (progressPercentage * 100).round();

  @override
  List<Object?> get props => [
        completedPages,
        totalPages,
        streakDays,
        remainingNote,
      ];
}

