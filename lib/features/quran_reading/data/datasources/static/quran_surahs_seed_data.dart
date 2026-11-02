import 'package:sakina_app/features/quran_reading/data/models/surah_model.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/static/quran_surahs_part1.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/static/quran_surahs_part2.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/static/quran_surahs_part3.dart';

/// Complete unified index of all 114 Quranic Surahs.
final List<SurahModel> kDefaultSurahsList = [
  ...kSurahsPart1,
  ...kSurahsPart2,
  ...kSurahsPart3,
];

