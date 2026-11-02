import 'package:equatable/equatable.dart';

class DailyHadithItem extends Equatable {
  final int id;
  final String arabic;
  final String bookKey;
  final String bookTitleAr;
  final String narratorAr;
  final int hadithNumber;
  final int chapterId;
  final String? topic;

  const DailyHadithItem({
    required this.id,
    required this.arabic,
    required this.bookKey,
    required this.bookTitleAr,
    required this.narratorAr,
    required this.hadithNumber,
    required this.chapterId,
    this.topic,
  });

  @override
  List<Object?> get props => [
        id,
        arabic,
        bookKey,
        bookTitleAr,
        narratorAr,
        hadithNumber,
        chapterId,
        topic,
      ];
}

