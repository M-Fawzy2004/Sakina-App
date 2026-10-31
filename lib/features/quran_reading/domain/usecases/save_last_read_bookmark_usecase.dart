import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/repositories/quran_repository.dart';

class SaveLastReadBookmarkParams extends Equatable {
  final QuranBookmarkEntity bookmark;

  const SaveLastReadBookmarkParams({required this.bookmark});

  @override
  List<Object?> get props => [bookmark];
}

/// UseCase saving the user's reading position.
class SaveLastReadBookmarkUseCase implements UseCase<Unit, SaveLastReadBookmarkParams> {
  final QuranRepository repository;

  const SaveLastReadBookmarkUseCase({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(SaveLastReadBookmarkParams params) {
    return repository.saveLastReadBookmark(params.bookmark);
  }
}

