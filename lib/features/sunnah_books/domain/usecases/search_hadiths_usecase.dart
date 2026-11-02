import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_page_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/repositories/sunnah_repository.dart';

class SearchHadithsUseCase {
  final SunnahRepository repository;

  const SearchHadithsUseCase({required this.repository});

  Future<Either<Failure, HadithPageEntity>> call({
    required String bookKey,
    required String query,
    required int page,
    int pageSize = 20,
  }) {
    return repository.searchHadiths(
      bookKey: bookKey,
      query: query,
      page: page,
      pageSize: pageSize,
    );
  }
}

