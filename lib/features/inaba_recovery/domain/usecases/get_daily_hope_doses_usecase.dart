import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/daily_hope_dose_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';

class GetDailyHopeDosesUseCase
    implements UseCase<List<DailyHopeDoseEntity>, NoParams> {
  final InabaRepository repository;

  const GetDailyHopeDosesUseCase(this.repository);

  @override
  Future<Either<Failure, List<DailyHopeDoseEntity>>> call(NoParams params) {
    return repository.getHopeDoses();
  }
}

