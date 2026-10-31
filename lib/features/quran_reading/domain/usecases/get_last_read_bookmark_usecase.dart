import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/repositories/quran_repository.dart';

/// UseCase retrieving the last saved reading position.
class GetLastReadBookmarkUseCase implements UseCase<QuranBookmarkEntity?, NoParams> {
  final QuranRepository repository;

  const GetLastReadBookmarkUseCase({required this.repository});

  @override
  Future<Either<Failure, QuranBookmarkEntity?>> call(NoParams params) {
    return repository.getLastReadBookmark();
  }
}

