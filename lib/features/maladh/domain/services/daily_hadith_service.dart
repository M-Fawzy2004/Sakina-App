import 'package:sakina_app/features/maladh/data/datasources/static/daily_hadiths_seed_data.dart';
import 'package:sakina_app/features/maladh/domain/entities/daily_hadith_item.dart';

abstract final class DailyHadithService {
  static DailyHadithItem getTodayHadith([DateTime? time]) {
    final now = time ?? DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = (dayOfYear.abs()) % kDailyHadithsSeed.length;
    return kDailyHadithsSeed[index];
  }

  static DailyHadithItem getHadithById(int id) {
    return kDailyHadithsSeed.firstWhere(
      (h) => h.id == id,
      orElse: () => kDailyHadithsSeed.first,
    );
  }
}

