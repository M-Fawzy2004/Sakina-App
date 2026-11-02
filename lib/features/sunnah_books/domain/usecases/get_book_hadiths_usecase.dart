import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_page_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/repositories/sunnah_repository.dart';

class GetBookHadithsUseCase {
  final SunnahRepository repository;

  const GetBookHadithsUseCase({required this.repository});

  Future<Either<Failure, HadithPageEntity>> call({
    required String bookKey,
    int? chapterId,
    required int page,
    int pageSize = 20,
  }) {
    return repository.getBookHadiths(
      bookKey: bookKey,
      chapterId: chapterId,
      page: page,
      pageSize: pageSize,
    );
  }
}

