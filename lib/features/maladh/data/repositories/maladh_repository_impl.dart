import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/features/maladh/data/datasources/maladh_local_data_source.dart';
import 'package:sakina_app/features/maladh/domain/entities/maladh_header_data.dart';
import 'package:sakina_app/features/maladh/domain/failures/maladh_failure.dart';
import 'package:sakina_app/features/maladh/domain/repositories/maladh_repository.dart';

class MaladhRepositoryImpl implements MaladhRepository {
  final MaladhLocalDataSource localDataSource;

  const MaladhRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, MaladhHeaderData>> getHeaderData() async {
    try {
      final headerModel = await localDataSource.getHeaderData();
      return Right(headerModel.toEntity());
    } catch (e, stack) {
      AppLogger.error('Failed to load maladh header data', e, stack, 'MALADH_REPO');
      return const Left(MaladhHeaderFetchFailure());
    }
  }
}

