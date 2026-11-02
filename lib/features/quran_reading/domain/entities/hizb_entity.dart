import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/hizbs_part1.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/hizbs_part2.dart';

/// Immutable domain entity representing one of the 60 Quranic Hizbs (الأحزاب القرآنية).
class HizbEntity extends Equatable {
  final int number; // 1 to 60
  final int juzNumber; // 1 to 30
  final int surahId; // 1 to 114
  final String surahName;
  final int startVerseNumber;
  final int startPageNumber;
  final String quarterTitle;

  const HizbEntity({
    required this.number,
    required this.juzNumber,
    required this.surahId,
    required this.surahName,
    required this.startVerseNumber,
    required this.startPageNumber,
    required this.quarterTitle,
  });

  @override
  List<Object?> get props => [
        number,
        juzNumber,
        surahId,
        surahName,
        startVerseNumber,
        startPageNumber,
        quarterTitle,
      ];

  /// The complete authentic dataset of all 60 Hizbs in the Holy Quran (Mushaf Al-Madinah).
  static const List<HizbEntity> allHizbs = [
    ...kHizbsPart1,
    ...kHizbsPart2,
  ];
}
