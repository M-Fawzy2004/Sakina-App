import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/good_deed_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';

class GetGoodDeedsUseCase implements UseCase<List<GoodDeedEntity>, NoParams> {
  final InabaRepository repository;

  const GetGoodDeedsUseCase(this.repository);

  @override
  Future<Either<Failure, List<GoodDeedEntity>>> call(NoParams params) {
    return repository.getGoodDeeds();
  }
}

