import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_chapter_entity.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_dua_entity.dart';

abstract interface class HisnRepository {
  Future<Either<Failure, List<HisnChapterEntity>>> getAllChapters();
  Future<Either<Failure, HisnChapterEntity>> getChapterById(int id);
  Future<Either<Failure, List<HisnDuaEntity>>> searchDuas(String query);
}

