import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/exceptions.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/features/audio_reciters/data/datasources/audio_reciters_local_data_source.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/repositories/audio_reciters_repository.dart';

class AudioRecitersRepositoryImpl implements AudioRecitersRepository {
  final AudioRecitersLocalDataSource localDataSource;

  const AudioRecitersRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ReciterEntity>>> getReciters({
    String? category,
    String? query,
  }) async {
    try {
      final models = await localDataSource.getReciters(
        category: category,
        query: query,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      AppLogger.error('AudioRecitersRepository: getReciters failed', e);
      return const Left(UnexpectedFailure(message: 'حدث خطأ غير متوقع أثناء استرجاع القراء، يرجى المحاولة لاحقاً'));
    }
  }

  @override
  Future<Either<Failure, List<ReciterEntity>>> getFeaturedReciters() async {
    try {
      final models = await localDataSource.getFeaturedReciters();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      AppLogger.error('AudioRecitersRepository: getFeaturedReciters failed', e);
      return const Left(UnexpectedFailure(message: 'حدث خطأ أثناء استرجاع القراء المميزين'));
    }
  }

  @override
  Future<Either<Failure, ReciterEntity>> getFeaturedReciter() async {
    try {
      final model = await localDataSource.getFeaturedReciter();
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      AppLogger.error('AudioRecitersRepository: getFeaturedReciter failed', e);
      return const Left(UnexpectedFailure(message: 'حدث خطأ أثناء استرجاع القارئ المختار'));
    }
  }

  @override
  Future<Either<Failure, List<RecitationTrackEntity>>> getReciterTracks(int reciterId) async {
    try {
      final models = await localDataSource.getReciterTracks(reciterId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      AppLogger.error('AudioRecitersRepository: getReciterTracks failed', e);
      return const Left(UnexpectedFailure(message: 'حدث خطأ أثناء استرجاع التلاوات، يرجى المحاولة مجدداً'));
    }
  }

  @override
  Future<Either<Failure, RecitationTrackEntity>> getTrackById(int trackId) async {
    try {
      final model = await localDataSource.getTrackById(trackId);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      AppLogger.error('AudioRecitersRepository: getTrackById failed', e);
      return const Left(UnexpectedFailure(message: 'حدث خطأ أثناء استرجاع بيانات التلاوة'));
    }
  }
}

