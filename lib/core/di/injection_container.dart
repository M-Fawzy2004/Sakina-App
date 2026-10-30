import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:sakina_app/core/network/api_client.dart';
import 'package:sakina_app/core/network/dio_client.dart';
import 'package:sakina_app/core/network/network_info.dart';
import 'package:sakina_app/core/services/audio/audio_player_handler.dart';
import 'package:sakina_app/core/services/storage/database_helper.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/services/storage/secure_storage_service.dart';
import 'package:sakina_app/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:sakina_app/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:sakina_app/features/splash/domain/usecases/check_initial_app_state_usecase.dart';
import 'package:sakina_app/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

/// Global service locator initialization.
/// Resolves asynchronous platform singletons before registering core and feature layers.
Future<void> initServiceLocator() async {
  // ---------------------------------------------------------------------------
  // 1. External Third-Party Singletons
  // ---------------------------------------------------------------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

  // ---------------------------------------------------------------------------
  // 2. Core Infrastructure & Networking
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<DioClient>(() => DioClient(networkInfo: sl()));
  sl.registerLazySingleton<ApiClient>(() => ApiClientImpl(dioClient: sl()));

  // ---------------------------------------------------------------------------
  // 3. Core Storage & Database Services
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<PreferencesService>(() => PreferencesServiceImpl(sl()));
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageServiceImpl(sl()));
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelperImpl());

  // ---------------------------------------------------------------------------
  // 4. Core Audio Engine
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<AudioPlayerHandler>(() => AudioPlayerHandlerImpl());

  // ---------------------------------------------------------------------------
  // 5. Modular Feature Dependencies
  // ---------------------------------------------------------------------------
  _initFeatureModules();
}

void _initFeatureModules() {
  // Splash Feature
  sl.registerLazySingleton<CheckInitialAppStateUseCase>(
    () => CheckInitialAppStateUseCase(
      preferencesService: sl(),
      databaseHelper: sl(),
    ),
  );
  sl.registerFactory<SplashCubit>(
    () => SplashCubit(checkInitialAppStateUseCase: sl()),
  );

  // Onboarding Feature
  sl.registerLazySingleton<CompleteOnboardingUseCase>(
    () => CompleteOnboardingUseCase(preferencesService: sl()),
  );
  sl.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(completeOnboardingUseCase: sl()),
  );
}
