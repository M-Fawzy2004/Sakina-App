import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_page_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';

abstract interface class SunnahRepository {
  Future<Either<Failure, List<SunnahBookEntity>>> getBooksCatalog();
  Future<Either<Failure, HadithPageEntity>> getBookHadiths({
    required String bookKey,
    int? chapterId,
    required int page,
    required int pageSize,
  });
  Future<Either<Failure, HadithPageEntity>> searchHadiths({
    required String bookKey,
    required String query,
    required int page,
    required int pageSize,
  });
}

