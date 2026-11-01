import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_item_entity.dart';
import 'package:sakina_app/features/athkar/domain/repositories/athkar_repository.dart';

class GetAthkarByCategoryParams extends Equatable {
  final String category;

  const GetAthkarByCategoryParams({required this.category});

  @override
  List<Object?> get props => [category];
}

/// Single responsibility UseCase for retrieving items of a specific Athkar category.
class GetAthkarByCategoryUseCase
    implements UseCase<List<AthkarItemEntity>, GetAthkarByCategoryParams> {
  final AthkarRepository repository;

  const GetAthkarByCategoryUseCase({required this.repository});

  @override
  Future<Either<Failure, List<AthkarItemEntity>>> call(
      GetAthkarByCategoryParams params) {
    return repository.getAthkarByCategory(params.category);
  }
}

