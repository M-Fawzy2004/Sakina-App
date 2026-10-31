import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_reflection_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';

class SaveSpiritualReflectionParams extends Equatable {
  final String title;
  final String content;
  final String moodTag;

  const SaveSpiritualReflectionParams({
    required this.title,
    required this.content,
    required this.moodTag,
  });

  @override
  List<Object?> get props => [title, content, moodTag];
}

class SaveSpiritualReflectionUseCase
    implements
        UseCase<SpiritualReflectionEntity, SaveSpiritualReflectionParams> {
  final InabaRepository repository;

  const SaveSpiritualReflectionUseCase(this.repository);

  @override
  Future<Either<Failure, SpiritualReflectionEntity>> call(
      SaveSpiritualReflectionParams params) {
    return repository.saveReflection(
      title: params.title,
      content: params.content,
      moodTag: params.moodTag,
    );
  }
}

