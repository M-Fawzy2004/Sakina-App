import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/daily_hope_dose_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/good_deed_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/inaba_overview_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/repentance_step_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_level_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_recovery_plan_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_reflection_entity.dart';

enum InabaStatus { initial, loading, loaded, error }

class InabaState extends Equatable {
  final InabaStatus status;
  final InabaOverviewEntity? overview;
  final List<GoodDeedEntity> goodDeeds;
  final List<DailyHopeDoseEntity> hopeDoses;
  final int currentHopeDoseIndex;
  final List<SpiritualLevelEntity> spiritualLevels;
  final List<SpiritualReflectionEntity> reflections;
  final List<RepentanceStepEntity> repentanceSteps;
  final List<SpiritualRecoveryPlanEntity> recoveryPlans;
  final bool hasMihrabPin;
  final bool isConfessionUnlocked;
  final String? errorMessage;
  final String? toastFeedback;

  const InabaState({
    this.status = InabaStatus.initial,
    this.overview,
    this.goodDeeds = const [],
    this.hopeDoses = const [],
    this.currentHopeDoseIndex = 0,
    this.spiritualLevels = const [],
    this.reflections = const [],
    this.repentanceSteps = const [],
    this.recoveryPlans = const [],
    this.hasMihrabPin = false,
    this.isConfessionUnlocked = false,
    this.errorMessage,
    this.toastFeedback,
  });

  DailyHopeDoseEntity? get activeHopeDose {
    if (hopeDoses.isEmpty) return null;
    final index = currentHopeDoseIndex.clamp(0, hopeDoses.length - 1);
    return hopeDoses[index];
  }

  InabaState copyWith({
    InabaStatus? status,
    InabaOverviewEntity? overview,
    List<GoodDeedEntity>? goodDeeds,
    List<DailyHopeDoseEntity>? hopeDoses,
    int? currentHopeDoseIndex,
    List<SpiritualLevelEntity>? spiritualLevels,
    List<SpiritualReflectionEntity>? reflections,
    List<RepentanceStepEntity>? repentanceSteps,
    List<SpiritualRecoveryPlanEntity>? recoveryPlans,
    bool? hasMihrabPin,
    bool? isConfessionUnlocked,
    String? errorMessage,
    String? toastFeedback,
  }) {
    return InabaState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      goodDeeds: goodDeeds ?? this.goodDeeds,
      hopeDoses: hopeDoses ?? this.hopeDoses,
      currentHopeDoseIndex: currentHopeDoseIndex ?? this.currentHopeDoseIndex,
      spiritualLevels: spiritualLevels ?? this.spiritualLevels,
      reflections: reflections ?? this.reflections,
      repentanceSteps: repentanceSteps ?? this.repentanceSteps,
      recoveryPlans: recoveryPlans ?? this.recoveryPlans,
      hasMihrabPin: hasMihrabPin ?? this.hasMihrabPin,
      isConfessionUnlocked: isConfessionUnlocked ?? this.isConfessionUnlocked,
      errorMessage: errorMessage,
      toastFeedback: toastFeedback,
    );
  }

  @override
  List<Object?> get props => [
        status,
        overview,
        goodDeeds,
        hopeDoses,
        currentHopeDoseIndex,
        spiritualLevels,
        reflections,
        repentanceSteps,
        recoveryPlans,
        hasMihrabPin,
        isConfessionUnlocked,
        errorMessage,
        toastFeedback,
      ];
}

