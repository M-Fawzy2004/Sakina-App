import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/juz_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

/// Abstract domain contract governing Quran catalog and reader data access.
abstract interface class QuranRepository {
  /// Fetches the complete catalog of all 114 Surahs.
  Future<Either<Failure, List<SurahEntity>>> getSurahs();

  /// Fetches the index of all 30 Juzs.
  Future<Either<Failure, List<JuzEntity>>> getJuzs();

  /// Fetches the authentic Uthmanic verses for a specific Surah by its ID (1 to 114).
  Future<Either<Failure, List<AyahEntity>>> getSurahVerses(int surahId);

  /// Retrieves the user's last saved reading bookmark.
  Future<Either<Failure, QuranBookmarkEntity?>> getLastReadBookmark();

  /// Saves the user's current reading position as last read bookmark.
  Future<Either<Failure, Unit>> saveLastReadBookmark(QuranBookmarkEntity bookmark);
}

