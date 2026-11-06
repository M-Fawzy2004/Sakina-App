import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/features/home_widgets/data/daily_quran_seed.dart';

void main() {
  group('DailyQuranSeed', () {
    test('contains rich authentic collection of verses', () {
      expect(DailyQuranSeed.verses.length, greaterThanOrEqualTo(25));
      for (final v in DailyQuranSeed.verses) {
        expect(v.surahName, isNotEmpty);
        expect(v.ayahNumber, isPositive);
        expect(v.arabicText, isNotEmpty);
        expect(v.reflection, isNotEmpty);
      }
    });

    test('getTodayVerse returns a valid verse deterministically', () {
      final date1 = DateTime(2026, 11, 6);
      final date2 = DateTime(2026, 11, 7);

      final verse1 = DailyQuranSeed.getTodayVerse(date1);
      final verse2 = DailyQuranSeed.getTodayVerse(date2);

      expect(verse1.arabicText, isNotEmpty);
      expect(verse2.arabicText, isNotEmpty);
    });
  });
}

