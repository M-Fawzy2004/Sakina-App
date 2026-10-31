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
import 'package:sakina_app/features/audio_reciters/data/datasources/audio_reciters_local_data_source.dart';
import 'package:sakina_app/features/audio_reciters/data/repositories/audio_reciters_repository_impl.dart';
import 'package:sakina_app/features/audio_reciters/domain/repositories/audio_reciters_repository.dart';
import 'package:sakina_app/features/audio_reciters/domain/usecases/get_featured_reciter_usecase.dart';
import 'package:sakina_app/features/audio_reciters/domain/usecases/get_reciter_tracks_usecase.dart';
import 'package:sakina_app/features/audio_reciters/domain/usecases/get_reciters_usecase.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_cubit.dart';
import 'package:sakina_app/features/maladh/data/datasources/maladh_local_data_source.dart';
import 'package:sakina_app/features/maladh/data/repositories/maladh_repository_impl.dart';
import 'package:sakina_app/features/maladh/domain/repositories/maladh_repository.dart';
import 'package:sakina_app/features/maladh/domain/usecases/get_maladh_header_data_usecase.dart';
import 'package:sakina_app/features/maladh/presentation/cubit/maladh_cubit.dart';
import 'package:sakina_app/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:sakina_app/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/quran_local_data_source.dart';
import 'package:sakina_app/features/quran_reading/data/repositories/quran_repository_impl.dart';
import 'package:sakina_app/features/quran_reading/domain/repositories/quran_repository.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_juzs_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_last_read_bookmark_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_surah_verses_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_surahs_usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/save_last_read_bookmark_usecase.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_cubit.dart';
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

  // Al-Maladh (The Sanctuary) Feature
  sl.registerLazySingleton<MaladhLocalDataSource>(
    () => MaladhLocalDataSourceImpl(preferencesService: sl()),
  );
  sl.registerLazySingleton<MaladhRepository>(
    () => MaladhRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetMaladhHeaderDataUseCase>(
    () => GetMaladhHeaderDataUseCase(repository: sl()),
  );
  sl.registerFactory<MaladhCubit>(
    () => MaladhCubit(getMaladhHeaderDataUseCase: sl()),
  );

  // Al-Mushaf (Holy Quran Reading) Feature
  sl.registerLazySingleton<QuranLocalDataSource>(
    () => QuranLocalDataSourceImpl(preferencesService: sl()),
  );
  sl.registerLazySingleton<QuranRepository>(
    () => QuranRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetSurahsUseCase>(
    () => GetSurahsUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetJuzsUseCase>(
    () => GetJuzsUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetSurahVersesUseCase>(
    () => GetSurahVersesUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetLastReadBookmarkUseCase>(
    () => GetLastReadBookmarkUseCase(repository: sl()),
  );
  sl.registerLazySingleton<SaveLastReadBookmarkUseCase>(
    () => SaveLastReadBookmarkUseCase(repository: sl()),
  );
  sl.registerFactory<QuranCubit>(
    () => QuranCubit(
      getSurahsUseCase: sl(),
      getJuzsUseCase: sl(),
      getSurahVersesUseCase: sl(),
      getLastReadBookmarkUseCase: sl(),
      saveLastReadBookmarkUseCase: sl(),
    ),
  );

  // Al-Tilawat (Quran Recitations & Audio Player) Feature
  sl.registerLazySingleton<AudioRecitersLocalDataSource>(
    () => AudioRecitersLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<AudioRecitersRepository>(
    () => AudioRecitersRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetRecitersUseCase>(
    () => GetRecitersUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetFeaturedReciterUseCase>(
    () => GetFeaturedReciterUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetReciterTracksUseCase>(
    () => GetReciterTracksUseCase(repository: sl()),
  );
  sl.registerFactory<AudioRecitersCubit>(
    () => AudioRecitersCubit(
      getRecitersUseCase: sl(),
      getFeaturedReciterUseCase: sl(),
      getReciterTracksUseCase: sl(),
      audioPlayerHandler: sl(),
    ),
  );
}
