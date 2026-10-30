import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/splash/domain/usecases/check_initial_app_state_usecase.dart';
import 'package:sakina_app/features/splash/presentation/cubit/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final CheckInitialAppStateUseCase checkInitialAppStateUseCase;

  SplashCubit({required this.checkInitialAppStateUseCase}) : super(const SplashInitial());

  Future<void> initializeApp() async {
    emit(const SplashAnimating());

    final result = await checkInitialAppStateUseCase(const NoParams());

    result.fold(
      (failure) {
        emit(SplashFailure(message: failure.message));
      },
      (destinationRoute) async {
        // Trigger subtle haptic click when app is primed and ready
        await HapticService.selectionClick();
        emit(SplashCompleted(destinationRoute: destinationRoute));
      },
    );
  }
}

