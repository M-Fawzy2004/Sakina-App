import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/daily_hope_dose_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';

class ToggleSaveHopeDoseUseCase implements UseCase<DailyHopeDoseEntity, String> {
  final InabaRepository repository;

  const ToggleSaveHopeDoseUseCase(this.repository);

  @override
  Future<Either<Failure, DailyHopeDoseEntity>> call(String id) {
    return repository.toggleSaveHopeDose(id);
  }
}

