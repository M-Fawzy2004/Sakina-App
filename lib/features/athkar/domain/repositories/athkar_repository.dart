import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_category_entity.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_item_entity.dart';

/// Contract interface for Athkar and Supplications repository.
abstract interface class AthkarRepository {
  Future<Either<Failure, List<AthkarCategoryEntity>>> getCategories();
  Future<Either<Failure, List<AthkarItemEntity>>> getAthkarByCategory(String category);
  Future<Either<Failure, Map<String, List<AthkarItemEntity>>>> getAllAthkar();
}

