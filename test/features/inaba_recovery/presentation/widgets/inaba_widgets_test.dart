import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_emergency_haven_card.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_portals_grid.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_quranic_hope_card.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_streak_progress_card.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_top_header.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.lightLuxury,
        darkTheme: AppTheme.darkLuxury,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SingleChildScrollView(
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  group('Inaba Widgets Tests', () {
    testWidgets('InabaTopHeader renders title and subtitle correctly',
        (tester) async {
      bool infoTapped = false;
      await tester.pumpWidget(
        createTestWidget(
          InabaTopHeader(onInfoTap: () => infoTapped = true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الإِنَابَةُ وَالتَّعَافِي'), findsOneWidget);
      expect(find.text('رفيقك في رحلة العودة إلى الله'), findsOneWidget);

      await tester.tap(find.byType(InkWell));
      expect(infoTapped, isTrue);
    });

    testWidgets(
        'InabaEmergencyHavenCard renders emergency text and responds to tap',
        (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        createTestWidget(
          InabaEmergencyHavenCard(onTap: () => tapped = true),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('أَشْعُرُ بِضَعْفٍ الآن'), findsOneWidget);
      expect(find.text('اضغط هنا للُّجوء الفوري إلى الله'), findsOneWidget);

      await tester.tap(find.text('أَشْعُرُ بِضَعْفٍ الآن'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('InabaQuranicHopeCard renders the verse and surah reference',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const InabaQuranicHopeCard(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('سُورَةُ الزُّمَرِ • الآيَةُ ٥٣'), findsOneWidget);
    });

    testWidgets('InabaStreakProgressCard renders days and progress',
        (tester) async {
      bool treeTapped = false;
      await tester.pumpWidget(
        createTestWidget(
          InabaStreakProgressCard(
            streakDays: 14,
            progress: 0.7,
            levelTitle: 'الاِلْتِزَامُ',
            statusText: 'حتى الآن في طريق النقاء',
            onTreeTap: () => treeTapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('مَسَارُ التَّعَافِي'), findsOneWidget);
      expect(find.text('14'), findsOneWidget);
      expect(find.text('يَوْماً'), findsOneWidget);
      expect(find.text('الاِلْتِزَامُ'), findsOneWidget);

      await tester.tap(find.text('الاِلْتِزَامُ'));
      expect(treeTapped, isTrue);
    });

    testWidgets('InabaPortalsGrid renders all 5 spiritual portals',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          InabaPortalsGrid(
            onGoodDeedsTap: () {},
            onConfessionTap: () {},
            onCovenantTap: () {},
            onTreeTap: () {},
            onHopeDoseTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('أَبْوَابُ الرُّجُوعِ وَالإِنَابَةِ'), findsOneWidget);
      expect(find.text('الحَسَنَاتُ المَاحِيَةُ'), findsOneWidget);
      expect(find.text('مِحْرَابُ البَوْحِ'), findsOneWidget);
      expect(find.text('تَجْدِيدُ العَهْدِ وَالتَّوْبَةِ'), findsOneWidget);
      expect(find.text('شَجَرَةُ النُّورِ'), findsOneWidget);
      expect(find.text('جُرْعَةُ أَمَلٍ يَوْمِيَّةٍ'), findsOneWidget);
    });
  });
}
