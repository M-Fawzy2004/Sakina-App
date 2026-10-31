import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';

class DeleteSpiritualReflectionUseCase implements UseCase<Unit, String> {
  final InabaRepository repository;

  const DeleteSpiritualReflectionUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteReflection(id);
  }
}

