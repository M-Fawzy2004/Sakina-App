import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/constants/app_constants.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/router/route_constants.dart';
import 'package:sakina_app/core/services/storage/database_helper.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/core/utils/app_logger.dart';

class CheckInitialAppStateUseCase implements UseCase<String, NoParams> {
  final PreferencesService preferencesService;
  final DatabaseHelper databaseHelper;

  const CheckInitialAppStateUseCase({
    required this.preferencesService,
    required this.databaseHelper,
  });

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    try {
      final stopwatch = Stopwatch()..start();

      // 1. Warm up SQLite database schema and composite indices in background
      await databaseHelper.database;
      AppLogger.info('Local database pre-warmed successfully', 'SPLASH');

      // 2. Check onboarding completion flag
      final isOnboardingCompleted = preferencesService.getBool(AppConstants.keyOnboardingCompleted) ?? false;
      final targetRoute = isOnboardingCompleted ? AppRoutes.maladh : AppRoutes.onboarding;

      // 3. Ensure minimum splash showcase duration to preserve luxury sensory immersion
      final elapsed = stopwatch.elapsed;
      if (elapsed < AppConstants.splashDelay) {
        await Future.delayed(AppConstants.splashDelay - elapsed);
      }

      return Right(targetRoute);
    } catch (e, stack) {
      AppLogger.error('Error during splash pre-flight check', e, stack, 'SPLASH');
      // Graceful fallback to guarantee user is never blocked on splash screen
      return const Right(AppRoutes.quran);
    }
  }
}

