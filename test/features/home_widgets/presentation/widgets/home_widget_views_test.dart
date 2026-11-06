import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/features/home_widgets/domain/models/widget_models.dart';
import 'package:sakina_app/features/home_widgets/presentation/widgets/hadith_widget_view.dart';
import 'package:sakina_app/features/home_widgets/presentation/widgets/prayer_widget_view.dart';
import 'package:sakina_app/features/home_widgets/presentation/widgets/quran_widget_view.dart';
import 'package:sakina_app/features/home_widgets/presentation/widgets/tasbeeh_widget_view.dart';

Widget _buildTestWrapper(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(360, 360),
    builder: (context, _) => MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('Home Widget Views Render Tests', () {
    const testHadith = WidgetHadithData(
      id: 1,
      text: 'إنما الأعمال بالنيات وإنما لكل امرئ ما نوى',
      narrator: 'عن عمر بن الخطاب رضي الله عنه قال',
      sourceBook: 'صحيح البخاري',
      topic: 'باب بدء الوحي',
    );

    const testPrayer = WidgetPrayerData(
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
        WidgetPrayerItem(name: 'الشروق', time: '6:13 ص', isNext: false),
        WidgetPrayerItem(name: 'الظهر', time: '11:40 ص', isNext: false),
        WidgetPrayerItem(name: 'العصر', time: '2:42 م', isNext: false),
        WidgetPrayerItem(name: 'المغرب', time: '5:04 م', isNext: true),
        WidgetPrayerItem(name: 'العشاء', time: '6:24 م', isNext: false),
      ],
    );

    const testQuran = WidgetQuranData(
      surahName: 'سورة البقرة',
      ayahNumber: 255,
      arabicText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
      reflection: 'أعظم آية في كتاب الله تعالى',
    );

    const testTasbeeh = WidgetTasbeehData(
      phrase: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      shortTitle: 'التسبيح',
      virtue: 'حطت خطاياه وإن كانت مثل زبد البحر',
      targetCount: 33,
      currentCount: 5,
    );

    testWidgets('HadithMediumWidgetView renders properly', (tester) async {
      await tester.pumpWidget(_buildTestWrapper(const HadithMediumWidgetView(data: testHadith)));
      expect(find.text('حَدِيثُ اليَوْم'), findsOneWidget);
      expect(find.textContaining('إنما الأعمال بالنيات'), findsOneWidget);
    });

    testWidgets('HadithSmallWidgetView renders properly', (tester) async {
      await tester.pumpWidget(_buildTestWrapper(const HadithSmallWidgetView(data: testHadith)));
      expect(find.text('حديث اليوم'), findsOneWidget);
    });

    testWidgets('PrayerLargeWidgetView renders properly', (tester) async {
      await tester.pumpWidget(_buildTestWrapper(const PrayerLargeWidgetView(data: testPrayer)));
      expect(find.text('القاهرة'), findsOneWidget);
      expect(find.text('المغرب'), findsWidgets);
      expect(find.text('5:04 م'), findsWidgets);
    });

    testWidgets('PrayerMediumWidgetView renders properly', (tester) async {
      await tester.pumpWidget(_buildTestWrapper(const PrayerMediumWidgetView(data: testPrayer)));
      expect(find.text('القاهرة'), findsOneWidget);
      expect(find.text('الصلاة القادمة'), findsOneWidget);
      expect(find.text('المغرب'), findsOneWidget);
    });

    testWidgets('PrayerSmallWidgetView renders properly', (tester) async {
      await tester.pumpWidget(_buildTestWrapper(const PrayerSmallWidgetView(data: testPrayer)));
      expect(find.text('القاهرة'), findsOneWidget);
      expect(find.text('المغرب'), findsOneWidget);
    });

    testWidgets('QuranMediumWidgetView renders properly', (tester) async {
      await tester.pumpWidget(_buildTestWrapper(const QuranMediumWidgetView(data: testQuran)));
      expect(find.text('آيَةُ اليَوْم'), findsOneWidget);
      expect(find.textContaining('سورة البقرة'), findsWidgets);
    });

    testWidgets('QuranSmallWidgetView renders properly', (tester) async {
      await tester.pumpWidget(_buildTestWrapper(const QuranSmallWidgetView(data: testQuran)));
      expect(find.text('آية اليوم'), findsOneWidget);
      expect(find.textContaining('سورة البقرة'), findsWidgets);
    });

    testWidgets('TasbeehSmallWidgetView renders properly', (tester) async {
      await tester.pumpWidget(_buildTestWrapper(const TasbeehSmallWidgetView(data: testTasbeeh)));
      expect(find.text('التسبيح اليومي'), findsOneWidget);
      expect(find.text('التسبيح'), findsOneWidget);
      expect(find.textContaining('سُبْحَانَ اللَّهِ'), findsOneWidget);
    });
  });
}
