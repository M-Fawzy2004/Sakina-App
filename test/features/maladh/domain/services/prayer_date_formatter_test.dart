import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/features/maladh/domain/services/prayer_date_formatter.dart';

void main() {
  group('PrayerDateFormatter Tests', () {
    test('computes Arabic day name accurately for Friday', () {
      final friday = DateTime(2026, 11, 6); // Friday
      expect(PrayerDateFormatter.getDayNameArabic(friday), 'الجُمُعَةِ');
    });

    test('computes Arabic Gregorian month name accurately for November', () {
      final november = DateTime(2026, 11, 6);
      expect(PrayerDateFormatter.getGregorianMonthNameArabic(november), 'نُوفَمْبِر');
    });

    test('formats Gregorian date numerically', () {
      final date = DateTime(2026, 11, 6);
      expect(PrayerDateFormatter.formatGregorianNumeric(date), '2026-11-06');
    });

    test('computes tabular astronomical Hijri calendar components', () {
      final date = DateTime(2026, 11, 6);
      final hijri = PrayerDateFormatter.computeHijri(date);

      expect(hijri.year, greaterThan(1445));
      expect(hijri.month, inInclusiveRange(1, 12));
      expect(hijri.day, inInclusiveRange(1, 30));
      expect(hijri.formattedNumeric, matches(r'^\d{4}-\d{2}-\d{2}$'));
      expect(hijri.monthName.isNotEmpty, isTrue);
    });
  });
}

