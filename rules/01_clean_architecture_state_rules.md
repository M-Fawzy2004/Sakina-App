# CLEAN ARCHITECTURE & STATE MANAGEMENT SPECIFICATION
**Architecture Style:** Feature-First Clean Architecture (Uncle Bob + Reso Coder Enterprise Standard)  
**State Management:** BLoC / Cubit (`flutter_bloc`)  
**Functional Error Handling:** `fpdart` (`Either<Failure, T>`)  
**Dependency Injection:** `get_it` + `injectable`

---

## 1. FEATURE DIRECTORY STRUCTURE
Every feature in `lib/features/<feature_name>/` must strictly adhere to the following layer separation:

```
lib/features/<feature_name>/
├── data/
│   ├── datasources/
│   │   ├── <feature_name>_remote_data_source.dart
│   │   └── <feature_name>_local_data_source.dart
│   ├── models/
│   │   └── <entity_name>_model.dart (JSON/DB DTO mapping to/from Entity)
│   └── repositories/
│       └── <feature_name>_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── <entity_name>.dart (Immutable Pure Dart Data Class)
│   ├── failures/
│   │   └── <feature_name>_failure.dart (Domain-specific Failure sub-types)
│   ├── repositories/
│   │   └── <feature_name>_repository.dart (Abstract Contract)
│   └── usecases/
│       └── get_<entity_name>_usecase.dart (Single Responsibility Unit)
└── presentation/
    ├── cubit/ (or bloc/)
    │   ├── <feature_name>_cubit.dart
    │   └── <feature_name>_state.dart (Freezed union states)
    └── widgets/
        ├── <feature_name>_screen.dart (Scaffold & Base View - Must be < 400 lines)
        └── components/
            ├── <sub_widget>_card.dart (Modular atomic widgets - Each < 400 lines)
            └── <sub_widget>_shimmer.dart
```

---

## 2. MODULARITY & FILE SIZE CONSTRAINT (< 400 LINES)
- **Strict File Length Boundary:** No file across domain, data, or presentation may exceed **400 lines of code** (LOC).
- **Legitimate Exceptions:** The only permitted exceptions are immutable static seed dictionaries or Quranic mapping tables (e.g. 114 Surah reference coordinates or 60 Hizb quarter offsets).
- **Decomposition Mandate:**
  - Whenever a Screen, Modal Sheet, or CustomPainter grows past 350-400 lines, it **must** be decomposed immediately into focused sub-widgets inside `widgets/components/` (or sub-folders).
  - Multi-section sheets (e.g., Reader Settings, Audio Controls) must have each section in its own `_section.dart` component.
  - Complex custom painters or canvas effects must reside in their own standalone painter file.

---

## 3. LAYER BOUNDARY RULES

### Domain Layer (Core & Indestructible)
- **Zero Third-Party Dependencies:** Strictly pure Dart. No imports from `package:flutter/material.dart`, Dio, Sqflite, Hive, or device APIs. Only pure Dart, `equatable`, and `fpdart`.
- **Entities:** Must be immutable. Extend `Equatable` or use `@freezed`.
- **Core UseCase Contract:**
  ```dart
  import 'package:fpdart/fpdart.dart';
  import 'package:sakina_app/core/errors/failures.dart';

  abstract interface class UseCase<Type, Params> {
    Future<Either<Failure, Type>> call(Params params);
  }

  class NoParams extends Equatable {
    const NoParams();
    @override
    List<Object?> get props => [];
  }
  ```

### Data Layer (Adapters & Infrastructure)
- **Data Transfer Objects (DTOs / Models):** Must extend their respective domain Entities and provide explicit conversion methods:
  ```dart
  class SurahModel extends SurahEntity {
    const SurahModel({required super.id, required super.nameArabic, required super.versesCount});

    factory SurahModel.fromJson(Map<String, dynamic> json) => SurahModel(
      id: json['id'] as int,
      nameArabic: json['name_arabic'] as String,
      versesCount: json['verses_count'] as int,
    );

    Map<String, dynamic> toJson() => {
      'id': id,
      'name_arabic': nameArabic,
      'verses_count': versesCount,
    };

    SurahEntity toEntity() => SurahEntity(id: id, nameArabic: nameArabic, versesCount: versesCount);
  }
  ```
- **Data Sources:** Must throw typed exceptions (`ServerException`, `CacheException`, `NetworkException`).
- **Repositories Implementation:** Responsible for catching raw exceptions and transforming them into domain `Failure` objects:
  ```dart
  class QuranRepositoryImpl implements QuranRepository {
    final QuranRemoteDataSource remoteDataSource;
    final QuranLocalDataSource localDataSource;

    const QuranRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

    @override
    Future<Either<Failure, List<SurahEntity>>> getSurahs() async {
      try {
        final localData = await localDataSource.getCachedSurahs();
        if (localData.isNotEmpty) {
          return Right(localData.map((m) => m.toEntity()).toList());
        }
        final remoteData = await remoteDataSource.fetchSurahs();
        await localDataSource.cacheSurahs(remoteData);
        return Right(remoteData.map((m) => m.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      } catch (e) {
        return Left(UnexpectedFailure(message: e.toString()));
      }
    }
  }
  ```

### Presentation Layer (Reactive & Declarative)
- **No Direct Data Layer Access:** UI components and Cubits must interact exclusively with Domain Use Cases.
- **State Emitted via Freezed Unions:**
  ```dart
  @freezed
  class QuranState with _$QuranState {
    const factory QuranState.initial() = _Initial;
    const factory QuranState.loading() = _Loading;
    const factory QuranState.loaded({required List<SurahEntity> surahs}) = _Loaded;
    const factory QuranState.failure({required String errorMessage}) = _Failure;
  }
  ```
- **BlocProvider Scope:** Inject BLoCs at the lowest possible widget subtree. Never pollute the global `MaterialApp` root unnecessarily.

---

## 3. DEPENDENCY INJECTION RULES
- Every dependency must be registered in the service locator (`GetIt.instance`).
- Group registrations modularly per feature to prevent a bloated central file:
  ```dart
  void initQuranFeature(GetIt sl) {
    // Data sources
    sl.registerLazySingleton<QuranRemoteDataSource>(() => QuranRemoteDataSourceImpl(client: sl()));
    sl.registerLazySingleton<QuranLocalDataSource>(() => QuranLocalDataSourceImpl(database: sl()));

    // Repository
    sl.registerLazySingleton<QuranRepository>(
      () => QuranRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
    );

    // Use cases
    sl.registerLazySingleton(() => GetSurahsUseCase(sl()));

    // Cubit (Factory: new instance per lifecycle)
    sl.registerFactory(() => QuranCubit(getSurahsUseCase: sl()));
  }
  ```

