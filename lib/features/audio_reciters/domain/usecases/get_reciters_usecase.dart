import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/repositories/audio_reciters_repository.dart';

class GetRecitersParams extends Equatable {
  final String? category;
  final String? query;

  const GetRecitersParams({this.category, this.query});

  @override
  List<Object?> get props => [category, query];
}

class GetRecitersUseCase implements UseCase<List<ReciterEntity>, GetRecitersParams> {
  final AudioRecitersRepository repository;

  const GetRecitersUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ReciterEntity>>> call(GetRecitersParams params) {
    return repository.getReciters(
      category: params.category,
      query: params.query,
    );
  }
}

