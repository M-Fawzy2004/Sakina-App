import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_recovery_plan_entity.dart';

/// Seed data for structured repentance & spiritual recovery plans.
abstract final class InabaRecoveryPlansSeedData {
  static List<SpiritualRecoveryPlanEntity> get defaultPlans => [
        // ---------------------------------------------------------------------
        // 1. The 7-Day Awakening Plan (خطة الـ 7 أيام للبداية والتطهر)
        // ---------------------------------------------------------------------
        const SpiritualRecoveryPlanEntity(
          id: 'plan_7_days',
          title: 'خطة الـ ٧ أيام: يقظة القلب وبداية التطهر',
          badge: 'للانطلاقة الأولى • ٧ أيام',
          durationText: '٧ أَيَّام',
          description:
              'برنامج مكثف لبداية عهد جديد، قطع الصلة بالزلل، وإعادة غرس الطمأنينة عبر خطوات يومية عملية مستمدة من السنة النبوية.',
          iconKey: 'sun',
          steps: [
            RecoveryPlanDayStepEntity(
              dayNumber: 1,
              title: 'صلاة ركعتي التوبة وإسباغ الوضوء',
              practicalAction:
                  'قم الآن وتوضأ وضوءاً حسناً، واختلِ بربك في ركعتين خاشعتين تصلي فيهما بتؤدة، واعترف بضعفك وخطئك بين يديه.',
              recommendedDhikr: '«سيد الاستغفار: اللهم أنت ربي لا إله إلا أنت خلقتني وأنا عبدك...»',
              scripturalEvidence:
                  '«ما من رجل يذنب ذنباً ثم يقوم فيتطهر ثم يصلي ثم يستغفر الله إلا غفر الله له» [أبو داود والترمذي]',
              isCompleted: true,
            ),
            RecoveryPlanDayStepEntity(
              dayNumber: 2,
              title: 'تطهير البيئة والأجهزة وحذف مواطن الزلل',
              practicalAction:
                  'احذف أي تطبيق، أو حساب، أو رقم، أو صورة كانت سبباً في الوقوع في الخطأ. تخلّص من كل ما يقربك من الغفلة واجعل بيئتك نقية.',
              recommendedDhikr: '«لا حول ولا قوة إلا بالله العلي العظيم (١٠٠ مرة)»',
              scripturalEvidence:
                  '«ومن يتق الله يجعل له مخرجا ويرزقه من حيث لا يحتسب» [الطلاق]',
              isCompleted: true,
            ),
            RecoveryPlanDayStepEntity(
              dayNumber: 3,
              title: 'غرس حصن الأذكار والاستغفار المنتظم',
              practicalAction:
                  'حافظ على أذكار الصباح كاملة فور استيقاظك، وأذكار المساء قبل الغروب، واجعل لسانك رطباً بالاستغفار طوال ساعات يومك.',
              recommendedDhikr: '«أستغفر الله العظيم وأتوب إليه (١٠٠ مرة صباحاً ومساءً)»',
              scripturalEvidence:
                  '«والذاكرين الله كثيراً والذاكرات أعد الله لهم مغفرة وأجراً عظيماً» [الأحزاب]',
              isCompleted: false,
            ),
            RecoveryPlanDayStepEntity(
              dayNumber: 4,
              title: 'صدقة السر وإحسان يمحو أثر الذنب',
              practicalAction:
                  'تصدق اليوم ولو بمبلغ يسير جداً في السر التام، أو أطعم محتاجاً، أو أدخل السرور على قلب مسلم دون أن يعلم بك أحد إلا الله.',
              recommendedDhikr: '«سبحان الله وبحمده سبحان الله العظيم (١٠٠ مرة)»',
              scripturalEvidence:
                  '«إن الحسنات يذهبن السيئات ذلك ذكرى للذاكرين» [هود] • «صدقة السر تطفئ غضب الرب»',
              isCompleted: false,
            ),
            RecoveryPlanDayStepEntity(
              dayNumber: 5,
              title: 'ركعتا قيام الليل ومناجاة السحر',
              practicalAction:
                  'اضبط منبهك قبل صلاة الفجر بنصف ساعة، وصلِّ ركعتين في سكون الليل، واسكب دمعة الرجاء سائلاً الله الثبات حتى الممات.',
              recommendedDhikr: '«يا حي يا قيوم برحمتك أستغيث، أصلح لي شأني كله ولا تكلني إلى نفسي طرفة عين»',
              scripturalEvidence:
                  '«ينزل ربنا تبارك وتعالى كل ليلة إلى السماء الدنيا حين يبقى ثلث الليل الآخر...» [متفق عليه]',
              isCompleted: false,
            ),
            RecoveryPlanDayStepEntity(
              dayNumber: 6,
              title: 'تعمير الفراغ بكتاب الله والنشاط البدني النافع',
              practicalAction:
                  'الفراغ مفسدة؛ اقرأ اليوم جزءاً من القرآن بتدبر، ومارس نشاطاً رياضياً أو عملاً بدنياً نافعاً يستنفد طاقتك في الخير.',
              recommendedDhikr: '«اللهم أعني على ذكرك وشكرك وحسن عبادتك»',
              scripturalEvidence:
                  '«فإذا فرغت فانصب، وإلى ربك فارغب» [الشرح]',
              isCompleted: false,
            ),
            RecoveryPlanDayStepEntity(
              dayNumber: 7,
              title: 'شكر المنعم وتجديد العهد على الثبات',
              practicalAction:
                  'أتممت أسبوعاً كاملاً بفضل الله وتوفيقه! اسجد سجدة شكر لله على نعمة الطهارة، واكتب في محرابك عهد الثبات على الصراط المستقيم.',
              recommendedDhikr: '«الحمد لله حمداً كثيراً طيباً مباركاً فيه»',
              scripturalEvidence:
                  '«لئن شكرتم لأزيدنكم» [إبراهيم] • «يا مقلب القلوب ثبت قلبي على دينك»',
              isCompleted: false,
            ),
          ],
        ),

        // ---------------------------------------------------------------------
        // 2. The 30-Day Spiritual Fortress (خطة الـ 30 يوماً لبناء الحصانة)
        // ---------------------------------------------------------------------
        const SpiritualRecoveryPlanEntity(
          id: 'plan_30_days',
          title: 'خطة الـ ٣٠ يوماً: بناء الحصانة الروحية الراسخة',
          badge: 'للثبات والارتقاء • ٣٠ يوماً',
          durationText: '٣٠ يَوْماً',
          description:
              'مسار شامل لبناء عادات الطهر، وتفكيك الارتباط النفسي بالمعصية عبر 3 مراحل متدرجة تنقلك من الفطام إلى الطمأنينة ولذة الطاعة.',
          iconKey: 'shield',
          steps: [
            RecoveryPlanDayStepEntity(
              dayNumber: 1,
              title: 'المرحلة ١ (أيام ١-١٠): كسر العادة وتطهير المحيط',
              practicalAction:
                  'مواجهة الأيام الأولى بحزم، تفادي الخلوات غير المنضبطة، واستبدال الأوقات الخطرة بالجلوس مع الأهل أو في المسجد.',
              recommendedDhikr: '«لا إله إلا أنت سبحانك إني كنت من الظالمين (١٠٠ مرة)»',
              scripturalEvidence:
                  '«والذين جاهدوا فينا لنهدينهم سبلنا وإن الله لمع المحسنين» [العنكبوت]',
              isCompleted: true,
            ),
            RecoveryPlanDayStepEntity(
              dayNumber: 2,
              title: 'المرحلة ٢ (أيام ١١-٢٠): استقرار الروح وتثبيت الأوراد',
              practicalAction:
                  'تراجع حدة الوساوس ويبدأ القلب في تذوق حلاوة النقاء؛ ثبت وردك القرآني اليومي بمعدل نصف حزب على الأقل.',
              recommendedDhikr: '«اللهم إني أسألك الهدى والتقى والعفاف والغنى»',
              scripturalEvidence:
                  '«ألا بذكر الله تطمئن القلوب» [الرعد]',
              isCompleted: false,
            ),
            RecoveryPlanDayStepEntity(
              dayNumber: 3,
              title: 'المرحلة ٣ (أيام ٢١-٣٠): رسوخ الطمأنينة وحماية المكتسبات',
              practicalAction:
                  'تحول الطهارة إلى هوية شخصية ونمط حياة؛ احرص على الصحبة الصالحة، وابدأ في نفع غيرك والتواصي بالحق والصبر.',
              recommendedDhikr: '«ربنا لا تزغ قلوبنا بعد إذ هديتنا وهب لنا من لدنك رحمة»',
              scripturalEvidence:
                  '«يثبت الله الذين آمنوا بالقول الثابت في الحياة الدنيا وفي الآخرة» [إبراهيم]',
              isCompleted: false,
            ),
          ],
        ),

        // ---------------------------------------------------------------------
        // 3. SOS Emergency Protocol (بروتوكول الطوارئ والنجاة الفورية)
        // ---------------------------------------------------------------------
        const SpiritualRecoveryPlanEntity(
          id: 'plan_sos_urgent',
          title: 'بروتوكول الطوارئ: الإسعاف الروحي عند هجوم الخواطر',
          badge: 'تدخل عاجل • ٥ خطوات',
          durationText: 'فَوْرِي',
          description:
              'خطوات إسعافية محكمة تنفذها فوراً عند هجوم الرغبة الملحة أو وساوس الشيطان لقطع حبل الغفلة وحماية نقائك في اللحظة الحرجة.',
          iconKey: 'heart',
          steps: [
            RecoveryPlanDayStepEntity(
              dayNumber: 1,
              title: 'الخطوة الأولى: التوقف وتغيير المكان فوراً (Stop & Move)',
              practicalAction:
                  'اخرج من الغرفة فوراً، اترك الهاتف أو الجهاز في مكان عام، واذهب إلى حيث يوجد أناس أو تحرك مشياً على قدميك.',
              recommendedDhikr: '«أعوذ بالله السميع العليم من الشيطان الرجيم»',
              scripturalEvidence:
                  '«وإما ينزغنك من الشيطان نزغ فاستعذ بالله إنه هو السميع العليم» [فصلت]',
              isCompleted: false,
            ),
            RecoveryPlanDayStepEntity(
              dayNumber: 2,
              title: 'الخطوة الثانية: إسباغ الوضوء بماء بارد',
              practicalAction:
                  'الماء يطفئ حرارة الشهوة والغضب التي يوقدها الشيطان؛ اغسل وجهك ويديك وتوضأ وضوء الصلاة بماء بارد ومنعش.',
              recommendedDhikr: '«أشهد أن لا إله إلا الله وأشهد أن محمداً عبده ورسوله»',
              scripturalEvidence:
                  '«إن الغضب من الشيطان، وإن الشيطان خلق من النار، وإنما تطفأ النار بالماء فإذا غضب أحدكم فليتوضأ» [أبو داود]',
              isCompleted: false,
            ),
            RecoveryPlanDayStepEntity(
              dayNumber: 3,
              title: 'الخطوة الثالثة: صلاة ركعتين في ستر وعجلة',
              practicalAction:
                  'استقبل القبلة فوراً وكبّر؛ الصلاة تقطع حبل الخاطرة وتبدد سحائب الشهوة وتصلك بالقوي العزيز.',
              recommendedDhikr: '«رب إني مسني الضر وأنت أرحم الراحمين»',
              scripturalEvidence:
                  '«واستعينوا بالصبر والصلاة وإنها لكبيرة إلا على الخاشعين» [البقرة]',
              isCompleted: false,
            ),
            RecoveryPlanDayStepEntity(
              dayNumber: 4,
              title: 'الخطوة الرابعة: تذكير النفس بحقارة اللذة وسرعة زوالها',
              practicalAction:
                  'لذة المعصية تمضي في دقائق معدودة، وتبقى حسرتها وذلتها في القلب أياماً؛ بينما لذة الانتصار على النفس تبقى عزاً وطمأنينة.',
              recommendedDhikr: '«حسبي الله لا إله إلا هو عليه توكلت وهو رب العرش العظيم»',
              scripturalEvidence:
                  '«وأما من خاف مقام ربه ونهى النفس عن الهوى فإن الجنة هي المأوى» [النازعات]',
              isCompleted: false,
            ),
            RecoveryPlanDayStepEntity(
              dayNumber: 5,
              title: 'الخطوة الخامسة: إتباع الوسواس بعمل صالح فوري ماحٍ',
              practicalAction:
                  'اكسر شوكة الشيطان بإحسان فوري: تصدق بريال، أو قبّل يد والديك، أو اتصل بصديق صالح، أو اقرأ صفحة من القرآن.',
              recommendedDhikr: '«سبحان الله والحمد لله ولا إله إلا الله والله أكبر»',
              scripturalEvidence:
                  '«وأتبع السيئة الحسنة تمحها وخالق الناس بخلق حسن» [الترمذي]',
              isCompleted: false,
            ),
          ],
        ),
      ];
}

