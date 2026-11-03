import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/istighfar/data/datasources/istighfar_local_data_source.dart';
import 'package:sakina_app/features/istighfar/domain/entities/istighfar_item.dart';
import 'package:sakina_app/features/istighfar/domain/failures/istighfar_failure.dart';
import 'package:sakina_app/features/istighfar/domain/repositories/istighfar_repository.dart';

class IstighfarRepositoryImpl implements IstighfarRepository {
  final IstighfarLocalDataSource localDataSource;

  const IstighfarRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<IstighfarItem>>> getIstighfarItems() async {
    try {
      final items = await localDataSource.getIstighfarItems();
      return Right(List<IstighfarItem>.from(items));
    } catch (e) {
      return Left(IstighfarStorageFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, IstighfarItem>> incrementCount(String itemId) async {
    try {
      final updated = await localDataSource.incrementCount(itemId);
      return Right(updated);
    } catch (e) {
      return Left(IstighfarStorageFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, IstighfarItem>> resetCurrentCycle(String itemId) async {
    try {
      final reset = await localDataSource.resetCurrentCycle(itemId);
      return Right(reset);
    } catch (e) {
      return Left(IstighfarStorageFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalLifetimeCount() async {
    try {
      final total = await localDataSource.getTotalLifetimeCount();
      return Right(total);
    } catch (e) {
      return Left(IstighfarStorageFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, IstighfarItem>> setTargetCount(
    String itemId,
    int target,
  ) async {
    try {
      final updated = await localDataSource.setTargetCount(itemId, target);
      return Right(updated);
    } catch (e) {
      return Left(IstighfarStorageFailure(message: e.toString()));
    }
  }
}

