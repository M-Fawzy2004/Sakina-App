import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/inaba_overview_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/add_custom_good_deed_usecase.dart';
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
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_state.dart';

class MockGetInabaOverviewUseCase extends Mock
    implements GetInabaOverviewUseCase {}

class MockGetGoodDeedsUseCase extends Mock implements GetGoodDeedsUseCase {}

class MockToggleGoodDeedUseCase extends Mock
    implements ToggleGoodDeedUseCase {}

class MockAddCustomGoodDeedUseCase extends Mock
    implements AddCustomGoodDeedUseCase {}

class MockGetDailyHopeDosesUseCase extends Mock
    implements GetDailyHopeDosesUseCase {}

class MockToggleSaveHopeDoseUseCase extends Mock
    implements ToggleSaveHopeDoseUseCase {}

class MockGetSpiritualLevelsUseCase extends Mock
    implements GetSpiritualLevelsUseCase {}

class MockGetSpiritualReflectionsUseCase extends Mock
    implements GetSpiritualReflectionsUseCase {}

class MockSaveSpiritualReflectionUseCase extends Mock
    implements SaveSpiritualReflectionUseCase {}

class MockDeleteSpiritualReflectionUseCase extends Mock
    implements DeleteSpiritualReflectionUseCase {}

class MockGetRepentanceStepsUseCase extends Mock
    implements GetRepentanceStepsUseCase {}

class MockToggleRepentanceStepUseCase extends Mock
    implements ToggleRepentanceStepUseCase {}

class MockRenewCovenantUseCase extends Mock implements RenewCovenantUseCase {}

class MockLogSpiritualVictoryUseCase extends Mock
    implements LogSpiritualVictoryUseCase {}

void main() {
  late InabaCubit cubit;
  late MockGetInabaOverviewUseCase mockGetInabaOverview;
  late MockGetGoodDeedsUseCase mockGetGoodDeeds;
  late MockToggleGoodDeedUseCase mockToggleGoodDeed;
  late MockAddCustomGoodDeedUseCase mockAddCustomGoodDeed;
  late MockGetDailyHopeDosesUseCase mockGetDailyHopeDoses;
  late MockToggleSaveHopeDoseUseCase mockToggleSaveHopeDose;
  late MockGetSpiritualLevelsUseCase mockGetSpiritualLevels;
  late MockGetSpiritualReflectionsUseCase mockGetSpiritualReflections;
  late MockSaveSpiritualReflectionUseCase mockSaveSpiritualReflection;
  late MockDeleteSpiritualReflectionUseCase mockDeleteSpiritualReflection;
  late MockGetRepentanceStepsUseCase mockGetRepentanceSteps;
  late MockToggleRepentanceStepUseCase mockToggleRepentanceStep;
  late MockRenewCovenantUseCase mockRenewCovenant;
  late MockLogSpiritualVictoryUseCase mockLogSpiritualVictory;

  final testOverview = InabaOverviewEntity(
    streakDays: 14,
    bestStreakDays: 21,
    streakProgress: 0.70,
    totalGoodDeedsCompleted: 42,
    totalReflectionsCount: 3,
    currentSpiritualLevelTitle: 'الالتزام',
    recoveryPathStatus: 'حتى الآن في طريق النقاء',
    lastTawbahDate: DateTime(2026, 10, 15),
  );

  setUp(() {
    mockGetInabaOverview = MockGetInabaOverviewUseCase();
    mockGetGoodDeeds = MockGetGoodDeedsUseCase();
    mockToggleGoodDeed = MockToggleGoodDeedUseCase();
    mockAddCustomGoodDeed = MockAddCustomGoodDeedUseCase();
    mockGetDailyHopeDoses = MockGetDailyHopeDosesUseCase();
    mockToggleSaveHopeDose = MockToggleSaveHopeDoseUseCase();
    mockGetSpiritualLevels = MockGetSpiritualLevelsUseCase();
    mockGetSpiritualReflections = MockGetSpiritualReflectionsUseCase();
    mockSaveSpiritualReflection = MockSaveSpiritualReflectionUseCase();
    mockDeleteSpiritualReflection = MockDeleteSpiritualReflectionUseCase();
    mockGetRepentanceSteps = MockGetRepentanceStepsUseCase();
    mockToggleRepentanceStep = MockToggleRepentanceStepUseCase();
    mockRenewCovenant = MockRenewCovenantUseCase();
    mockLogSpiritualVictory = MockLogSpiritualVictoryUseCase();

    cubit = InabaCubit(
      getInabaOverviewUseCase: mockGetInabaOverview,
      getGoodDeedsUseCase: mockGetGoodDeeds,
      toggleGoodDeedUseCase: mockToggleGoodDeed,
      addCustomGoodDeedUseCase: mockAddCustomGoodDeed,
      getDailyHopeDosesUseCase: mockGetDailyHopeDoses,
      toggleSaveHopeDoseUseCase: mockToggleSaveHopeDose,
      getSpiritualLevelsUseCase: mockGetSpiritualLevels,
      getSpiritualReflectionsUseCase: mockGetSpiritualReflections,
      saveSpiritualReflectionUseCase: mockSaveSpiritualReflection,
      deleteSpiritualReflectionUseCase: mockDeleteSpiritualReflection,
      getRepentanceStepsUseCase: mockGetRepentanceSteps,
      toggleRepentanceStepUseCase: mockToggleRepentanceStep,
      renewCovenantUseCase: mockRenewCovenant,
      logSpiritualVictoryUseCase: mockLogSpiritualVictory,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('InabaCubit', () {
    test('initial state has InabaStatus.initial', () {
      expect(cubit.state.status, InabaStatus.initial);
      expect(cubit.state.overview, isNull);
    });

    test('loadInabaData successfully populates state with all domain entities',
        () async {
      when(() => mockGetInabaOverview(const NoParams()))
          .thenAnswer((_) async => Right(testOverview));
      when(() => mockGetGoodDeeds(const NoParams()))
          .thenAnswer((_) async => const Right([]));
      when(() => mockGetDailyHopeDoses(const NoParams()))
          .thenAnswer((_) async => const Right([]));
      when(() => mockGetSpiritualLevels(const NoParams()))
          .thenAnswer((_) async => const Right([]));
      when(() => mockGetSpiritualReflections(const NoParams()))
          .thenAnswer((_) async => const Right([]));
      when(() => mockGetRepentanceSteps(const NoParams()))
          .thenAnswer((_) async => const Right([]));

      await cubit.loadInabaData();

      expect(cubit.state.status, InabaStatus.loaded);
      expect(cubit.state.overview, testOverview);
    });

    test('unlock and lock confession sanctuary toggles isConfessionUnlocked',
        () {
      expect(cubit.state.isConfessionUnlocked, false);
      cubit.unlockConfessionSanctuary();
      expect(cubit.state.isConfessionUnlocked, true);
      cubit.lockConfessionSanctuary();
      expect(cubit.state.isConfessionUnlocked, false);
    });
  });
}

