import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_spiritual_habits_card.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: ThemeData(
          extensions: const [AppColorsScheme.dark],
        ),
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );
  }

  group('MaladhSpiritualHabitsCard Widget Tests', () {
    testWidgets('renders title, progress, and 3 spiritual habit tiles',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const MaladhSpiritualHabitsCard()),
      );
      await tester.pumpAndSettle();

      expect(find.text('عَادَاتُ السَّكِينَةِ اليَوْمِيَّة'), findsOneWidget);
      expect(find.text('أَذْكَارُ الصَّبَاحِ أَوِ المَسَاءِ'), findsOneWidget);
      expect(find.text('قِرَاءَةُ صَفْحَةٍ مِنَ القُرْآنِ'), findsOneWidget);
      expect(find.text('رَكْعَةُ الوِتْرِ أَوِ الاسْتِغْفَار'), findsOneWidget);
      expect(find.text('0 من 3'), findsOneWidget);
    });

    testWidgets('toggling habit marks it done and updates count to 1 of 3',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const MaladhSpiritualHabitsCard()),
      );
      await tester.pumpAndSettle();

      expect(find.text('0 من 3'), findsOneWidget);

      // Tap on Athkar habit
      await tester.tap(find.text('أَذْكَارُ الصَّبَاحِ أَوِ المَسَاءِ'));
      await tester.pumpAndSettle();

      expect(find.text('1 من 3'), findsOneWidget);
    });

    testWidgets('completing all 3 habits displays celebratory Hadith banner',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const MaladhSpiritualHabitsCard()),
      );
      await tester.pumpAndSettle();

      // Check all 3 habits
      await tester.tap(find.text('أَذْكَارُ الصَّبَاحِ أَوِ المَسَاءِ'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('قِرَاءَةُ صَفْحَةٍ مِنَ القُرْآنِ'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('رَكْعَةُ الوِتْرِ أَوِ الاسْتِغْفَار'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 4));

      expect(find.text('3 من 3'), findsOneWidget);
      expect(
        find.text('قال ﷺ: «أَحَبُّ الأَعْمَالِ إِلَى اللَّهِ أَدْوَمُهَا وَإِنْ قَلَّ»'),
        findsOneWidget,
      );
    });
  });
}
