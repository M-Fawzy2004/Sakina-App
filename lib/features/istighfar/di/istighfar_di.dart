import 'package:get_it/get_it.dart';
import 'package:sakina_app/features/istighfar/data/datasources/istighfar_local_data_source.dart';
import 'package:sakina_app/features/istighfar/data/repositories/istighfar_repository_impl.dart';
import 'package:sakina_app/features/istighfar/domain/repositories/istighfar_repository.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/get_istighfar_items_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/get_istighfar_stats_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/increment_istighfar_count_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/reset_istighfar_count_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/set_istighfar_target_usecase.dart';
import 'package:sakina_app/features/istighfar/presentation/cubit/istighfar_cubit.dart';

/// Dependency Injection module for the Istighfar & Digital Sibha feature.
void initIstighfarDI(GetIt sl) {
  // Data Source
  sl.registerLazySingleton<IstighfarLocalDataSource>(
    () => IstighfarLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<IstighfarRepository>(
    () => IstighfarRepositoryImpl(localDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton<GetIstighfarItemsUseCase>(
    () => GetIstighfarItemsUseCase(sl()),
  );
  sl.registerLazySingleton<IncrementIstighfarCountUseCase>(
    () => IncrementIstighfarCountUseCase(sl()),
  );
  sl.registerLazySingleton<ResetIstighfarCountUseCase>(
    () => ResetIstighfarCountUseCase(sl()),
  );
  sl.registerLazySingleton<GetIstighfarStatsUseCase>(
    () => GetIstighfarStatsUseCase(sl()),
  );
  sl.registerLazySingleton<SetIstighfarTargetUseCase>(
    () => SetIstighfarTargetUseCase(sl()),
  );

  // Presentation Cubit
  sl.registerFactory<IstighfarCubit>(
    () => IstighfarCubit(
      getItemsUseCase: sl(),
      incrementCountUseCase: sl(),
      resetCountUseCase: sl(),
      getStatsUseCase: sl(),
      setTargetUseCase: sl(),
      localDataSource: sl(),
    ),
  );
}

