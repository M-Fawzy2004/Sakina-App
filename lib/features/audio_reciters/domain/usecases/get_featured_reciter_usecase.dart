import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/repositories/audio_reciters_repository.dart';

class GetFeaturedReciterUseCase implements UseCase<List<ReciterEntity>, NoParams> {
  final AudioRecitersRepository repository;

  const GetFeaturedReciterUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ReciterEntity>>> call(NoParams params) {
    return repository.getFeaturedReciters();
  }
}
