import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/constants/app_constants.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/router/route_constants.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/usecases/usecase.dart';

class CompleteOnboardingUseCase implements UseCase<String, NoParams> {
  final PreferencesService preferencesService;

  const CompleteOnboardingUseCase({required this.preferencesService});

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    try {
      await preferencesService.setBool(AppConstants.keyOnboardingCompleted, true);
      // Skip authentication for now, route directly to local sanctuary (Quran)
      return const Right(AppRoutes.quran);
    } catch (e) {
      return Left(CacheFailure(message: 'فشل حفظ حالة الإعداد: $e'));
    }
  }
}

