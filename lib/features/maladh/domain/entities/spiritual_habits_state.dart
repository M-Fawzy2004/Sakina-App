import 'package:equatable/equatable.dart';

/// Pure domain entity encapsulating the 3 daily spiritual habits and streak count.
class SpiritualHabitsState extends Equatable {
  final bool athkarDone;
  final bool quranDone;
  final bool witrDone;
  final int streakDays;
  final String dateString;

  const SpiritualHabitsState({
    required this.athkarDone,
    required this.quranDone,
    required this.witrDone,
    required this.streakDays,
    required this.dateString,
  });

  int get completedCount =>
      (athkarDone ? 1 : 0) + (quranDone ? 1 : 0) + (witrDone ? 1 : 0);

  int get totalCount => 3;

  double get progressFraction => completedCount / totalCount;

  bool get isAllCompleted => completedCount == totalCount;

  SpiritualHabitsState copyWith({
    bool? athkarDone,
    bool? quranDone,
    bool? witrDone,
    int? streakDays,
    String? dateString,
  }) {
    return SpiritualHabitsState(
      athkarDone: athkarDone ?? this.athkarDone,
      quranDone: quranDone ?? this.quranDone,
      witrDone: witrDone ?? this.witrDone,
      streakDays: streakDays ?? this.streakDays,
      dateString: dateString ?? this.dateString,
    );
  }

  static SpiritualHabitsState initial(String today) {
    return SpiritualHabitsState(
      athkarDone: false,
      quranDone: false,
      witrDone: false,
      streakDays: 1,
      dateString: today,
    );
  }

  @override
  List<Object?> get props => [
        athkarDone,
        quranDone,
        witrDone,
        streakDays,
        dateString,
      ];
}

