import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_level_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';

class GetSpiritualLevelsUseCase
    implements UseCase<List<SpiritualLevelEntity>, NoParams> {
  final InabaRepository repository;

  const GetSpiritualLevelsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SpiritualLevelEntity>>> call(NoParams params) {
    return repository.getSpiritualLevels();
  }
}

