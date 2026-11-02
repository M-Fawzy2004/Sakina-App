import 'package:equatable/equatable.dart';

class HadithEntity extends Equatable {
  final int id;
  final int idInBook;
  final int chapterId;
  final int bookId;
  final String arabic;
  final String englishNarrator;
  final String englishText;

  const HadithEntity({
    required this.id,
    required this.idInBook,
    required this.chapterId,
    required this.bookId,
    required this.arabic,
    required this.englishNarrator,
    required this.englishText,
  });

  @override
  List<Object?> get props => [
        id,
        idInBook,
        chapterId,
        bookId,
        arabic,
        englishNarrator,
        englishText,
      ];
}

