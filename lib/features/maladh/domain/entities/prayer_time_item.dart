import 'package:equatable/equatable.dart';

/// Pure domain entity representing a single prayer slot and its daily tracking state.
class PrayerTimeItem extends Equatable {
  final String id;
  final String nameArabic;
  final String timeEnglish;
  final bool isCompleted;
  final bool isNext;

  const PrayerTimeItem({
    required this.id,
    required this.nameArabic,
    required this.timeEnglish,
    this.isCompleted = false,
    this.isNext = false,
  });

  PrayerTimeItem copyWith({
    String? id,
    String? nameArabic,
    String? timeEnglish,
    bool? isCompleted,
    bool? isNext,
  }) {
    return PrayerTimeItem(
      id: id ?? this.id,
      nameArabic: nameArabic ?? this.nameArabic,
      timeEnglish: timeEnglish ?? this.timeEnglish,
      isCompleted: isCompleted ?? this.isCompleted,
      isNext: isNext ?? this.isNext,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nameArabic,
        timeEnglish,
        isCompleted,
        isNext,
      ];
}

