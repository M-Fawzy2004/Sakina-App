import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/quran_local_data_source.dart';
import 'package:sakina_app/features/quran_reading/data/models/quran_bookmark_model.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/juz_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/failures/quran_failure.dart';
import 'package:sakina_app/features/quran_reading/domain/repositories/quran_repository.dart';

/// Repository implementation fulfilling the Quran domain contract using local caching.
class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDataSource localDataSource;

  const QuranRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<SurahEntity>>> getSurahs() async {
    try {
      final models = await localDataSource.getSurahs();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (_) {
      return const Left(QuranDataFetchFailure());
    }
  }

  @override
  Future<Either<Failure, List<JuzEntity>>> getJuzs() async {
    try {
      final models = await localDataSource.getJuzs();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (_) {
      return const Left(QuranDataFetchFailure());
    }
  }

  @override
  Future<Either<Failure, List<AyahEntity>>> getSurahVerses(int surahId) async {
    try {
      final models = await localDataSource.getSurahVerses(surahId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (_) {
      return const Left(QuranDataFetchFailure());
    }
  }

  @override
  Future<Either<Failure, QuranBookmarkEntity?>> getLastReadBookmark() async {
    try {
      final model = await localDataSource.getLastReadBookmark();
      return Right(model?.toEntity());
    } catch (_) {
      return const Left(QuranBookmarkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLastReadBookmark(QuranBookmarkEntity bookmark) async {
    try {
      final model = QuranBookmarkModel(
        surahId: bookmark.surahId,
        surahName: bookmark.surahName,
        ayahNumber: bookmark.ayahNumber,
        pageNumber: bookmark.pageNumber,
        timestamp: bookmark.timestamp,
      );
      await localDataSource.saveLastReadBookmark(model);
      return const Right(unit);
    } catch (_) {
      return const Left(QuranBookmarkFailure());
    }
  }
}

