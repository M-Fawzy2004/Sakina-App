import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/inaba_overview_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_recovery_plan_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/activate_recovery_path_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/advance_active_day_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/get_inaba_overview_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/log_spiritual_victory_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/renew_covenant_usecase.dart';

class MockInabaRepository extends Mock implements InabaRepository {}

void main() {
  late MockInabaRepository mockRepository;
  late GetInabaOverviewUseCase getInabaOverviewUseCase;
  late RenewCovenantUseCase renewCovenantUseCase;
  late LogSpiritualVictoryUseCase logSpiritualVictoryUseCase;
  late ActivateRecoveryPathUseCase activateRecoveryPathUseCase;
  late AdvanceActiveDayUseCase advanceActiveDayUseCase;

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
    activateRecoveryPathUseCase = ActivateRecoveryPathUseCase(mockRepository);
    advanceActiveDayUseCase = AdvanceActiveDayUseCase(mockRepository);
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

    test('ActivateRecoveryPathUseCase delegates to repository.activateRecoveryPath',
        () async {
      final activatedOverview = testOverview.copyWith(isPathActivated: true);
      when(() => mockRepository.activateRecoveryPath())
          .thenAnswer((_) async => Right(activatedOverview));

      final result = await activateRecoveryPathUseCase(const NoParams());

      expect(result, Right(activatedOverview));
      verify(() => mockRepository.activateRecoveryPath()).called(1);
    });

    test('AdvanceActiveDayUseCase delegates to repository.advanceActiveDay',
        () async {
      final advancedOverview = testOverview.copyWith(currentActiveDay: 2);
      when(() => mockRepository.advanceActiveDay())
          .thenAnswer((_) async => Right(advancedOverview));

      final result = await advanceActiveDayUseCase(const NoParams());

      expect(result, Right(advancedOverview));
      verify(() => mockRepository.advanceActiveDay()).called(1);
    });

    test('SpiritualRecoveryPlanEntity strictly enforces 1 day completion per calendar day', () {
      final now = DateTime(2026, 11, 6, 12, 0);
      final step1CompletedToday = RecoveryPlanDayStepEntity(
        dayNumber: 1,
        title: 'Step 1',
        practicalAction: 'Action 1',
        recommendedDhikr: 'Dhikr 1',
        scripturalEvidence: 'Evidence 1',
        isCompleted: true,
        completedAt: now,
      );
      const step2 = RecoveryPlanDayStepEntity(
        dayNumber: 2,
        title: 'Step 2',
        practicalAction: 'Action 2',
        recommendedDhikr: 'Dhikr 2',
        scripturalEvidence: 'Evidence 2',
        isCompleted: false,
      );

      final plan = SpiritualRecoveryPlanEntity(
        id: 'plan_7_days',
        title: 'Plan',
        badge: 'Badge',
        durationText: '7 days',
        description: 'Desc',
        iconKey: 'sun',
        steps: [step1CompletedToday, step2],
      );

      // On the same day: step 1 is completed today, step 2 is locked until tomorrow
      expect(step1CompletedToday.isCompletedToday, isTrue);
      expect(plan.isStepUnlocked(2, now: now), isFalse);
      expect(plan.isStepLockedUntilTomorrow(2, now: now), isTrue);

      // On the next calendar day (tomorrow): step 2 unlocks!
      final tomorrow = DateTime(2026, 11, 7, 9, 0);
      expect(plan.isStepUnlocked(2, now: tomorrow), isTrue);
      expect(plan.isStepLockedUntilTomorrow(2, now: tomorrow), isFalse);
    });
  });
}

