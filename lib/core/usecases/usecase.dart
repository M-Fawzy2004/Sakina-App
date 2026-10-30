import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';

/// Unidirectional, single-responsibility usecase contract for asynchronous actions.
abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Contract for reactive stream usecases (e.g. audio progress, prayer countdowns).
abstract interface class StreamUseCase<T, Params> {
  Stream<Either<Failure, T>> call(Params params);
}

/// Parameter placeholder when a usecase requires no input arguments.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
