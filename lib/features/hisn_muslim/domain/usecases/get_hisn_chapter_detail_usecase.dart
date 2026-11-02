import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_chapter_entity.dart';
import 'package:sakina_app/features/hisn_muslim/domain/repositories/hisn_repository.dart';

class GetHisnChapterDetailUseCase {
  final HisnRepository repository;

  const GetHisnChapterDetailUseCase({required this.repository});

  Future<Either<Failure, HisnChapterEntity>> call(int chapterId) {
    return repository.getChapterById(chapterId);
  }
}

