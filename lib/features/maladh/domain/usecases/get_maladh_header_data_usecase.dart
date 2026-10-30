import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/maladh/domain/entities/maladh_header_data.dart';
import 'package:sakina_app/features/maladh/domain/repositories/maladh_repository.dart';

/// Single-responsibility usecase to fetch current spiritual header data for Al-Maladh sanctuary.
class GetMaladhHeaderDataUseCase implements UseCase<MaladhHeaderData, NoParams> {
  final MaladhRepository repository;

  const GetMaladhHeaderDataUseCase({required this.repository});

  @override
  Future<Either<Failure, MaladhHeaderData>> call(NoParams params) {
    return repository.getHeaderData();
  }
}

