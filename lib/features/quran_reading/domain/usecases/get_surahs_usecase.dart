import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/repositories/quran_repository.dart';

/// UseCase retrieving the complete index of 114 Quranic Surahs.
class GetSurahsUseCase implements UseCase<List<SurahEntity>, NoParams> {
  final QuranRepository repository;

  const GetSurahsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<SurahEntity>>> call(NoParams params) {
    return repository.getSurahs();
  }
}

