import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/istighfar/domain/entities/istighfar_item.dart';
import 'package:sakina_app/features/istighfar/domain/repositories/istighfar_repository.dart';

class GetIstighfarItemsUseCase
    implements UseCase<List<IstighfarItem>, NoParams> {
  final IstighfarRepository repository;

  const GetIstighfarItemsUseCase(this.repository);

  @override
  Future<Either<Failure, List<IstighfarItem>>> call(NoParams params) {
    return repository.getIstighfarItems();
  }
}

