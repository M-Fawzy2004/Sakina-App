import 'package:equatable/equatable.dart';

class SunnahChapterEntity extends Equatable {
  final int id;
  final int bookId;
  final String arabic;
  final String english;

  const SunnahChapterEntity({
    required this.id,
    required this.bookId,
    required this.arabic,
    required this.english,
  });

  @override
  List<Object?> get props => [id, bookId, arabic, english];
}

