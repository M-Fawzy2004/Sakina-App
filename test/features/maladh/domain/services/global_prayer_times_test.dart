import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/features/maladh/domain/services/global_prayer_times_calculator.dart';
import 'package:sakina_app/features/maladh/domain/services/prayer_location_catalog.dart';

void main() {
  group('GlobalPrayerTimesCalculator Tests', () {
    test('calculates accurate prayer schedule for Sanaa (Yemen)', () {
      final sanaa = PrayerLocationCatalog.findById('ye_sanaa');
      expect(sanaa.cityNameArabic, 'صنعاء');
      expect(sanaa.countryNameArabic, 'اليمن');
      expect(sanaa.calculationMethod, 'umm_al_qura');

      final date = DateTime(2026, 11, 6, 10, 0); // 10:00 AM (between Fajr and Dhuhr)
      final schedule = GlobalPrayerTimesCalculator.calculate(
        location: sanaa,
        customNow: date,
      );

      expect(schedule.cityName, 'صنعاء');
      expect(schedule.countryName, 'اليمن');
      expect(schedule.nextPrayerName, 'الظُّهْرُ');
      expect(schedule.currentPrayerName, 'الفَجْرُ');
      expect(schedule.fajrTime, isNotNull);
      expect(schedule.dhuhrTime, isNotNull);
      expect(schedule.asrTime, isNotNull);
      expect(schedule.maghribTime, isNotNull);
      expect(schedule.ishaTime, isNotNull);
      expect(schedule.remainingToNext.inMinutes, greaterThan(0));

      // Verify all prayer times strictly follow the 12-hour clock (1..12, e.g. 3:10 instead of 15:10)
      for (final formatted in [
        schedule.fajrFormatted,
        schedule.sunriseFormatted,
        schedule.dhuhrFormatted,
        schedule.asrFormatted,
        schedule.maghribFormatted,
        schedule.ishaFormatted,
        schedule.nextPrayerTime,
        schedule.currentPrayerTime,
      ]) {
        final hour = int.parse(formatted.split(':').first);
        expect(hour, inInclusiveRange(1, 12));
      }
    });

    test('calculates accurate prayer schedule for Makkah (Saudi Arabia)', () {
      final makkah = PrayerLocationCatalog.findById('sa_makkah');
      expect(makkah.cityNameArabic, 'مكة المكرمة');

      final date = DateTime(2026, 11, 6, 14, 0); // 2:00 PM (between Dhuhr and Asr)
      final schedule = GlobalPrayerTimesCalculator.calculate(
        location: makkah,
        customNow: date,
      );

      expect(schedule.nextPrayerName, 'العَصْرُ');
      expect(schedule.currentPrayerName, 'الظُّهْرُ');
      expect(schedule.nextPrayerIndex, 2);
    });

    test('calculates accurate prayer schedule for Cairo (Egypt)', () {
      final cairo = PrayerLocationCatalog.findById('eg_cairo');
      final date = DateTime(2026, 11, 6, 18, 0); // 6:00 PM (between Maghrib and Isha)
      final schedule = GlobalPrayerTimesCalculator.calculate(
        location: cairo,
        customNow: date,
      );

      expect(schedule.nextPrayerName, 'العِشَاءُ');
      expect(schedule.currentPrayerName, 'المَغْرِبُ');
      expect(schedule.nextPrayerIndex, 4);
    });

    test('PrayerLocationCatalog search finds matching cities and countries', () {
      final yemenMatches = PrayerLocationCatalog.search('اليمن');
      expect(yemenMatches.length, greaterThanOrEqualTo(5));
      expect(yemenMatches.any((c) => c.cityNameArabic == 'صنعاء'), isTrue);
      expect(yemenMatches.any((c) => c.cityNameArabic == 'عدن'), isTrue);

      final cairoMatches = PrayerLocationCatalog.search('القاهرة');
      expect(cairoMatches.length, 1);
      expect(cairoMatches.first.id, 'eg_cairo');
    });

    test('formatTime12 formats AM/PM correctly in Arabic', () {
      final morning = DateTime(2026, 11, 6, 4, 30);
      final evening = DateTime(2026, 11, 6, 17, 15);

      expect(GlobalPrayerTimesCalculator.formatTime12(morning), '4:30 ص');
      expect(GlobalPrayerTimesCalculator.formatTime12(evening), '5:15 م');
    });
  });
}
