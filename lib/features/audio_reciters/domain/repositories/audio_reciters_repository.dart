import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';

/// Abstract contract governing the audio recitation repository.
abstract interface class AudioRecitersRepository {
  /// Fetches the catalog of Quran reciters, optionally filtered by category or search term.
  Future<Either<Failure, List<ReciterEntity>>> getReciters({
    String? category,
    String? query,
  });

  /// Fetches the designated featured reciters for the interactive hero carousel.
  Future<Either<Failure, List<ReciterEntity>>> getFeaturedReciters();

  /// Fetches the designated single featured reciter ("شيخ اليوم").
  Future<Either<Failure, ReciterEntity>> getFeaturedReciter();

  /// Fetches recitation tracks for a specific reciter.
  Future<Either<Failure, List<RecitationTrackEntity>>> getReciterTracks(int reciterId);

  /// Fetches a specific track by its identifier.
  Future<Either<Failure, RecitationTrackEntity>> getTrackById(int trackId);
}

