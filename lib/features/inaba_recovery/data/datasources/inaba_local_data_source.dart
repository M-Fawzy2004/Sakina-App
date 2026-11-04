import 'dart:convert';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/inaba_recovery/data/datasources/static/inaba_seed_data.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/daily_hope_dose_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/good_deed_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/inaba_overview_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/repentance_step_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/spiritual_level_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/spiritual_reflection_model.dart';

abstract interface class InabaLocalDataSource {
  Future<InabaOverviewModel> getInabaOverview();
  Future<List<GoodDeedModel>> getGoodDeeds();
  Future<GoodDeedModel> toggleGoodDeed(String id);
  Future<GoodDeedModel> addCustomGoodDeed(String title, String category);
  Future<List<DailyHopeDoseModel>> getHopeDoses();
  Future<DailyHopeDoseModel> toggleSaveHopeDose(String id);
  Future<List<SpiritualLevelModel>> getSpiritualLevels();
  Future<List<SpiritualReflectionModel>> getReflections();
  Future<SpiritualReflectionModel> saveReflection({
    required String title,
    required String content,
    required String moodTag,
  });
  Future<void> deleteReflection(String id);
  Future<void> clearAllReflections();
  Future<List<RepentanceStepModel>> getRepentanceSteps();
  Future<RepentanceStepModel> toggleRepentanceStep(String id);
  Future<InabaOverviewModel> renewCovenant();
  Future<InabaOverviewModel> logSpiritualVictory();
  Future<InabaOverviewModel> activateRecoveryPath();
  Future<InabaOverviewModel> advanceActiveDay();
}

class InabaLocalDataSourceImpl implements InabaLocalDataSource {
  final PreferencesService _prefs;

  static const String _keyOverview = 'sakina_inaba_overview_v2';
  static const String _keyGoodDeeds = 'sakina_inaba_good_deeds_v2';
  static const String _keyReflections = 'sakina_inaba_reflections_v2';
  static const String _keyHopeDoses = 'sakina_inaba_hope_doses_v2';
  static const String _keyRepentanceSteps = 'sakina_inaba_repentance_steps_v2';

  InabaLocalDataSourceImpl(this._prefs);

  @override
  Future<InabaOverviewModel> getInabaOverview() async {
    final raw = _prefs.getString(_keyOverview);
    if (raw != null && raw.isNotEmpty) {
      try {
        return InabaOverviewModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {}
    }
    final defaultOverview = InabaSeedData.defaultOverview;
    await _saveOverview(defaultOverview);
    return defaultOverview;
  }

  Future<void> _saveOverview(InabaOverviewModel model) async {
    await _prefs.setString(_keyOverview, jsonEncode(model.toJson()));
  }

  @override
  Future<List<GoodDeedModel>> getGoodDeeds() async {
    final raw = _prefs.getString(_keyGoodDeeds);
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        return list.map((item) => GoodDeedModel.fromJson(item as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    final seeds = InabaSeedData.goodDeeds;
    await _saveGoodDeeds(seeds);
    return seeds;
  }

  Future<void> _saveGoodDeeds(List<GoodDeedModel> list) async {
    await _prefs.setString(_keyGoodDeeds, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  @override
  Future<GoodDeedModel> toggleGoodDeed(String id) async {
    final deeds = await getGoodDeeds();
    final index = deeds.indexWhere((d) => d.id == id);
    if (index == -1) throw Exception('Good deed not found: $id');
    final current = deeds[index];
    final updated = GoodDeedModel(
      id: current.id,
      title: current.title,
      category: current.category,
      rewardDescription: current.rewardDescription,
      completionCount: current.isCompletedToday ? current.completionCount - 1 : current.completionCount + 1,
      isCompletedToday: !current.isCompletedToday,
      iconKey: current.iconKey,
    );
    deeds[index] = updated;
    await _saveGoodDeeds(deeds);

    final completedCount = deeds.where((d) => d.isCompletedToday).length;
    final overview = await getInabaOverview();
    await _saveOverview(InabaOverviewModel.fromEntity(overview.copyWith(totalGoodDeedsCompleted: completedCount)));
    return updated;
  }

  @override
  Future<GoodDeedModel> addCustomGoodDeed(String title, String category) async {
    final deeds = await getGoodDeeds();
    final newDeed = GoodDeedModel(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: category,
      rewardDescription: '«أحب الأعمال إلى الله أدومها وإن قل»',
      completionCount: 1,
      isCompletedToday: true,
      iconKey: 'star',
    );
    deeds.add(newDeed);
    await _saveGoodDeeds(deeds);

    final completedCount = deeds.where((d) => d.isCompletedToday).length;
    final overview = await getInabaOverview();
    await _saveOverview(InabaOverviewModel.fromEntity(overview.copyWith(totalGoodDeedsCompleted: completedCount)));
    return newDeed;
  }

  @override
  Future<List<DailyHopeDoseModel>> getHopeDoses() async {
    final raw = _prefs.getString(_keyHopeDoses);
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        return list.map((item) => DailyHopeDoseModel.fromJson(item as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    final seeds = InabaSeedData.hopeDoses;
    await _saveHopeDoses(seeds);
    return seeds;
  }

  Future<void> _saveHopeDoses(List<DailyHopeDoseModel> list) async {
    await _prefs.setString(_keyHopeDoses, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  @override
  Future<DailyHopeDoseModel> toggleSaveHopeDose(String id) async {
    final doses = await getHopeDoses();
    final index = doses.indexWhere((d) => d.id == id);
    if (index == -1) throw Exception('Hope dose not found: $id');
    final current = doses[index];
    final updated = DailyHopeDoseModel(
      id: current.id,
      quotation: current.quotation,
      source: current.source,
      explanation: current.explanation,
      isSaved: !current.isSaved,
    );
    doses[index] = updated;
    await _saveHopeDoses(doses);
    return updated;
  }

  @override
  Future<List<SpiritualLevelModel>> getSpiritualLevels() async {
    final overview = await getInabaOverview();
    return InabaSeedData.buildSpiritualLevels(overview.streakDays);
  }

  @override
  Future<List<SpiritualReflectionModel>> getReflections() async {
    final raw = _prefs.getString(_keyReflections);
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        return list.map((item) => SpiritualReflectionModel.fromJson(item as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    final seeds = InabaSeedData.reflections;
    await _saveReflections(seeds);
    return seeds;
  }

  Future<void> _saveReflections(List<SpiritualReflectionModel> list) async {
    await _prefs.setString(_keyReflections, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  @override
  Future<SpiritualReflectionModel> saveReflection({
    required String title,
    required String content,
    required String moodTag,
  }) async {
    final reflections = await getReflections();
    final newReflection = SpiritualReflectionModel(
      id: 'ref_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      content: content,
      createdAt: DateTime.now(),
      moodTag: moodTag,
    );
    reflections.insert(0, newReflection);
    await _saveReflections(reflections);

    final overview = await getInabaOverview();
    await _saveOverview(InabaOverviewModel.fromEntity(overview.copyWith(totalReflectionsCount: reflections.length)));
    return newReflection;
  }

  @override
  Future<void> deleteReflection(String id) async {
    final reflections = await getReflections();
    reflections.removeWhere((r) => r.id == id);
    await _saveReflections(reflections);

    final overview = await getInabaOverview();
    await _saveOverview(InabaOverviewModel.fromEntity(overview.copyWith(totalReflectionsCount: reflections.length)));
  }

  @override
  Future<void> clearAllReflections() async {
    await _saveReflections([]);
    final overview = await getInabaOverview();
    await _saveOverview(InabaOverviewModel.fromEntity(overview.copyWith(totalReflectionsCount: 0)));
  }

  @override
  Future<List<RepentanceStepModel>> getRepentanceSteps() async {
    final raw = _prefs.getString(_keyRepentanceSteps);
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        return list.map((item) => RepentanceStepModel.fromJson(item as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    final seeds = InabaSeedData.repentanceSteps;
    await _saveRepentanceSteps(seeds);
    return seeds;
  }

  Future<void> _saveRepentanceSteps(List<RepentanceStepModel> list) async {
    await _prefs.setString(_keyRepentanceSteps, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  @override
  Future<RepentanceStepModel> toggleRepentanceStep(String id) async {
    final steps = await getRepentanceSteps();
    final index = steps.indexWhere((s) => s.id == id);
    if (index == -1) throw Exception('Repentance step not found: $id');
    final current = steps[index];
    final updated = RepentanceStepModel(
      id: current.id,
      title: current.title,
      subtitle: current.subtitle,
      evidence: current.evidence,
      isCompleted: !current.isCompleted,
    );
    steps[index] = updated;
    await _saveRepentanceSteps(steps);
    return updated;
  }

  @override
  Future<InabaOverviewModel> renewCovenant() async {
    final steps = await getRepentanceSteps();
    final resetSteps = steps.map((s) => RepentanceStepModel(
      id: s.id,
      title: s.title,
      subtitle: s.subtitle,
      evidence: s.evidence,
      isCompleted: false,
    )).toList();
    await _saveRepentanceSteps(resetSteps);

    final currentOverview = await getInabaOverview();
    final best = currentOverview.streakDays > currentOverview.bestStreakDays
        ? currentOverview.streakDays
        : currentOverview.bestStreakDays;

    final updated = InabaOverviewModel.fromEntity(
      currentOverview.copyWith(
        streakDays: 0,
        bestStreakDays: best,
        streakProgress: 0.05,
        currentSpiritualLevelTitle: 'البداية',
        recoveryPathStatus: 'عهد جديد مع الله، وبداية نقية',
        lastTawbahDate: DateTime.now(),
        isPathActivated: true,
        currentActiveDay: 1,
      ),
    );
    await _saveOverview(updated);
    return updated;
  }

  @override
  Future<InabaOverviewModel> activateRecoveryPath() async {
    final currentOverview = await getInabaOverview();
    final updated = InabaOverviewModel.fromEntity(
      currentOverview.copyWith(
        isPathActivated: true,
        streakDays: 0,
        streakProgress: 0.05,
        currentActiveDay: 1,
        recoveryPathStatus: 'اليوم الأول: يقظة القلب وبداية التطهر',
        lastTawbahDate: DateTime.now(),
      ),
    );
    await _saveOverview(updated);
    return updated;
  }

  @override
  Future<InabaOverviewModel> advanceActiveDay() async {
    final currentOverview = await getInabaOverview();
    final nextDay = currentOverview.currentActiveDay + 1;
    final updatedDays = currentOverview.streakDays + 1;
    final best = updatedDays > currentOverview.bestStreakDays ? updatedDays : currentOverview.bestStreakDays;

    final updated = InabaOverviewModel.fromEntity(
      currentOverview.copyWith(
        streakDays: updatedDays,
        bestStreakDays: best,
        currentActiveDay: nextDay,
        streakProgress: ((updatedDays % 30) / 30.0).clamp(0.05, 1.0),
        recoveryPathStatus: 'اليوم $nextDay في طريق النقاء والثبات',
      ),
    );
    await _saveOverview(updated);
    return updated;
  }

  @override
  Future<InabaOverviewModel> logSpiritualVictory() async {
    final currentOverview = await getInabaOverview();
    final updatedDays = currentOverview.streakDays + 1;
    final best = updatedDays > currentOverview.bestStreakDays ? updatedDays : currentOverview.bestStreakDays;
    final progress = (updatedDays % 30) / 30.0;

    final updated = InabaOverviewModel.fromEntity(
      currentOverview.copyWith(
        streakDays: updatedDays,
        bestStreakDays: best,
        streakProgress: progress == 0 ? 1.0 : progress,
        totalGoodDeedsCompleted: currentOverview.totalGoodDeedsCompleted + 1,
        currentSpiritualLevelTitle: InabaSeedData.resolveLevelTitle(updatedDays),
        recoveryPathStatus: 'انتصار روحي جديد، وثبات على العهد',
      ),
    );
    await _saveOverview(updated);
    return updated;
  }
}
