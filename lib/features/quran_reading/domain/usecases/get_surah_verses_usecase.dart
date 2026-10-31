import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/repositories/quran_repository.dart';

class GetSurahVersesParams extends Equatable {
  final int surahId;

  const GetSurahVersesParams({required this.surahId});

  @override
  List<Object?> get props => [surahId];
}

/// UseCase retrieving the verses for a specific Surah.
class GetSurahVersesUseCase implements UseCase<List<AyahEntity>, GetSurahVersesParams> {
  final QuranRepository repository;

  const GetSurahVersesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<AyahEntity>>> call(GetSurahVersesParams params) {
    return repository.getSurahVerses(params.surahId);
  }
}

