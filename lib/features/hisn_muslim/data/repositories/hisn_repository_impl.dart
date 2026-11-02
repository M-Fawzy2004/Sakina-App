import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/hisn_muslim/data/datasources/hisn_local_data_source.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_chapter_entity.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_dua_entity.dart';
import 'package:sakina_app/features/hisn_muslim/domain/failures/hisn_failure.dart';
import 'package:sakina_app/features/hisn_muslim/domain/repositories/hisn_repository.dart';

class HisnRepositoryImpl implements HisnRepository {
  final HisnLocalDataSource localDataSource;

  const HisnRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<HisnChapterEntity>>> getAllChapters() async {
    try {
      final chapters = await localDataSource.loadChapters();
      return Right(chapters);
    } catch (e) {
      return Left(HisnFailure(message: 'فشل تحميل أبواب حصن المسلم: $e'));
    }
  }

  @override
  Future<Either<Failure, HisnChapterEntity>> getChapterById(int id) async {
    try {
      final chapter = await localDataSource.getChapterById(id);
      return Right(chapter);
    } catch (e) {
      return Left(HisnFailure(message: 'تعذر العثور على الباب المحدد: $e'));
    }
  }

  @override
  Future<Either<Failure, List<HisnDuaEntity>>> searchDuas(String query) async {
    try {
      final results = await localDataSource.searchDuas(query);
      return Right(results);
    } catch (e) {
      return Left(HisnFailure(message: 'فشل البحث في حصن المسلم: $e'));
    }
  }
}

