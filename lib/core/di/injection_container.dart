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
import 'package:sakina_app/features/athkar/data/datasources/athkar_local_data_source.dart';
import 'package:sakina_app/features/athkar/data/repositories/athkar_repository_impl.dart';
import 'package:sakina_app/features/athkar/domain/repositories/athkar_repository.dart';
import 'package:sakina_app/features/athkar/domain/usecases/get_athkar_by_category_usecase.dart';
import 'package:sakina_app/features/athkar/domain/usecases/get_athkar_categories_usecase.dart';
import 'package:sakina_app/features/athkar/presentation/cubit/athkar_cubit.dart';
import 'package:sakina_app/features/hisn_muslim/data/datasources/hisn_local_data_source.dart';
import 'package:sakina_app/features/hisn_muslim/data/repositories/hisn_repository_impl.dart';
import 'package:sakina_app/features/hisn_muslim/domain/repositories/hisn_repository.dart';
import 'package:sakina_app/features/hisn_muslim/domain/usecases/get_hisn_chapter_detail_usecase.dart';
import 'package:sakina_app/features/hisn_muslim/domain/usecases/get_hisn_chapters_usecase.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/cubit/hisn_cubit.dart';
import 'package:sakina_app/features/istighfar/di/istighfar_di.dart';
import 'package:sakina_app/features/sunnah_books/data/datasources/sunnah_local_data_source.dart';
import 'package:sakina_app/features/sunnah_books/data/repositories/sunnah_repository_impl.dart';
import 'package:sakina_app/features/sunnah_books/domain/repositories/sunnah_repository.dart';
import 'package:sakina_app/features/sunnah_books/domain/usecases/get_book_hadiths_usecase.dart';
import 'package:sakina_app/features/sunnah_books/domain/usecases/get_sunnah_books_usecase.dart';
import 'package:sakina_app/features/sunnah_books/domain/usecases/search_hadiths_usecase.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/book_reader_cubit.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/sunnah_books_cubit.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sakina_app/core/services/security/biometric_auth_service.dart';
import 'package:sakina_app/features/inaba_recovery/data/datasources/inaba_local_data_source.dart';
import 'package:sakina_app/features/inaba_recovery/data/datasources/inaba_recovery_plans_local_data_source.dart';
import 'package:sakina_app/features/inaba_recovery/domain/services/mihrab_pin_service.dart';
import 'package:sakina_app/features/inaba_recovery/data/repositories/inaba_repository_impl.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/activate_recovery_path_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/add_custom_good_deed_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/advance_active_day_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/delete_spiritual_reflection_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/get_daily_hope_doses_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/get_good_deeds_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/get_inaba_overview_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/get_repentance_steps_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/get_spiritual_levels_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/get_spiritual_reflections_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/log_spiritual_victory_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/renew_covenant_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/save_spiritual_reflection_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/toggle_good_deed_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/toggle_repentance_step_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/toggle_save_hope_dose_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_cubit.dart';
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
import 'package:sakina_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:sakina_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:sakina_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:sakina_app/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:sakina_app/features/settings/domain/usecases/set_theme_mode_usecase.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_cubit.dart';
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
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // ---------------------------------------------------------------------------
  // 2. Core Infrastructure & Networking
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<DioClient>(() => DioClient(networkInfo: sl()));
  sl.registerLazySingleton<ApiClient>(() => ApiClientImpl(dioClient: sl()));

  // ---------------------------------------------------------------------------
  // 3. Core Storage & Database Services
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<PreferencesService>(
    () => PreferencesServiceImpl(sl()),
  );
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(sl()),
  );
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

  // Al-Mushaf (Holy Quran Reading) Feature - 100% Offline Local-First
  sl.registerLazySingleton<QuranLocalDataSource>(
    () => QuranLocalDataSourceImpl(preferencesService: sl()),
  );
  sl.registerLazySingleton<QuranRepository>(
    () => QuranRepositoryImpl(
      localDataSource: sl(),
    ),
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
  sl.registerLazySingleton<QuranCubit>(
    () => QuranCubit(
      getSurahsUseCase: sl(),
      getJuzsUseCase: sl(),
      getSurahVersesUseCase: sl(),
      getLastReadBookmarkUseCase: sl(),
      saveLastReadBookmarkUseCase: sl(),
      audioPlayerHandler: sl(),
      preferencesService: sl(),
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

  // Al-I'dadat (Settings & Preferences) Feature
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(preferencesService: sl()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetThemeModeUseCase>(
    () => GetThemeModeUseCase(repository: sl()),
  );
  sl.registerLazySingleton<SetThemeModeUseCase>(
    () => SetThemeModeUseCase(repository: sl()),
  );
  sl.registerLazySingleton<SettingsCubit>(
    () => SettingsCubit(
      getThemeModeUseCase: sl(),
      setThemeModeUseCase: sl(),
      repository: sl(),
    )..loadSettings(),
  );

  // Al-Inaba (Spiritual Recovery & Repentance) Feature
  sl.registerLazySingleton<InabaLocalDataSource>(
    () => InabaLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<InabaRepository>(
    () => InabaRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetInabaOverviewUseCase>(() => GetInabaOverviewUseCase(sl()));
  sl.registerLazySingleton<GetGoodDeedsUseCase>(() => GetGoodDeedsUseCase(sl()));
  sl.registerLazySingleton<ToggleGoodDeedUseCase>(() => ToggleGoodDeedUseCase(sl()));
  sl.registerLazySingleton<AddCustomGoodDeedUseCase>(() => AddCustomGoodDeedUseCase(sl()));
  sl.registerLazySingleton<GetDailyHopeDosesUseCase>(() => GetDailyHopeDosesUseCase(sl()));
  sl.registerLazySingleton<ToggleSaveHopeDoseUseCase>(() => ToggleSaveHopeDoseUseCase(sl()));
  sl.registerLazySingleton<GetSpiritualLevelsUseCase>(() => GetSpiritualLevelsUseCase(sl()));
  sl.registerLazySingleton<GetSpiritualReflectionsUseCase>(() => GetSpiritualReflectionsUseCase(sl()));
  sl.registerLazySingleton<SaveSpiritualReflectionUseCase>(() => SaveSpiritualReflectionUseCase(sl()));
  sl.registerLazySingleton<DeleteSpiritualReflectionUseCase>(() => DeleteSpiritualReflectionUseCase(sl()));
  sl.registerLazySingleton<GetRepentanceStepsUseCase>(() => GetRepentanceStepsUseCase(sl()));
  sl.registerLazySingleton<ToggleRepentanceStepUseCase>(() => ToggleRepentanceStepUseCase(sl()));
  sl.registerLazySingleton<RenewCovenantUseCase>(() => RenewCovenantUseCase(sl()));
  sl.registerLazySingleton<LogSpiritualVictoryUseCase>(() => LogSpiritualVictoryUseCase(sl()));
  sl.registerLazySingleton<ActivateRecoveryPathUseCase>(() => ActivateRecoveryPathUseCase(sl()));
  sl.registerLazySingleton<AdvanceActiveDayUseCase>(() => AdvanceActiveDayUseCase(sl()));
  sl.registerLazySingleton<MihrabPinService>(
    () => MihrabPinServiceImpl(sl()),
  );
  sl.registerLazySingleton<InabaRecoveryPlansLocalDataSource>(
    () => InabaRecoveryPlansLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());
  sl.registerLazySingleton<BiometricAuthService>(
    () => BiometricAuthServiceImpl(sl()),
  );
  sl.registerFactory<InabaCubit>(
    () => InabaCubit(
      getInabaOverviewUseCase: sl(),
      getGoodDeedsUseCase: sl(),
      toggleGoodDeedUseCase: sl(),
      addCustomGoodDeedUseCase: sl(),
      getDailyHopeDosesUseCase: sl(),
      toggleSaveHopeDoseUseCase: sl(),
      getSpiritualLevelsUseCase: sl(),
      getSpiritualReflectionsUseCase: sl(),
      saveSpiritualReflectionUseCase: sl(),
      deleteSpiritualReflectionUseCase: sl(),
      getRepentanceStepsUseCase: sl(),
      toggleRepentanceStepUseCase: sl(),
      renewCovenantUseCase: sl(),
      logSpiritualVictoryUseCase: sl(),
      activateRecoveryPathUseCase: sl(),
      advanceActiveDayUseCase: sl(),
      mihrabPinService: sl(),
      recoveryPlansLocalDataSource: sl(),
      biometricAuthService: sl(),
    ),
  );

  // Al-Athkar (Prophetic Supplications & Digital Tasbih) Feature
  sl.registerLazySingleton<AthkarLocalDataSource>(
    () => AthkarLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<AthkarRepository>(
    () => AthkarRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetAthkarCategoriesUseCase>(
    () => GetAthkarCategoriesUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetAthkarByCategoryUseCase>(
    () => GetAthkarByCategoryUseCase(repository: sl()),
  );
  sl.registerLazySingleton<AthkarCubit>(
    () => AthkarCubit(
      getCategoriesUseCase: sl(),
      getAthkarByCategoryUseCase: sl(),
    ),
  );

  // Hisn al-Muslim (Fortress of the Muslim) Feature
  sl.registerLazySingleton<HisnLocalDataSource>(
    () => HisnLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<HisnRepository>(
    () => HisnRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetHisnChaptersUseCase>(
    () => GetHisnChaptersUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetHisnChapterDetailUseCase>(
    () => GetHisnChapterDetailUseCase(repository: sl()),
  );
  sl.registerLazySingleton<HisnCubit>(
    () => HisnCubit(
      getChaptersUseCase: sl(),
      repository: sl(),
    ),
  );

  // Sunnah Books (Kutub al-Tis'ah) Feature
  sl.registerLazySingleton<SunnahLocalDataSource>(
    () => SunnahLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<SunnahRepository>(
    () => SunnahRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetSunnahBooksUseCase>(
    () => GetSunnahBooksUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetBookHadithsUseCase>(
    () => GetBookHadithsUseCase(repository: sl()),
  );
  sl.registerLazySingleton<SearchHadithsUseCase>(
    () => SearchHadithsUseCase(repository: sl()),
  );
  sl.registerLazySingleton<SunnahBooksCubit>(
    () => SunnahBooksCubit(getBooksUseCase: sl()),
  );
  sl.registerFactory<BookReaderCubit>(
    () => BookReaderCubit(
      getHadithsUseCase: sl(),
      searchHadithsUseCase: sl(),
    ),
  );

  // Istighfar & Digital Sibha Feature
  initIstighfarDI(sl);
}
