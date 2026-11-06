import 'package:sakina_app/features/inaba_recovery/data/models/daily_hope_dose_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/good_deed_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/inaba_overview_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/repentance_step_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/spiritual_level_model.dart';
import 'package:sakina_app/features/inaba_recovery/data/models/spiritual_reflection_model.dart';

/// Seed data for Inaba Recovery offline-first local storage.
abstract final class InabaSeedData {
  static InabaOverviewModel get defaultOverview => InabaOverviewModel(
        streakDays: 0,
        bestStreakDays: 0,
        streakProgress: 0.0,
        totalGoodDeedsCompleted: 0,
        totalReflectionsCount: 0,
        currentSpiritualLevelTitle: 'البِدَايَةُ',
        recoveryPathStatus: 'ابدأ عهد النقاء والسكينة الآن',
        lastTawbahDate: DateTime.now(),
        isPathActivated: false,
        currentActiveDay: 1,
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
          completionCount: 0,
          isCompletedToday: false,
          iconKey: 'heart',
        ),
        GoodDeedModel(
          id: 'deed_night_prayer',
          title: 'صلاة ركعتين في جوف الليل',
          category: 'عبادة بدنية',
          rewardDescription: '«ركعتان في جوف الليل خير من الدنيا وما فيها»',
          completionCount: 0,
          isCompletedToday: false,
          iconKey: 'moon',
        ),
        GoodDeedModel(
          id: 'deed_parents',
          title: 'بر الوالدين ودعوة صالحة',
          category: 'صلة رحم',
          rewardDescription: '«رضا الرب في رضا الوالد»',
          completionCount: 0,
          isCompletedToday: false,
          iconKey: 'people',
        ),
        GoodDeedModel(
          id: 'deed_istighfar',
          title: 'استغفار 100 مرة بيقين',
          category: 'ذكر ولسان',
          rewardDescription: '«من لزم الاستغفار جعل الله له من كل هم فرجا»',
          completionCount: 0,
          isCompletedToday: false,
          iconKey: 'tasbih',
        ),
        GoodDeedModel(
          id: 'deed_quran_juz',
          title: 'قراءة ورد أو جزء من القرآن',
          category: 'كتاب الله',
          rewardDescription: '«القرآن شافع مشفع وماحل مصدق»',
          completionCount: 0,
          isCompletedToday: false,
          iconKey: 'book',
        ),
        GoodDeedModel(
          id: 'deed_helping_hand',
          title: 'مساعدة محتاج أو إدخال سرور',
          category: 'إغاثة وخير',
          rewardDescription: '«أحب الناس إلى الله أنفعهم للناس»',
          completionCount: 0,
          isCompletedToday: false,
          iconKey: 'hands',
        ),
      ];

  static List<DailyHopeDoseModel> get hopeDoses => const [
        DailyHopeDoseModel(
          id: 'hope_1',
          quotation: '«إِنَّ اللَّهَ يُحِبُّ التَّوَّابِينَ وَيُحِبُّ الْمُتَطَهِّرِينَ»',
          source: 'سورة البقرة • آية ٢٢٢',
          explanation:
              'محبة الله لا تُنال بالمعصومية من الخطأ، بل بالمسارعة إلى التوبة الصادقة والرجوع إلى الله كلما زلت القدم.',
          isSaved: true,
        ),
        DailyHopeDoseModel(
          id: 'hope_2',
          quotation:
              '«يَا ابْنَ آدَمَ! لَوْ بَلَغَتْ ذُنُوبُكَ عَنَانَ السَّمَاءِ، ثُمَّ اسْتَغْفَرْتَنِي؛ غَفَرْتُ لَكَ وَلَا أُبَالِي»',
          source: 'حديث قدسي شريف • رواه الترمذي',
          explanation:
              'مهما عظمت ذنوبك، فإن عفو الله ورحمته ومغفرته أعظم وأوسع من كل أوزار الأرض والسماء.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_3',
          quotation:
              '«لَلَّهُ أَشَدُّ فَرَحًا بِتَوْبَةِ عَبْدِهِ حِينَ يَتُوبُ إِلَيْهِ، مِنْ أَحَدِكُمْ كَانَ عَلَى رَاحِلَتِهِ بِأَرْضِ فَلَاةٍ فَانْفَلَتَتْ مِنْهُ...»',
          source: 'صحيح مسلم • عن أنس بن مالك رضي الله عنه',
          explanation:
              'الله العظيم الغني عن العالمين يفرح بإنابتك وعودتك فرحاً يفوق فرح التائه في الصحراء بالنجاة من الهلاك.',
          isSaved: true,
        ),
        DailyHopeDoseModel(
          id: 'hope_4',
          quotation:
              '«قُلْ يَا عِبَادِيَ الَّذِينَ أَسْرَفُوا عَلَىٰ أَنفُسِهِمْ لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ ۚ إِنَّ اللَّهَ يَغْفِرُ الذُّنُوبَ جَمِيعًا»',
          source: 'سورة الزمر • آية ٥٣',
          explanation:
              'أرجى آية في كتاب الله؛ نداء ملؤه اللطف والكرامة للمسرفين أن يقبلوا على ربهم ولا ييأسوا قط.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_5',
          quotation:
              '«إِلَّا مَن تَابَ وَآمَنَ وَعَمِلَ عَمَلًا صَالِحًا فَأُولَٰئِكَ يُبَدِّلُ اللَّهُ سَيِّئَاتِهِمْ حَسَنَاتٍ ۗ وَكَانَ اللَّهُ غَفُورًا رَّحِيمًا»',
          source: 'سورة الفرقان • آية ٧٠',
          explanation:
              'فضل عظيم لا يقتصر على محو الذنوب، بل يبدلها الكريم سبحانه بحسنات تثقل ميزان التائب الصادق.',
          isSaved: true,
        ),
        DailyHopeDoseModel(
          id: 'hope_6',
          quotation:
              '«التَّائِبُ مِنَ الذَّنْبِ كَمَنْ لَا ذَنْبَ لَهُ»',
          source: 'سنن ابن ماجه • بسند حسن',
          explanation:
              'التوبة تمحو ما قبلها وتطهر صحيفة العبد تماماً، ليعود نقياً كيوم ولدته أمه بإذن الله.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_7',
          quotation:
              '«إِنَّ اللَّهَ تَعَالَى يَبْسُطُ يَدَهُ بِاللَّيْلِ لِيَتُوبَ مُسِيءُ النَّهَارِ، وَيَبْسُطُ يَدَهُ بِالنَّهَارِ لِيَتُوبَ مُسِيءُ اللَّيْلِ حَتَّى تَطْلُعَ الشَّمْسُ مِنْ مَغْرِبِهَا»',
          source: 'صحيح مسلم • عن أبي موسى الأشعري رضي الله عنه',
          explanation:
              'باب التوبة مفتوح بالليل والنهار في كل لحظة، والله تعالى يطلب إنابتك ويفرح بعودتك دائماً.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_8',
          quotation:
              '«وَإِنِّي لَغَفَّارٌ لِّمَن تَابَ وَآمَنَ وَعَمِلَ صَالِحًا ثُمَّ اهْتَدَىٰ»',
          source: 'سورة طه • آية ٨٢',
          explanation:
              'صيغة مبالغة تؤكد كثرة المغفرة وسعتها لكل من أتبع التوبة بالإيمان والعمل الصالح والثبات.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_9',
          quotation:
              '«وَالَّذِي نَفْسِي بِيَدِهِ لَوْ لَمْ تُذْنِبُوا لَذَهَبَ اللَّهُ بِكُمْ، وَلَجَاءَ بِقَوْمٍ يُذْنِبُونَ فَيَسْتَغْفِرُونَ اللَّهَ فَيَغْفِرُ لَهُمْ»',
          source: 'صحيح مسلم • عن أبي هريرة رضي الله عنه',
          explanation:
              'الله يحب انكسار المذنبين واستغفارهم، فلا تدع الشيطان يقنعك بأن خطأك يجعلك منبوذاً عند ربك.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_10',
          quotation:
              '«إِنَّ الْحَسَنَاتِ يُذْهِبْنَ السَّيِّئَاتِ ۚ ذَٰلِكَ ذِكْرَىٰ لِلذَّاكِرِينَ»',
          source: 'سورة هود • آية ١١٤',
          explanation:
              'كل عمل صالح تعمله بعد الزلل يغسل أثره ويمحو سواده؛ فقابل كل عثرة بصدقة أو صلاة أو تسبيح.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_11',
          quotation:
              '«وَمَن يَعْمَلْ سُوءًا أَوْ يَظْلِمْ نَفْسَهُ ثُمَّ يَسْتَغْفِرِ اللَّهَ يَجِدِ اللَّهَ غَفُورًا رَّحِيمًا»',
          source: 'سورة النساء • آية ١١٠',
          explanation:
              'مهما كان الذنب كبيراً أو ثقيلاً على صدرك، فما إن تبسط يد الضراعة مستغفراً حتى تجد ربك غفوراً رحيماً يبدل وحشتك أنساً.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_12',
          quotation:
              '«وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ ۖ أُجِيبُ دَعْوَةَ الدَّاعِ إِذَا دَعَانِ»',
          source: 'سورة البقرة • آية ١٨٦',
          explanation:
              'أقرب إليك من حبل الوريد؛ يسمع نجواك، ويعلم ضعفك ودمعتك الخفية، ولا يرد من طرق بابه صادقاً.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_13',
          quotation:
              '«الَّذِينَ آمَنُوا وَتَطْمَئِنُّ قُلُوبُهُم بِذِكْرِ اللَّهِ ۗ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ»',
          source: 'سورة الرعد • آية ٢٨',
          explanation:
              'كل سكن وراحة خارج كنف الله سراب زائل، والقلب لا يهدأ اضطرابه إلا بذكر الحبيب ومناجاة العلي القدير.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_14',
          quotation:
              '«فَإِنَّ مَعَ الْعُسْرِ يُسْرًا ۝ إِنَّ مَعَ الْعُسْرِ يُسْرًا»',
          source: 'سورة الشرح • آية ٥ - ٦',
          explanation:
              'تأكيد رباني مكرر؛ لن يغلب عسر يسرين أبداً، وما ضاقت أسباب الأرض إلا لتتسع أبواب السماء بلطف الله.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_15',
          quotation:
              '«إِنَّ رَحْمَتِي سَبَقَتْ غَضَبِي»',
          source: 'حديث قدسي شريف • صحيح البخاري',
          explanation:
              'قانون الوجود الأكبر؛ رحمة الله سبحانه أصل مطرد وعفوه يسبق كل شيء، فأقبل عليه راجياً مستبشراً.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_16',
          quotation:
              '«أَنَا عِنْدَ ظَنِّ عَبْدِي بِي، وَأَنَا مَعَهُ إِذَا ذَكَرَنِي... وَمَنْ تَقَرَّبَ إِلَيَّ شِبْرًا تَقَرَّبْتُ إِلَيْهِ ذِرَاعًا»',
          source: 'متفق عليه • عن أبي هريرة رضي الله عنه',
          explanation:
              'كل خطوة تخطوها نحو الله بالصدق والطهارة، يقابلك الله بأضعافها من اللطف والمعونة والتثبيت.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_17',
          quotation:
              '«وَاصْبِرْ لِحُكْمِ رَبِّكَ فَإِنَّكَ بِأَعْيُنِنَا»',
          source: 'سورة الطور • آية ٤٨',
          explanation:
              'أنت في رعاية الله وحفظه ما دمت تلجأ إليه؛ فامضِ في طريق الطهر ولا تخشَ غدر الهوى أو وسواس الشيطان.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_18',
          quotation:
              '«لَا تَدْرِي لَعَلَّ اللَّهَ يُحْدِثُ بَعْدَ ذَٰلِكَ أَمْرًا»',
          source: 'سورة الطلاق • آية ١',
          explanation:
              'في لحظة واحدة تنقلب الموازين ويتبدل الحزن فرجاً، فثق بتدبير من لا يغفل ولا ينام.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_19',
          quotation:
              '«وَرَحْمَتِي وَسِعَتْ كُلَّ شَيْءٍ»',
          source: 'سورة الأعراف • آية ١٥٦',
          explanation:
              'وسعت السماوات والأرض والمذنبين والمقصرين؛ فهل تضيق بك وأنت عبد منكسر تطرق باب رحمته؟',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_20',
          quotation:
              '«وَتَوَكَّلْ عَلَى الْحَيِّ الَّذِي لَا يَمُوتُ وَسَبِّحْ بِحَمْدِهِ»',
          source: 'سورة الفرقان • آية ٥٨',
          explanation:
              'كل متكأ في الدنيا زائل، ومن استند إلى ركن الله القوي كفاه كل خوف وهداه إلى سبل السلام.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_21',
          quotation:
              '«نَبِّئْ عِبَادِي أَنِّي أَنَا الْغَفُورُ الرَّحِيمُ»',
          source: 'سورة الحجر • آية ٤٩',
          explanation:
              'رسالة مباشرة من رب العزة إلى فؤادك؛ تفتح لك أفق الأمل الواسع مهما كان ركام الأمس.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_22',
          quotation:
              '«إِنَّ اللَّهَ بِالنَّاسِ لَرَءُوفٌ رَّحِيمٌ»',
          source: 'سورة البقرة • آية ١٤٣',
          explanation:
              'رأفة ألطف من رأفة الوالدة بولدها، تمنحك الأمان الدائم وتغمر أيامك بالسكينة والرضا.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_23',
          quotation:
              '«كَلَّا إِنَّ مَعِيَ رَبِّي سَيَهْدِينِ»',
          source: 'سورة الشعراء • آية ٦٢',
          explanation:
              'يقين يفلّ الحديد وينسف جيوش اليأس؛ حين تحاصرك الفتن والمصاعب اصرخ بيقين موسى عليه السلام وسينفلق لك بحر النجاة.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_24',
          quotation:
              '«وَاسْتَغْفِرُوا رَبَّكُمْ ثُمَّ تُوبُوا إِلَيْهِ ۚ إِنَّ رَبِّي رَحِيمٌ وَدُودٌ»',
          source: 'سورة هود • آية ٩٠',
          explanation:
              'ودود يتودد إلى عباده بالمغفرة والنعم، ويحب من عبده أن يعود إلى رحابه كلما تاه في دروب الغفلة.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_25',
          quotation:
              '«وَلَسَوْفَ يُعْطِيكَ رَبُّكَ فَتَرْضَىٰ»',
          source: 'سورة الضحى • آية ٥',
          explanation:
              'وعد صادق لا يخلف؛ ما عند الله لك من الجزاء والعوض والسكينة سيبهرك حتى يفيض قلبك حمداً ورضى.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_26',
          quotation:
              '«عَجَبًا لِأَمْرِ الْمُؤْمِنِ، إِنَّ أَمْرَهُ كُلَّهُ خَيْرٌ، وَلَيْسَ ذَاكَ لِأَحَدٍ إِلَّا لِلْمُؤْمِنِ»',
          source: 'صحيح مسلم • عن صهيب رضي الله عنه',
          explanation:
              'حياة المؤمن كلها ربح في ربح؛ إن أصابته سراء شكر فكان خيراً له، وإن أصابته ضراء صبر فكان خيراً له.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_27',
          quotation:
              '«مَا يُصِيبُ الْمُسْلِمَ مِنْ نَصَبٍ وَلَا وَصَبٍ وَلَا هَمٍّ وَلَا حُزْنٍ... إِلَّا كَفَّرَ اللَّهُ بِهَا مِنْ خَطَايَاهُ»',
          source: 'متفق عليه • عن أبي سعيد وأبي هريرة',
          explanation:
              'حتى الشوكة يشاكها ترفع درجته وتمحو وزره؛ فلا يضيع عند الله ألم ولا تنهيدة حزن كظمتها في سبيله.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_28',
          quotation:
              '«وَقَالَ رَبُّكُمُ ادْعُونِي أَسْتَجِبْ لَكُمْ»',
          source: 'سورة غافر • آية ٦٠',
          explanation:
              'أمر بالدعاء مقرون بضمان الإجابة، فما عليك إلا أن ترفع يديك وتفيض بصدق ما في صدرك.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_29',
          quotation:
              '«أَمَّن يُجِيبُ الْمُضْطَرَّ إِذَا دَعَاهُ وَيَكْشِفُ السُّوءَ»',
          source: 'سورة النمل • آية ٦٢',
          explanation:
              'حين تنقطع الأسباب الأرضية وتضيق الحيل، يبقى باب من يجيب المضطر مفتوحاً لا يغلق في وجه أحد.',
          isSaved: false,
        ),
        DailyHopeDoseModel(
          id: 'hope_30',
          quotation:
              '«وَهُوَ الَّذِي يَقْبَلُ التَّوْبَةَ عَنْ عِبَادِهِ وَيَعْفُو عَنِ السَّيِّئَاتِ وَيَعْلَمُ مَا تَفْعَلُونَ»',
          source: 'سورة الشورى • آية ٢٥',
          explanation:
              'قبول فوري ومحو شامل؛ يعلم ضعفك وبشريتك، ولا يطلب منك إلا الإقبال الصادق ليعيدك إلى ساحات النقاء.',
          isSaved: false,
        ),
      ];

  static List<SpiritualReflectionModel> get reflections => [];

  static List<RepentanceStepModel> get repentanceSteps => const [
        RepentanceStepModel(
          id: 'step_wudu_prayer',
          title: 'صلاة ركعتي التوبة بخشوع',
          subtitle: 'الوضوء السابغ والوقوف الصادق بين يدي الله',
          evidence:
              '«ما من عبد يذنب ذنبا ثم يتطهر فيحسن الطهور، ثم يقوم فيصلي ركعتين، ثم يستغفر الله إلا غفر الله له»',
          isCompleted: false,
        ),
        RepentanceStepModel(
          id: 'step_deep_remorse',
          title: 'الاستغفار بصدق والندم القلبي',
          subtitle: 'انكسار القلب بين يدي الغفور الرحيم',
          evidence: '«الندم توبة» • رواه ابن ماجه وأحمد',
          isCompleted: false,
        ),
        RepentanceStepModel(
          id: 'step_firm_resolve',
          title: 'العزم الصادق على عدم العودة',
          subtitle: 'قطع الصلة بأسباب المعصية ومواطن الغفلة',
          evidence:
              '«والذين إذا فعلوا فاحشة أو ظلموا أنفسهم ذكروا الله فاستغفروا لذنوبهم»',
          isCompleted: false,
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
          isCompleted: false,
        ),
      ];

  static List<SpiritualLevelModel> buildSpiritualLevels(int days) {
    return [
      SpiritualLevelModel(
        levelIndex: 1,
        title: 'البِدَايَةُ',
        minDays: 0,
        maxDays: 7,
        description: 'خطوة العزم الأولى، صدق التوجه، وكسر حواجز الغفلة.',
        isUnlocked: true,
        isCurrent: days <= 7,
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
