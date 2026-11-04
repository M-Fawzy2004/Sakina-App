import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/inaba_overview_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';

class AdvanceActiveDayUseCase
    implements UseCase<InabaOverviewEntity, NoParams> {
  final InabaRepository repository;

  const AdvanceActiveDayUseCase(this.repository);

  @override
  Future<Either<Failure, InabaOverviewEntity>> call(NoParams params) {
    return repository.advanceActiveDay();
  }
}

