import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/juz_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/repositories/quran_repository.dart';

/// UseCase retrieving the index of all 30 Quranic Juzs.
class GetJuzsUseCase implements UseCase<List<JuzEntity>, NoParams> {
  final QuranRepository repository;

  const GetJuzsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<JuzEntity>>> call(NoParams params) {
    return repository.getJuzs();
  }
}

