import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/repentance_step_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';

class ToggleRepentanceStepUseCase
    implements UseCase<RepentanceStepEntity, String> {
  final InabaRepository repository;

  const ToggleRepentanceStepUseCase(this.repository);

  @override
  Future<Either<Failure, RepentanceStepEntity>> call(String id) {
    return repository.toggleRepentanceStep(id);
  }
}

