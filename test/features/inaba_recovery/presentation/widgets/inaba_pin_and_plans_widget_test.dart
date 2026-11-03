import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_plans_overview_card.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_sanctuary_locked_view.dart';
import 'package:sakina_app/features/inaba_recovery/data/datasources/static/inaba_recovery_plans_seed_data.dart';

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

  group('Inaba PIN & Plans Widget Tests', () {
    testWidgets('InabaPlansOverviewCard renders plan title and progress',
        (tester) async {
      bool tapped = false;
      final plans = InabaRecoveryPlansSeedData.defaultPlans;

      await tester.pumpWidget(
        createTestWidget(
          InabaPlansOverviewCard(
            plans: plans,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('خُطَطُ التَّعَافِي وَالتَّطَهُّرِ'),
          findsOneWidget);
      expect(find.text(plans.first.title), findsOneWidget);

      await tester.tap(find.text('استعراض'));
      expect(tapped, isTrue);
    });

    testWidgets('InabaSanctuaryLockedView renders numeric keypad and enters digits',
        (tester) async {
      String verifiedPin = '';

      await tester.pumpWidget(
        createTestWidget(
          InabaSanctuaryLockedView(
            hasPin: true,
            onVerifyPin: (pin) {
              verifiedPin = pin;
              return pin == '1234';
            },
            onSetPin: (pin) async => true,
            onResetPin: () async {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('محرابك محمي برمز أرقام'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);

      // Tap 1, 2, 3, 4
      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text('4'));
      await tester.pump();

      expect(verifiedPin, '1234');
    });
  });
}
