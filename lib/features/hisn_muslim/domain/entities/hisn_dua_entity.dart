import 'package:equatable/equatable.dart';

class HisnDuaEntity extends Equatable {
  final int id;
  final int chapterId;
  final String chapterTitle;
  final String chapterTitleAr;
  final String reference;
  final String arabic;
  final String english;

  const HisnDuaEntity({
    required this.id,
    required this.chapterId,
    required this.chapterTitle,
    required this.chapterTitleAr,
    required this.reference,
    required this.arabic,
    required this.english,
  });

  @override
  List<Object?> get props => [
        id,
        chapterId,
        chapterTitle,
        chapterTitleAr,
        reference,
        arabic,
        english,
      ];
}

