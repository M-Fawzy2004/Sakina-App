import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/istighfar/domain/entities/istighfar_item.dart';
import 'package:sakina_app/features/istighfar/domain/repositories/istighfar_repository.dart';

class IncrementIstighfarCountParams extends Equatable {
  final String itemId;

  const IncrementIstighfarCountParams({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class IncrementIstighfarCountUseCase
    implements UseCase<IstighfarItem, IncrementIstighfarCountParams> {
  final IstighfarRepository repository;

  const IncrementIstighfarCountUseCase(this.repository);

  @override
  Future<Either<Failure, IstighfarItem>> call(
    IncrementIstighfarCountParams params,
  ) {
    return repository.incrementCount(params.itemId);
  }
}

