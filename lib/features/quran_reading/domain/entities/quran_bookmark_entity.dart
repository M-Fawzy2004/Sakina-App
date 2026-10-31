import 'package:equatable/equatable.dart';

/// Immutable domain entity representing a saved Quranic bookmark / last read position.
class QuranBookmarkEntity extends Equatable {
  final int surahId;
  final String surahName;
  final int ayahNumber;
  final int pageNumber;
  final DateTime timestamp;

  const QuranBookmarkEntity({
    required this.surahId,
    required this.surahName,
    required this.ayahNumber,
    required this.pageNumber,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        surahId,
        surahName,
        ayahNumber,
        pageNumber,
        timestamp,
      ];
}

