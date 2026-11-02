import 'package:sakina_app/features/inaba_recovery/data/models/daily_hope_dose_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/good_deed_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/inaba_overview_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/repentance_step_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/spiritual_level_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/spiritual_reflection_model.dart';

/// Seed data for Inaba Recovery offline-first local storage.
abstract final class InabaSeedData {
  static InabaOverviewModel get defaultOverview => InabaOverviewModel(
        streakDays: 14,
        bestStreakDays: 21,
        streakProgress: 0.70,
        totalGoodDeedsCompleted: 42,
        totalReflectionsCount: 3,
        currentSpiritualLevelTitle: 'الالتزام',
        recoveryPathStatus: 'حتى الآن في طريق النقاء',
        lastTawbahDate: DateTime.now().subtract(const Duration(days: 14)),
      );

  static String resolveLevelTitle(int days) {
    if (days >= 91) return 'الطُّمَأْنِينَةُ';
    if (days >= 31) return 'التَّمَيُّزُ';
    if (days >= 8) return 'الاِلْتِزَامُ';
    return 'البِدَايَةُ';
  }

  static List<GoodDeedModel> get goodDeeds => const [
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

  static List<DailyHopeDoseModel> get hopeDoses => const [
        DailyHopeDoseModel(
          id: 'hope_1',
          quotation: '«إن الله يحب التوابين ويحب المتطهرين»',
          source: 'سورة البقرة • آية ٢٢٢',
          explanation:
              'محبة الله لا تُنال بالمعصومية من الخطأ، بل بالمسارعة إلى التوبة الصادقة والرجوع إلى الله كلما زلت القدم.',
          isSaved: true,
        ),
        DailyHopeDoseModel(
          id: 'hope_2',
          quotation:
              '«يا ابن آدم! لو بلغت ذنوبك عنان السماء، ثم استغفرتني؛ غفرت لك ولا أبالي»',
          source: 'حديث قدسي شريف • رواه الترمذي',
          explanation:
              'مهما عظمت ذنوبك، فإن عفو الله ورحمته ومغفرته أعظم وأوسع من كل أوزار الأرض والسماء.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_3',
          quotation:
              '«لله أشد فرحاً بتوبة عبده حين يتوب إليه من أحدكم كان على راحلته بأرض فلاة...»',
          source: 'صحيح مسلم • عن أنس بن مالك رضي الله عنه',
          explanation:
              'الله العظيم الغني عن العالمين يفرح بإنابتك وعودتك فرحاً يفوق فرح التائه في الصحراء بالنجاة من الهلاك.',
          isSaved: true,
        ),
        DailyHopeDoseModel(
          id: 'hope_4',
          quotation:
              '«قل يا عبادي الذين أسرفوا على أنفسهم لا تقنطوا من رحمة الله إن الله يغفر الذنوب جميعا»',
          source: 'سورة الزمر • آية ٥٣',
          explanation:
              'أرجى آية في كتاب الله؛ نداء ملؤه اللطف والكرامة للمسرفين أن يقبلوا على ربهم ولا ييأسوا قط.',
          isSaved: false,
        ),
      ];

  static List<SpiritualReflectionModel> get reflections => [
        SpiritualReflectionModel(
          id: 'ref_1',
          title: 'لحظة صدق واعتراف بالضعف',
          content:
              'اللهم إني ظلمت نفسي ظلماً كثيراً، ولا يغفر الذنوب إلا أنت، فاغفر لي مغفرة من عندك وارحمني إنك أنت الغفور الرحيم. يا رب ثبت قلبي على طاعتك ونقّ سريرتي.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          moodTag: 'ندم ورجاء',
        ),
        SpiritualReflectionModel(
          id: 'ref_2',
          title: 'حمد لله على نعمة الستر والإفاقة',
          content:
              'الحمد لله الذي أمهلني ولم يعاجلني بالعقوبة، وستر قبيحي وأظهر جميل، وأيقظ في قلبي لذة العودة والاستغفار. عازم بحولك وقوتك أن أجعل اليوم أفضل من الأمس.',
          createdAt: DateTime.now().subtract(const Duration(days: 6)),
          moodTag: 'شكر واطمئنان',
        ),
        SpiritualReflectionModel(
          id: 'ref_3',
          title: 'مجاهدة الوسواس والخواطر الرديئة',
          content:
              'علمت أن مجاهدة النفس في ذات الله جهاد مبرور، وكلما ثقلت علي نفسي لجأت إلى الصلاة والذكر والدعاء. رب أعني ولا تعن علي، وانصرني ولا تنصر علي.',
          createdAt: DateTime.now().subtract(const Duration(days: 11)),
          moodTag: 'مجاهدة النفس',
        ),
      ];

  static List<RepentanceStepModel> get repentanceSteps => const [
        RepentanceStepModel(
          id: 'step_wudu_prayer',
          title: 'صلاة ركعتي التوبة بخشوع',
          subtitle: 'الوضوء السابغ والوقوف الصادق بين يدي الله',
          evidence:
              '«ما من عبد يذنب ذنبا ثم يتطهر فيحسن الطهور، ثم يقوم فيصلي ركعتين، ثم يستغفر الله إلا غفر الله له»',
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
          evidence:
              '«والذين إذا فعلوا فاحشة أو ظلموا أنفسهم ذكروا الله فاستغفروا لذنوبهم»',
          isCompleted: true,
        ),
        RepentanceStepModel(
          id: 'step_return_rights',
          title: 'رد المظالم أو الاستغفار لأصحابها',
          subtitle: 'إن كانت المعصية متعلقة بحقوق العباد',
          evidence:
              '«من كانت له عند أخيه مظلمة فليتحلله منها اليوم قبل ألا يكون دينار ولا درهم»',
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

  static List<SpiritualLevelModel> buildSpiritualLevels(int days) {
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
        description: 'حلاوة الطاعة، قوة اليقين، وتجاوز المنعطفات الحرجة.',
        isUnlocked: days >= 31,
        isCurrent: days >= 31 && days <= 90,
      ),
      SpiritualLevelModel(
        levelIndex: 4,
        title: 'الطُّمَأْنِينَةُ',
        minDays: 91,
        maxDays: 365,
        description: 'رسوخ القلب في منازل الرضا، والأنس بالله، والثبات التام.',
        isUnlocked: days >= 91,
        isCurrent: days >= 91,
      ),
    ];
  }
}
