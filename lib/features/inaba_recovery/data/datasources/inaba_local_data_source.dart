import 'dart:convert';

import 'package:sakina_app/core/services/storage/preferences_service.dart';
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
}

class InabaLocalDataSourceImpl implements InabaLocalDataSource {
  final PreferencesService _prefs;

  static const String _keyOverview = 'sakina_inaba_overview_v1';
  static const String _keyGoodDeeds = 'sakina_inaba_good_deeds_v1';
  static const String _keyReflections = 'sakina_inaba_reflections_v1';
  static const String _keyHopeDoses = 'sakina_inaba_hope_doses_v1';
  static const String _keyRepentanceSteps = 'sakina_inaba_repentance_steps_v1';

  InabaLocalDataSourceImpl(this._prefs);

  @override
  Future<InabaOverviewModel> getInabaOverview() async {
    final raw = _prefs.getString(_keyOverview);
    if (raw != null && raw.isNotEmpty) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        return InabaOverviewModel.fromJson(map);
      } catch (_) {
        // Fallback to default
      }
    }
    final defaultOverview = InabaOverviewModel(
      streakDays: 14,
      bestStreakDays: 21,
      streakProgress: 0.70,
      totalGoodDeedsCompleted: 42,
      totalReflectionsCount: 3,
      currentSpiritualLevelTitle: 'الالتزام',
      recoveryPathStatus: 'حتى الآن في طريق النقاء',
      lastTawbahDate: DateTime.now().subtract(const Duration(days: 14)),
    );
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
        return list
            .map((item) => GoodDeedModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (_) {
        // Fallback to seeds
      }
    }
    final seeds = _seedGoodDeeds();
    await _saveGoodDeeds(seeds);
    return seeds;
  }

  Future<void> _saveGoodDeeds(List<GoodDeedModel> list) async {
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyGoodDeeds, raw);
  }

  @override
  Future<GoodDeedModel> toggleGoodDeed(String id) async {
    final deeds = await getGoodDeeds();
    final index = deeds.indexWhere((d) => d.id == id);
    if (index == -1) {
      throw Exception('Good deed not found: $id');
    }
    final current = deeds[index];
    final updated = GoodDeedModel(
      id: current.id,
      title: current.title,
      category: current.category,
      rewardDescription: current.rewardDescription,
      completionCount: current.isCompletedToday
          ? current.completionCount
          : current.completionCount + 1,
      isCompletedToday: !current.isCompletedToday,
      iconKey: current.iconKey,
    );
    deeds[index] = updated;
    await _saveGoodDeeds(deeds);

    // Update overview totals if newly completed
    if (updated.isCompletedToday) {
      final overview = await getInabaOverview();
      final updatedOverview = InabaOverviewModel(
        streakDays: overview.streakDays,
        bestStreakDays: overview.bestStreakDays,
        streakProgress: overview.streakProgress,
        totalGoodDeedsCompleted: overview.totalGoodDeedsCompleted + 1,
        totalReflectionsCount: overview.totalReflectionsCount,
        currentSpiritualLevelTitle: overview.currentSpiritualLevelTitle,
        recoveryPathStatus: overview.recoveryPathStatus,
        lastTawbahDate: overview.lastTawbahDate,
      );
      await _saveOverview(updatedOverview);
    }
    return updated;
  }

  @override
  Future<GoodDeedModel> addCustomGoodDeed(String title, String category) async {
    final deeds = await getGoodDeeds();
    final newDeed = GoodDeedModel(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: category.isNotEmpty ? category : 'عمل خاص',
      rewardDescription: 'ما تقرب إلي عبدي بشيء أحب إلي مما افترضت عليه',
      completionCount: 0,
      isCompletedToday: false,
      iconKey: 'star',
    );
    deeds.insert(0, newDeed);
    await _saveGoodDeeds(deeds);
    return newDeed;
  }

  @override
  Future<List<DailyHopeDoseModel>> getHopeDoses() async {
    final raw = _prefs.getString(_keyHopeDoses);
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        return list
            .map(
              (item) =>
                  DailyHopeDoseModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } catch (_) {
        // Fallback to seeds
      }
    }
    final seeds = _seedHopeDoses();
    await _saveHopeDoses(seeds);
    return seeds;
  }

  Future<void> _saveHopeDoses(List<DailyHopeDoseModel> list) async {
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyHopeDoses, raw);
  }

  @override
  Future<DailyHopeDoseModel> toggleSaveHopeDose(String id) async {
    final doses = await getHopeDoses();
    final index = doses.indexWhere((d) => d.id == id);
    if (index == -1) {
      throw Exception('Hope dose not found: $id');
    }
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
    final days = overview.streakDays;

    return [
      SpiritualLevelModel(
        levelIndex: 1,
        title: 'البِدَايَةُ',
        minDays: 1,
        maxDays: 7,
        description: 'خطوة العزم الأولى، صدق التوجه، وكسر حواجز الغفلة.',
        isUnlocked: days >= 1,
        isCurrent: days >= 1 && days <= 7,
      ),
      SpiritualLevelModel(
        levelIndex: 2,
        title: 'الاِلْتِزَامُ',
        minDays: 8,
        maxDays: 30,
        description: 'بناء الحصانة الروحية، مجاهدة النفس، واستقرار السكينة.',
        isUnlocked: days >= 8,
        isCurrent: days >= 8 && days <= 30,
      ),
      SpiritualLevelModel(
        levelIndex: 3,
        title: 'التَّمَيُّزُ',
        minDays: 31,
        maxDays: 90,
        description: 'ترسيخ العادات الصالحة، تنقية السرائر، ولذة المناجاة.',
        isUnlocked: days >= 31,
        isCurrent: days >= 31 && days <= 90,
      ),
      SpiritualLevelModel(
        levelIndex: 4,
        title: 'الطُّمَأْنِينَةُ',
        minDays: 91,
        maxDays: 365,
        description: 'مقام الرضا واليقين، شجرة إيمان راسخة وظلال وارفة.',
        isUnlocked: days >= 91,
        isCurrent: days >= 91,
      ),
    ];
  }

  @override
  Future<List<SpiritualReflectionModel>> getReflections() async {
    final raw = _prefs.getString(_keyReflections);
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        return list
            .map(
              (item) => SpiritualReflectionModel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
      } catch (_) {
        // Fallback
      }
    }
    final seeds = _seedReflections();
    await _saveReflections(seeds);
    return seeds;
  }

  Future<void> _saveReflections(List<SpiritualReflectionModel> list) async {
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyReflections, raw);
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
      title: title.trim().isNotEmpty ? title.trim() : 'مناجاة واستغفار',
      content: content.trim(),
      createdAt: DateTime.now(),
      moodTag: moodTag,
    );
    reflections.insert(0, newReflection);
    await _saveReflections(reflections);

    // Update reflections count in overview
    final overview = await getInabaOverview();
    final updatedOverview = InabaOverviewModel(
      streakDays: overview.streakDays,
      bestStreakDays: overview.bestStreakDays,
      streakProgress: overview.streakProgress,
      totalGoodDeedsCompleted: overview.totalGoodDeedsCompleted,
      totalReflectionsCount: reflections.length,
      currentSpiritualLevelTitle: overview.currentSpiritualLevelTitle,
      recoveryPathStatus: overview.recoveryPathStatus,
      lastTawbahDate: overview.lastTawbahDate,
    );
    await _saveOverview(updatedOverview);

    return newReflection;
  }

  @override
  Future<void> deleteReflection(String id) async {
    final reflections = await getReflections();
    reflections.removeWhere((r) => r.id == id);
    await _saveReflections(reflections);

    final overview = await getInabaOverview();
    final updatedOverview = InabaOverviewModel(
      streakDays: overview.streakDays,
      bestStreakDays: overview.bestStreakDays,
      streakProgress: overview.streakProgress,
      totalGoodDeedsCompleted: overview.totalGoodDeedsCompleted,
      totalReflectionsCount: reflections.length,
      currentSpiritualLevelTitle: overview.currentSpiritualLevelTitle,
      recoveryPathStatus: overview.recoveryPathStatus,
      lastTawbahDate: overview.lastTawbahDate,
    );
    await _saveOverview(updatedOverview);
  }

  @override
  Future<void> clearAllReflections() async {
    await _saveReflections([]);
    final overview = await getInabaOverview();
    final updatedOverview = InabaOverviewModel(
      streakDays: overview.streakDays,
      bestStreakDays: overview.bestStreakDays,
      streakProgress: overview.streakProgress,
      totalGoodDeedsCompleted: overview.totalGoodDeedsCompleted,
      totalReflectionsCount: 0,
      currentSpiritualLevelTitle: overview.currentSpiritualLevelTitle,
      recoveryPathStatus: overview.recoveryPathStatus,
      lastTawbahDate: overview.lastTawbahDate,
    );
    await _saveOverview(updatedOverview);
  }

  @override
  Future<List<RepentanceStepModel>> getRepentanceSteps() async {
    final raw = _prefs.getString(_keyRepentanceSteps);
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        return list
            .map(
              (item) =>
                  RepentanceStepModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } catch (_) {
        // Fallback
      }
    }
    final seeds = _seedRepentanceSteps();
    await _saveRepentanceSteps(seeds);
    return seeds;
  }

  Future<void> _saveRepentanceSteps(List<RepentanceStepModel> list) async {
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyRepentanceSteps, raw);
  }

  @override
  Future<RepentanceStepModel> toggleRepentanceStep(String id) async {
    final steps = await getRepentanceSteps();
    final index = steps.indexWhere((s) => s.id == id);
    if (index == -1) {
      throw Exception('Repentance step not found: $id');
    }
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
    // Reset steps to uncompleted for a fresh start
    final steps = await getRepentanceSteps();
    final resetSteps = steps
        .map(
          (s) => RepentanceStepModel(
            id: s.id,
            title: s.title,
            subtitle: s.subtitle,
            evidence: s.evidence,
            isCompleted: false,
          ),
        )
        .toList();
    await _saveRepentanceSteps(resetSteps);

    final currentOverview = await getInabaOverview();
    final best = currentOverview.streakDays > currentOverview.bestStreakDays
        ? currentOverview.streakDays
        : currentOverview.bestStreakDays;

    final updated = InabaOverviewModel(
      streakDays: 1,
      bestStreakDays: best,
      streakProgress: 0.15,
      totalGoodDeedsCompleted: currentOverview.totalGoodDeedsCompleted,
      totalReflectionsCount: currentOverview.totalReflectionsCount,
      currentSpiritualLevelTitle: 'البداية',
      recoveryPathStatus: 'عهد جديد مع الله، وبداية نقية',
      lastTawbahDate: DateTime.now(),
    );
    await _saveOverview(updated);
    return updated;
  }

  @override
  Future<InabaOverviewModel> logSpiritualVictory() async {
    final currentOverview = await getInabaOverview();
    final updatedDays = currentOverview.streakDays + 1;
    final best = updatedDays > currentOverview.bestStreakDays
        ? updatedDays
        : currentOverview.bestStreakDays;

    final progress = (updatedDays % 30) / 30.0;
    final updated = InabaOverviewModel(
      streakDays: updatedDays,
      bestStreakDays: best,
      streakProgress: progress == 0 ? 1.0 : progress,
      totalGoodDeedsCompleted: currentOverview.totalGoodDeedsCompleted + 1,
      totalReflectionsCount: currentOverview.totalReflectionsCount,
      currentSpiritualLevelTitle: _resolveLevelTitle(updatedDays),
      recoveryPathStatus: 'انتصار روحي جديد، وثبات على العهد',
      lastTawbahDate: currentOverview.lastTawbahDate,
    );
    await _saveOverview(updated);
    return updated;
  }

  String _resolveLevelTitle(int days) {
    if (days >= 91) return 'الطُّمَأْنِينَةُ';
    if (days >= 31) return 'التَّمَيُّزُ';
    if (days >= 8) return 'الاِلْتِزَامُ';
    return 'البِدَايَةُ';
  }

  // --- Seed Data ---

  List<GoodDeedModel> _seedGoodDeeds() {
    return const [
      GoodDeedModel(
        id: 'deed_sadaqah',
        title: 'صدقة سرية ولو بالقليل',
        category: 'إحسان مالي',
        rewardDescription: '«صدقة السر تطفئ غضب الرب»',
        completionCount: 18,
        isCompletedToday: true,
        iconKey: 'heart',
      ),
      GoodDeedModel(
        id: 'deed_night_prayer',
        title: 'صلاة ركعتين في جوف الليل',
        category: 'عبادة بدنية',
        rewardDescription: '«ركعتان في جوف الليل خير من الدنيا وما فيها»',
        completionCount: 9,
        isCompletedToday: false,
        iconKey: 'moon',
      ),
      GoodDeedModel(
        id: 'deed_parents',
        title: 'بر الوالدين ودعوة صالحة',
        category: 'صلة رحم',
        rewardDescription: '«رضا الرب في رضا الوالد»',
        completionCount: 14,
        isCompletedToday: true,
        iconKey: 'people',
      ),
      GoodDeedModel(
        id: 'deed_istighfar',
        title: 'استغفار 100 مرة بيقين',
        category: 'ذكر ولسان',
        rewardDescription: '«من لزم الاستغفار جعل الله له من كل هم فرجا»',
        completionCount: 26,
        isCompletedToday: false,
        iconKey: 'tasbih',
      ),
      GoodDeedModel(
        id: 'deed_quran_juz',
        title: 'قراءة ورد أو جزء من القرآن',
        category: 'كتاب الله',
        rewardDescription: '«القرآن شافع مشفع وماحل مصدق»',
        completionCount: 11,
        isCompletedToday: false,
        iconKey: 'book',
      ),
      GoodDeedModel(
        id: 'deed_helping_hand',
        title: 'مساعدة محتاج أو إدخال سرور',
        category: 'إغاثة وخير',
        rewardDescription: '«أحب الناس إلى الله أنفعهم للناس»',
        completionCount: 8,
        isCompletedToday: false,
        iconKey: 'hands',
      ),
    ];
  }

  List<DailyHopeDoseModel> _seedHopeDoses() {
    return const [
      DailyHopeDoseModel(
        id: 'hope_1',
        quotation: '«إن الله يحب التوابين ويحب المتطهرين»',
        source: 'سورة البقرة • آية ٢٢٢',
        explanation: 'محبة الله لا تُنال بالمعصومية من الخطأ، بل بالمسارعة إلى التوبة الصادقة والرجوع إلى الله كلما زلت القدم.',
        isSaved: true,
      ),
      DailyHopeDoseModel(
        id: 'hope_2',
        quotation: '«يا ابن آدم! لو بلغت ذنوبك عنان السماء، ثم استغفرتني؛ غفرت لك ولا أبالي»',
        source: 'حديث قدسي شريف • رواه الترمذي',
        explanation: 'مهما عظمت ذنوبك، فإن عفو الله ورحمته ومغفرته أعظم وأوسع من كل أوزار الأرض والسماء.',
        isSaved: false,
      ),
      DailyHopeDoseModel(
        id: 'hope_3',
        quotation: '«لله أشد فرحاً بتوبة عبده حين يتوب إليه من أحدكم كان على راحلته بأرض فلاة...»',
        source: 'صحيح مسلم • عن أنس بن مالك رضي الله عنه',
        explanation: 'الله العظيم الغني عن العالمين يفرح بإنابتك وعودتك فرحاً يفوق فرح التائه في الصحراء بالنجاة من الهلاك.',
        isSaved: true,
      ),
      DailyHopeDoseModel(
        id: 'hope_4',
        quotation: '«قل يا عبادي الذين أسرفوا على أنفسهم لا تقنطوا من رحمة الله إن الله يغفر الذنوب جميعا»',
        source: 'سورة الزمر • آية ٥٣',
        explanation: 'أرجى آية في كتاب الله؛ نداء ملؤه اللطف والكرامة للمسرفين أن يقبلوا على ربهم ولا ييأسوا قط.',
        isSaved: false,
      ),
    ];
  }

  List<SpiritualReflectionModel> _seedReflections() {
    return [
      SpiritualReflectionModel(
        id: 'ref_1',
        title: 'لحظة صدق واعتراف بالضعف',
        content: 'اللهم إني ظلمت نفسي ظلماً كثيراً، ولا يغفر الذنوب إلا أنت، فاغفر لي مغفرة من عندك وارحمني إنك أنت الغفور الرحيم. يا رب ثبت قلبي على طاعتك ونقّ سريرتي.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        moodTag: 'ندم ورجاء',
      ),
      SpiritualReflectionModel(
        id: 'ref_2',
        title: 'حمد لله على نعمة الستر والإفاقة',
        content: 'الحمد لله الذي أمهلني ولم يعاجلني بالعقوبة، وستر قبيحي وأظهر جميل، وأيقظ في قلبي لذة العودة والاستغفار. عازم بحولك وقوتك أن أجعل اليوم أفضل من الأمس.',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        moodTag: 'شكر واطمئنان',
      ),
      SpiritualReflectionModel(
        id: 'ref_3',
        title: 'مجاهدة الوسواس والخواطر الرديئة',
        content: 'علمت أن مجاهدة النفس في ذات الله جهاد مبرور، وكلما ثقلت علي نفسي لجأت إلى الصلاة والذكر والدعاء. رب أعني ولا تعن علي، وانصرني ولا تنصر علي.',
        createdAt: DateTime.now().subtract(const Duration(days: 11)),
        moodTag: 'مجاهدة النفس',
      ),
    ];
  }

  List<RepentanceStepModel> _seedRepentanceSteps() {
    return const [
      RepentanceStepModel(
        id: 'step_wudu_prayer',
        title: 'صلاة ركعتي التوبة بخشوع',
        subtitle: 'الوضوء السابغ والوقوف الصادق بين يدي الله',
        evidence: '«ما من عبد يذنب ذنبا ثم يتطهر فيحسن الطهور، ثم يقوم فيصلي ركعتين، ثم يستغفر الله إلا غفر الله له»',
        isCompleted: true,
      ),
      RepentanceStepModel(
        id: 'step_deep_remorse',
        title: 'الاستغفار بصدق والندم القلبي',
        subtitle: 'انكسار القلب بين يدي الغفور الرحيم',
        evidence: '«الندم توبة» • رواه ابن ماجه وأحمد',
        isCompleted: true,
      ),
      RepentanceStepModel(
        id: 'step_firm_resolve',
        title: 'العزم الصادق على عدم العودة',
        subtitle: 'قطع الصلة بأسباب المعصية ومواطن الغفلة',
        evidence: '«والذين إذا فعلوا فاحشة أو ظلموا أنفسهم ذكروا الله فاستغفروا لذنوبهم»',
        isCompleted: true,
      ),
      RepentanceStepModel(
        id: 'step_return_rights',
        title: 'رد المظالم أو الاستغفار لأصحابها',
        subtitle: 'إن كانت المعصية متعلقة بحقوق العباد',
        evidence: '«من كانت له عند أخيه مظلمة فليتحلله منها اليوم قبل ألا يكون دينار ولا درهم»',
        isCompleted: false,
      ),
      RepentanceStepModel(
        id: 'step_follow_good_deed',
        title: 'إتباع السيئة بحسنة تمحوها فوراً',
        subtitle: 'صدقة، صلة، ذكر، أو إعانة محتاج',
        evidence: '«وأتبع السيئة الحسنة تمحها، وخالق الناس بخلق حسن»',
        isCompleted: true,
      ),
    ];
  }
}
