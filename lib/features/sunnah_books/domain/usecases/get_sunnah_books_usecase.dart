import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/repositories/sunnah_repository.dart';

class GetSunnahBooksUseCase {
  final SunnahRepository repository;

  const GetSunnahBooksUseCase({required this.repository});

  Future<Either<Failure, List<SunnahBookEntity>>> call() {
    return repository.getBooksCatalog();
  }
}

