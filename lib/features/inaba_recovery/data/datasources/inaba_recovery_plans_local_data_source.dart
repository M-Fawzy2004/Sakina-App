import 'dart:convert';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/inaba_recovery/data/datasources/static/inaba_recovery_plans_seed_data.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_recovery_plan_entity.dart';

/// Local data source managing structured spiritual recovery plans & milestone persistence.
abstract interface class InabaRecoveryPlansLocalDataSource {
  Future<List<SpiritualRecoveryPlanEntity>> getRecoveryPlans();
  Future<SpiritualRecoveryPlanEntity> togglePlanDayStep({
    required String planId,
    required int dayNumber,
  });
  Future<void> resetPlan(String planId);
}

class InabaRecoveryPlansLocalDataSourceImpl
    implements InabaRecoveryPlansLocalDataSource {
  final PreferencesService _prefs;

  static const String _keyPlans = 'sakina_inaba_recovery_plans_v2';

  const InabaRecoveryPlansLocalDataSourceImpl(this._prefs);

  @override
  Future<List<SpiritualRecoveryPlanEntity>> getRecoveryPlans() async {
    final raw = _prefs.getString(_keyPlans);
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        return list
            .map((item) => SpiritualRecoveryPlanEntity.fromJson(
                item as Map<String, dynamic>))
            .toList();
      } catch (_) {
        // Fallback to defaults
      }
    }
    final defaults = InabaRecoveryPlansSeedData.defaultPlans;
    await _savePlans(defaults);
    return defaults;
  }

  Future<void> _savePlans(List<SpiritualRecoveryPlanEntity> list) async {
    final raw = jsonEncode(list.map((p) => p.toJson()).toList());
    await _prefs.setString(_keyPlans, raw);
  }

  @override
  Future<SpiritualRecoveryPlanEntity> togglePlanDayStep({
    required String planId,
    required int dayNumber,
  }) async {
    final plans = await getRecoveryPlans();
    final planIndex = plans.indexWhere((p) => p.id == planId);
    if (planIndex == -1) {
      throw Exception('Plan not found: $planId');
    }

    final currentPlan = plans[planIndex];
    final updatedSteps = currentPlan.steps.map((s) {
      if (s.dayNumber == dayNumber) {
        return s.copyWith(isCompleted: !s.isCompleted);
      }
      return s;
    }).toList();

    final updatedPlan = currentPlan.copyWith(steps: updatedSteps);
    plans[planIndex] = updatedPlan;
    await _savePlans(plans);
    return updatedPlan;
  }

  @override
  Future<void> resetPlan(String planId) async {
    final plans = await getRecoveryPlans();
    final planIndex = plans.indexWhere((p) => p.id == planId);
    if (planIndex != -1) {
      final currentPlan = plans[planIndex];
      final resetSteps = currentPlan.steps
          .map((s) => s.copyWith(isCompleted: false))
          .toList();
      plans[planIndex] = currentPlan.copyWith(steps: resetSteps);
      await _savePlans(plans);
    }
  }
}

