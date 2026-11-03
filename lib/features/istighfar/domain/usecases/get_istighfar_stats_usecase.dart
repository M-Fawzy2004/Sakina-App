import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/istighfar/domain/repositories/istighfar_repository.dart';

class GetIstighfarStatsUseCase implements UseCase<int, NoParams> {
  final IstighfarRepository repository;

  const GetIstighfarStatsUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return repository.getTotalLifetimeCount();
  }
}

