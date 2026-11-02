import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_prayer_context_bar.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_prayer_schedule_card.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.charcoalLuxury,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: child,
          ),
        ),
      ),
    );
  }

  group('MaladhPrayerScheduleCard Widget Tests', () {
    testWidgets('renders all 5 fard prayers and supplementary celestial times', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const MaladhPrayerScheduleCard(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify 5 Fard Prayers
      expect(find.text('الفجر'), findsOneWidget);
      expect(find.text('الظهر'), findsOneWidget);
      expect(find.text('العصر'), findsOneWidget);
      expect(find.text('المغرب'), findsOneWidget);
      expect(find.text('العشاء'), findsOneWidget);

      // Verify Supplementary Sunnah Times
      expect(find.text('الشروق'), findsOneWidget);
      expect(find.text('منتصف الليل'), findsOneWidget);
      expect(find.text('الثلث الأخير'), findsOneWidget);

      // Verify excluded tabs row is NOT present
      expect(find.text('المنوعة'), findsNothing);
      expect(find.text('القبلة'), findsNothing);
      expect(find.text('المفضلة'), findsNothing);
      expect(find.text('العداد'), findsNothing);
    });
  });

  group('MaladhPrayerContextBar Widget Tests', () {
    testWidgets('renders context bar with Hijri tab, bounding prayers, and countdown ticker', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const MaladhPrayerContextBar(
            hijriDate: '21 جمادى الأولى',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Hijri Center Tab
      expect(find.text('21'), findsOneWidget);
      expect(find.text('جمادى الأولى'), findsOneWidget);

      // Verify Live Countdown contains 'بعد'
      expect(find.textContaining('بعد'), findsOneWidget);
    });
  });
}
