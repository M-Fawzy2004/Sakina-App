import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_reflection_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';

class GetSpiritualReflectionsUseCase
    implements UseCase<List<SpiritualReflectionEntity>, NoParams> {
  final InabaRepository repository;

  const GetSpiritualReflectionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SpiritualReflectionEntity>>> call(NoParams params) {
    return repository.getReflections();
  }
}

