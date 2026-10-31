import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:sakina_app/features/settings/domain/repositories/settings_repository.dart';

class SetThemeModeParams extends Equatable {
  final AppThemeMode mode;

  const SetThemeModeParams({required this.mode});

  @override
  List<Object?> get props => [mode];
}

class SetThemeModeUseCase implements UseCase<void, SetThemeModeParams> {
  final SettingsRepository repository;

  const SetThemeModeUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SetThemeModeParams params) {
    return repository.setThemeMode(params.mode);
  }
}
