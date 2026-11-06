import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/features/home_widgets/domain/models/widget_models.dart';

void main() {
  group('Home Widget Domain Models', () {
    test('WidgetHadithData supports value equality', () {
      const data1 = WidgetHadithData(
        id: 1,
        text: 'إنما الأعمال بالنيات',
        narrator: 'عمر بن الخطاب',
        sourceBook: 'صحيح البخاري',
        topic: 'الإخلاص',
      );
      const data2 = WidgetHadithData(
        id: 1,
        text: 'إنما الأعمال بالنيات',
        narrator: 'عمر بن الخطاب',
        sourceBook: 'صحيح البخاري',
        topic: 'الإخلاص',
      );

      expect(data1, equals(data2));
    });

    test('WidgetPrayerData supports value equality', () {
      const data1 = WidgetPrayerData(
        cityName: 'القاهرة',
        hijriDate: '٢٥ جمادى الأولى ١٤٤٨ هـ',
        gregorianDate: '6 نوفمبر 2026',
        nextPrayerName: 'المغرب',
        nextPrayerTime: '5:04 م',
        remainingCountdown: '01:08:26',
        previousPrayerName: 'العصر',
        previousPrayerTime: '2:42 م',
        prayers: [
          WidgetPrayerItem(name: 'الفجر', time: '4:44 ص', isNext: false),
          WidgetPrayerItem(name: 'المغرب', time: '5:04 م', isNext: true),
        ],
      );
      const data2 = WidgetPrayerData(
        cityName: 'القاهرة',
        hijriDate: '٢٥ جمادى الأولى ١٤٤8 هـ',
        gregorianDate: '6 نوفمبر 2026',
        nextPrayerName: 'المغرب',
        nextPrayerTime: '5:04 م',
        remainingCountdown: '01:08:26',
        previousPrayerName: 'العصر',
        previousPrayerTime: '2:42 م',
        prayers: [
          WidgetPrayerItem(name: 'الفجر', time: '4:44 ص', isNext: false),
          WidgetPrayerItem(name: 'المغرب', time: '5:04 م', isNext: true),
        ],
      );

      expect(data1.cityName, equals(data2.cityName));
      expect(data1.prayers.length, 2);
    });

    test('WidgetQuranData and WidgetTasbeehData support value equality', () {
      const quran = WidgetQuranData(
        surahName: 'سورة البقرة',
        ayahNumber: 255,
        arabicText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        reflection: 'أعظم آية في كتاب الله',
      );
      expect(quran.surahName, 'سورة البقرة');
      expect(quran.ayahNumber, 255);

      const tasbeeh = WidgetTasbeehData(
        phrase: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        shortTitle: 'التسبيح',
        virtue: 'حطت خطاياه وإن كانت مثل زبد البحر',
        targetCount: 33,
      );
      expect(tasbeeh.targetCount, 33);
      expect(tasbeeh.shortTitle, 'التسبيح');
    });
  });
}

