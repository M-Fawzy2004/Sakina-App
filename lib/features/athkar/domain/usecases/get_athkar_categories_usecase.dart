import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_category_entity.dart';
import 'package:sakina_app/features/athkar/domain/repositories/athkar_repository.dart';

/// Single responsibility UseCase for retrieving available Athkar categories.
class GetAthkarCategoriesUseCase
    implements UseCase<List<AthkarCategoryEntity>, NoParams> {
  final AthkarRepository repository;

  const GetAthkarCategoriesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<AthkarCategoryEntity>>> call(NoParams params) {
    return repository.getCategories();
  }
}

