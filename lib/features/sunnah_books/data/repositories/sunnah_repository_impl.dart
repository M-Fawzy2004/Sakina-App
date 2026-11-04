import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/features/sunnah_books/data/datasources/sunnah_local_data_source.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_page_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/failures/sunnah_failure.dart';
import 'package:sakina_app/features/sunnah_books/domain/repositories/sunnah_repository.dart';

class SunnahRepositoryImpl implements SunnahRepository {
  final SunnahLocalDataSource localDataSource;

  const SunnahRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<SunnahBookEntity>>> getBooksCatalog() async {
    try {
      final books = await localDataSource.loadCatalog();
      return Right(books);
    } catch (e) {
      AppLogger.error('SunnahRepository: getBooksCatalog failed', e);
      return const Left(SunnahFailure(message: 'تعذر تحميل فهرس كتب السنة، يرجى المحاولة لاحقاً'));
    }
  }

  @override
  Future<Either<Failure, HadithPageEntity>> getBookHadiths({
    required String bookKey,
    int? chapterId,
    required int page,
    required int pageSize,
  }) async {
    try {
      final pageData = await localDataSource.getBookHadiths(
        bookKey: bookKey,
        chapterId: chapterId,
        page: page,
        pageSize: pageSize,
      );
      return Right(pageData);
    } catch (e) {
      AppLogger.error('SunnahRepository: getBookHadiths failed for $bookKey', e);
      return const Left(SunnahFailure(message: 'تعذر جلب الأحاديث النبوية'));
    }
  }

  @override
  Future<Either<Failure, HadithPageEntity>> searchHadiths({
    required String bookKey,
    required String query,
    required int page,
    required int pageSize,
  }) async {
    try {
      final pageData = await localDataSource.searchHadiths(
        bookKey: bookKey,
        query: query,
        page: page,
        pageSize: pageSize,
      );
      return Right(pageData);
    } catch (e) {
      AppLogger.error('SunnahRepository: searchHadiths failed for $query', e);
      return const Left(SunnahFailure(message: 'تعذر إتمام البحث في متون الأحاديث'));
    }
  }
}

