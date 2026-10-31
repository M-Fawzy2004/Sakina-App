import 'package:equatable/equatable.dart';

/// Immutable domain entity representing a Quranic Surah.
class SurahEntity extends Equatable {
  final int id;
  final String nameArabic;
  final String englishName;
  final String revelationType; // 'مكية' or 'مدنية'
  final int versesCount;
  final int pageNumber;
  final int juzNumber;

  const SurahEntity({
    required this.id,
    required this.nameArabic,
    required this.englishName,
    required this.revelationType,
    required this.versesCount,
    required this.pageNumber,
    required this.juzNumber,
  });

  @override
  List<Object?> get props => [
        id,
        nameArabic,
        englishName,
        revelationType,
        versesCount,
        pageNumber,
        juzNumber,
      ];
}

