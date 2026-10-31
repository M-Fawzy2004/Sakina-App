import 'package:equatable/equatable.dart';

/// Immutable domain entity representing a Quranic Juz (1 to 30).
class JuzEntity extends Equatable {
  final int id;
  final String nameArabic;
  final String startSurahName;
  final int startVerseNumber;
  final int startPageNumber;
  final int endPageNumber;

  const JuzEntity({
    required this.id,
    required this.nameArabic,
    required this.startSurahName,
    required this.startVerseNumber,
    required this.startPageNumber,
    required this.endPageNumber,
  });

  @override
  List<Object?> get props => [
        id,
        nameArabic,
        startSurahName,
        startVerseNumber,
        startPageNumber,
        endPageNumber,
      ];
}

