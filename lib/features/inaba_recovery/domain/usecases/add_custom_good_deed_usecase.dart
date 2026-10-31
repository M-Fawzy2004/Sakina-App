import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/good_deed_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';

class AddCustomGoodDeedParams extends Equatable {
  final String title;
  final String category;

  const AddCustomGoodDeedParams({required this.title, required this.category});

  @override
  List<Object?> get props => [title, category];
}

class AddCustomGoodDeedUseCase
    implements UseCase<GoodDeedEntity, AddCustomGoodDeedParams> {
  final InabaRepository repository;

  const AddCustomGoodDeedUseCase(this.repository);

  @override
  Future<Either<Failure, GoodDeedEntity>> call(AddCustomGoodDeedParams params) {
    return repository.addCustomGoodDeed(params.title, params.category);
  }
}
