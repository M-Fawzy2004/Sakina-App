import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:sakina_app/features/settings/domain/repositories/settings_repository.dart';

class GetThemeModeUseCase implements UseCase<AppThemeMode, NoParams> {
  final SettingsRepository repository;

  const GetThemeModeUseCase({required this.repository});

  @override
  Future<Either<Failure, AppThemeMode>> call(NoParams params) {
    return repository.getThemeMode();
  }
}
