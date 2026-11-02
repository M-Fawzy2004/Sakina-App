import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_entity.dart';

class HadithPageEntity extends Equatable {
  final List<HadithEntity> hadiths;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasMore;

  const HadithPageEntity({
    required this.hadiths,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [
        hadiths,
        page,
        pageSize,
        totalCount,
        hasMore,
      ];
}

