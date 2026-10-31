import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/repentance_step_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';

class GetRepentanceStepsUseCase
    implements UseCase<List<RepentanceStepEntity>, NoParams> {
  final InabaRepository repository;

  const GetRepentanceStepsUseCase(this.repository);

  @override
  Future<Either<Failure, List<RepentanceStepEntity>>> call(NoParams params) {
    return repository.getRepentanceSteps();
  }
}

