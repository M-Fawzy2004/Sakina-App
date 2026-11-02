import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_chapter_entity.dart';

class SunnahBookEntity extends Equatable {
  final int id;
  final String key;
  final String titleAr;
  final String titleEn;
  final String authorAr;
  final String authorEn;
  final String introductionAr;
  final int hadithsCount;
  final int chaptersCount;
  final List<SunnahChapterEntity> chapters;

  const SunnahBookEntity({
    required this.id,
    required this.key,
    required this.titleAr,
    required this.titleEn,
    required this.authorAr,
    required this.authorEn,
    required this.introductionAr,
    required this.hadithsCount,
    required this.chaptersCount,
    required this.chapters,
  });

  @override
  List<Object?> get props => [
        id,
        key,
        titleAr,
        titleEn,
        authorAr,
        authorEn,
        introductionAr,
        hadithsCount,
        chaptersCount,
        chapters,
      ];
}

