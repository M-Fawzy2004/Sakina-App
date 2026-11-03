import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/istighfar/domain/entities/istighfar_item.dart';

/// Abstract repository contract for Istighfar and Digital Sibha management.
abstract interface class IstighfarRepository {
  Future<Either<Failure, List<IstighfarItem>>> getIstighfarItems();
  Future<Either<Failure, IstighfarItem>> incrementCount(String itemId);
  Future<Either<Failure, IstighfarItem>> resetCurrentCycle(String itemId);
  Future<Either<Failure, int>> getTotalLifetimeCount();
  Future<Either<Failure, IstighfarItem>> setTargetCount(String itemId, int target);
}

