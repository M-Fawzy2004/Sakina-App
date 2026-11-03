import 'package:sakina_app/features/istighfar/domain/entities/istighfar_item.dart';

/// Data Transfer Object for Istighfar items with JSON serialization and default catalogue.
class IstighfarItemModel extends IstighfarItem {
  const IstighfarItemModel({
    required super.id,
    required super.arabic,
    required super.shortTitle,
    required super.virtue,
    super.currentCycleCount = 0,
    super.targetCount = 33,
    super.lifetimeCount = 0,
    super.lapsCompleted = 0,
  });

  factory IstighfarItemModel.fromEntity(IstighfarItem entity) {
    return IstighfarItemModel(
      id: entity.id,
      arabic: entity.arabic,
      shortTitle: entity.shortTitle,
      virtue: entity.virtue,
      currentCycleCount: entity.currentCycleCount,
      targetCount: entity.targetCount,
      lifetimeCount: entity.lifetimeCount,
      lapsCompleted: entity.lapsCompleted,
    );
  }

  factory IstighfarItemModel.fromJson(Map<String, dynamic> json) {
    return IstighfarItemModel(
      id: json['id'] as String,
      arabic: json['arabic'] as String,
      shortTitle: json['short_title'] as String,
      virtue: json['virtue'] as String,
      currentCycleCount: (json['current_cycle_count'] as num?)?.toInt() ?? 0,
      targetCount: (json['target_count'] as num?)?.toInt() ?? 33,
      lifetimeCount: (json['lifetime_count'] as num?)?.toInt() ?? 0,
      lapsCompleted: (json['laps_completed'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'arabic': arabic,
        'short_title': shortTitle,
        'virtue': virtue,
        'current_cycle_count': currentCycleCount,
        'target_count': targetCount,
        'lifetime_count': lifetimeCount,
        'laps_completed': lapsCompleted,
      };

  /// Pre-seeded authentic collection of prophetic Istighfar and Tasbeeh
  static const List<IstighfarItemModel> defaultItems = [
    IstighfarItemModel(
      id: 'istighfar_1',
      arabic: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ',
      shortTitle: 'الاستغفار',
      virtue: 'مَن لَزِمَ الاستغفارَ جعلَ اللهُ له من كلِّ ضيقٍ مَخرَجاً ومن كلِّ همٍّ فَرَجاً',
    ),
    IstighfarItemModel(
      id: 'subhanallah',
      arabic: 'سُبْحَانَ اللَّهِ',
      shortTitle: 'التسبيح',
      virtue: 'تُغرس لقائلها نخلة في الجنة وتُحط عنه الخطايا وإن كانت مثل زبد البحر',
    ),
    IstighfarItemModel(
      id: 'alhamdulillah',
      arabic: 'الْحَمْدُ لِلَّهِ',
      shortTitle: 'التحميد',
      virtue: 'تملأ ميزان العبد بالحسنات، وهي أحب الثناء إلى رب الأرض والسماوات',
    ),
    IstighfarItemModel(
      id: 'la_ilaha_illallah',
      arabic: 'لَا إِلَهَ إِلَّا اللَّهُ',
      shortTitle: 'التهليل',
      virtue: 'أفضل الذكر وخير ما قال النبيون، ومفتاح جنات النعيم',
    ),
    IstighfarItemModel(
      id: 'allahu_akbar',
      arabic: 'اللَّهُ أَكْبَرُ',
      shortTitle: 'التكبير',
      virtue: 'أحب الكلام إلى الله تعالى مع رفيقاتها الباقيات الصالحات',
    ),
    IstighfarItemModel(
      id: 'subhan_wa_bihamdih',
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
      shortTitle: 'حبيبتان للرحمن',
      virtue: 'كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن',
    ),
    IstighfarItemModel(
      id: 'hawqala',
      arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ',
      shortTitle: 'الحوقلة',
      virtue: 'كنز من كنوز الجنة وباب من أبواب تفريج الكروب والهموم',
    ),
    IstighfarItemModel(
      id: 'salawat',
      arabic: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
      shortTitle: 'الصلاة على النبي',
      virtue: 'مَن صلَّى عليَّ صلاةً صلَّى الله عليه بها عشراً وحُطَّت عنه بها عشر سيئات',
    ),
    IstighfarItemModel(
      id: 'yunus_dua',
      arabic: 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
      shortTitle: 'دعاء ذي النون',
      virtue: 'لم يدعُ بها مسلم في كربة قط إلا فرّج الله تعالى عنه واستجاب له',
    ),
    IstighfarItemModel(
      id: 'sayyid_al_istighfar',
      arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ ، خَلَقْتَنِي وَأَنَا عَبْدُكَ ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
      shortTitle: 'سيد الاستغفار',
      virtue: 'مَن قالها من النهار موقناً بها فمات من يومه قبل أن يمسي فهو من أهل الجنة',
    ),
  ];
}

