import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/good_deed_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';

class ToggleGoodDeedUseCase implements UseCase<GoodDeedEntity, String> {
  final InabaRepository repository;

  const ToggleGoodDeedUseCase(this.repository);

  @override
  Future<Either<Failure, GoodDeedEntity>> call(String id) {
    return repository.toggleGoodDeed(id);
  }
}

