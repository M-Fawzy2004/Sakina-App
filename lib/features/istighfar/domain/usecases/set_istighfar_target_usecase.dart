import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/istighfar/domain/entities/istighfar_item.dart';
import 'package:sakina_app/features/istighfar/domain/repositories/istighfar_repository.dart';

class SetIstighfarTargetParams extends Equatable {
  final String itemId;
  final int target;

  const SetIstighfarTargetParams({
    required this.itemId,
    required this.target,
  });

  @override
  List<Object?> get props => [itemId, target];
}

class SetIstighfarTargetUseCase
    implements UseCase<IstighfarItem, SetIstighfarTargetParams> {
  final IstighfarRepository repository;

  const SetIstighfarTargetUseCase(this.repository);

  @override
  Future<Either<Failure, IstighfarItem>> call(
    SetIstighfarTargetParams params,
  ) {
    return repository.setTargetCount(params.itemId, params.target);
  }
}

