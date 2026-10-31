import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/repositories/audio_reciters_repository.dart';

class GetReciterTracksParams extends Equatable {
  final int reciterId;

  const GetReciterTracksParams({required this.reciterId});

  @override
  List<Object?> get props => [reciterId];
}

class GetReciterTracksUseCase implements UseCase<List<RecitationTrackEntity>, GetReciterTracksParams> {
  final AudioRecitersRepository repository;

  const GetReciterTracksUseCase({required this.repository});

  @override
  Future<Either<Failure, List<RecitationTrackEntity>>> call(GetReciterTracksParams params) {
    return repository.getReciterTracks(params.reciterId);
  }
}

