import 'package:sakina_app/features/quran_reading/data/models/ayah_model.dart';
import 'package:sakina_app/features/quran_reading/data/models/surah_model.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/static/quran_fallback_verses_part1.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/static/quran_fallback_verses_part2.dart';

/// Embedded static authentic verses and exegesis map for fallback and offline safety.
final Map<int, List<AyahModel>> kFallbackVersesBySurah = {
  ...kFallbackVersesPart1,
  ...kFallbackVersesPart2,
};

/// Generates initial authentic verse passage for Surahs without pre-populated dictionary.
List<AyahModel> generateDefaultFallbackVerses(SurahModel surah) {
  return [
    AyahModel(
      numberInSurah: 1,
      text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      page: surah.pageNumber,
      juz: surah.juzNumber,
      tafsir: 'أبدأ قراءتي مستعيناً باسم الله الأعظم، الرحمن الذي وسعت رحمته كل شيء، الرحيم بعباده المؤمنين.',
      reflection: 'البسملة مفتاح كل خير، تبث في الروح الطمأنينة والتوكل على الله في بداية كل أمر.',
    ),
    AyahModel(
      numberInSurah: 2,
      text: '﴿أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ﴾',
      page: surah.pageNumber,
      juz: surah.juzNumber,
      tafsir: 'ألا بذكر الله وحده تسكن القلوب وتستقر أرواح المؤمنين وتبتعد عنها وساوس القلق والخوف.',
      reflection: 'السكينة الحقيقية لا تُنال بالأسباب المادية وحدها، بل بالاتصال الحي الدائم مع الخالق سبحانه.',
    ),
    AyahModel(
      numberInSurah: 3,
      text: '﴿وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ ۖ أُجِيبُ دَعْوَةَ الدَّاعِ إِذَا دَعَانِ﴾',
      page: surah.pageNumber,
      juz: surah.juzNumber,
      tafsir: 'وإذا سألك عبادي عن قربي وعلمي بهم، فإني قريب منهم أسمع دعاءهم وأجيب سؤلهم إذا دعوني مخلصين.',
      reflection: 'أقرب ما يكون العبد من ربه عند الإنابة والدعاء؛ لا حجاب بينك وبين ربك.',
    ),
    AyahModel(
      numberInSurah: 4,
      text: '﴿وَرَحْمَتِي وَسِعَتْ كُلَّ شَيْءٍ﴾',
      page: surah.pageNumber,
      juz: surah.juzNumber,
      tafsir: 'ورحمتي شملت كل مخلوق في هذا الكون، وسأكتبها خصوصاً للمتقين الذين يؤتون الزكاة ويؤمنون بآياتنا.',
      reflection: 'مهما تعاظمت ذنوبك أو همومك، فرحمة الله أوسع من كل شيء؛ فأقبل عليه تائباً مشتاقاً.',
    ),
  ];
}

