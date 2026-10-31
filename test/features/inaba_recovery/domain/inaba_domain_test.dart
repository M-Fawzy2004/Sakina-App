import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/inaba_overview_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/get_inaba_overview_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/log_spiritual_victory_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/renew_covenant_usecase.dart';

class MockInabaRepository extends Mock implements InabaRepository {}

void main() {
  late MockInabaRepository mockRepository;
  late GetInabaOverviewUseCase getInabaOverviewUseCase;
  late RenewCovenantUseCase renewCovenantUseCase;
  late LogSpiritualVictoryUseCase logSpiritualVictoryUseCase;

  final testOverview = InabaOverviewEntity(
    streakDays: 14,
    bestStreakDays: 21,
    streakProgress: 0.70,
    totalGoodDeedsCompleted: 42,
    totalReflectionsCount: 5,
    currentSpiritualLevelTitle: 'الالتزام',
    recoveryPathStatus: 'حتى الآن في طريق النقاء',
    lastTawbahDate: DateTime(2026, 10, 15),
  );

  setUp(() {
    mockRepository = MockInabaRepository();
    getInabaOverviewUseCase = GetInabaOverviewUseCase(mockRepository);
    renewCovenantUseCase = RenewCovenantUseCase(mockRepository);
    logSpiritualVictoryUseCase = LogSpiritualVictoryUseCase(mockRepository);
  });

  group('Inaba Domain UseCases', () {
    test('GetInabaOverviewUseCase returns InabaOverviewEntity on success',
        () async {
      when(() => mockRepository.getInabaOverview())
          .thenAnswer((_) async => Right(testOverview));

      final result = await getInabaOverviewUseCase(const NoParams());

      expect(result, Right(testOverview));
      verify(() => mockRepository.getInabaOverview()).called(1);
    });

    test('GetInabaOverviewUseCase returns CacheFailure on repository error',
        () async {
      const failure = CacheFailure(message: 'Error fetching inaba');
      when(() => mockRepository.getInabaOverview())
          .thenAnswer((_) async => const Left(failure));

      final result = await getInabaOverviewUseCase(const NoParams());

      expect(result, const Left(failure));
      verify(() => mockRepository.getInabaOverview()).called(1);
    });

    test('RenewCovenantUseCase delegates to repository.renewCovenant',
        () async {
      final renewedOverview = testOverview.copyWith(streakDays: 1);
      when(() => mockRepository.renewCovenant())
          .thenAnswer((_) async => Right(renewedOverview));

      final result = await renewCovenantUseCase(const NoParams());

      expect(result, Right(renewedOverview));
      verify(() => mockRepository.renewCovenant()).called(1);
    });

    test('LogSpiritualVictoryUseCase delegates to repository.logSpiritualVictory',
        () async {
      final victoryOverview = testOverview.copyWith(streakDays: 15);
      when(() => mockRepository.logSpiritualVictory())
          .thenAnswer((_) async => Right(victoryOverview));

      final result = await logSpiritualVictoryUseCase(const NoParams());

      expect(result, Right(victoryOverview));
      verify(() => mockRepository.logSpiritualVictory()).called(1);
    });
  });
}

