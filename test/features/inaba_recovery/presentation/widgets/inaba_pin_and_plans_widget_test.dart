import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_cubit.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_plans_overview_card.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_recovery_plans_sheet.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_sanctuary_locked_view.dart';
import 'package:sakina_app/features/inaba_recovery/data/datasources/static/inaba_recovery_plans_seed_data.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_active_daily_step_card.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_covenant_activation_card.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/mihrab_numeric_keypad.dart';

class MockInabaCubit extends Mock implements InabaCubit {}

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

    testWidgets('InabaRecoveryPlansSheet renders plans list with CTA and badges',
        (tester) async {
      final mockCubit = MockInabaCubit();
      final plans = InabaRecoveryPlansSeedData.defaultPlans;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => MaterialApp(
            theme: AppTheme.darkLuxury,
            home: Scaffold(
              body: InabaRecoveryPlansSheet(
                plans: plans,
                cubit: mockCubit,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('خُطَطُ الإِنَابَةِ وَالتَّعَافِي المَنْهَجِيَّة'),
          findsOneWidget);
      expect(find.text(plans[0].title), findsOneWidget);
      expect(find.text('ابدأ الآن'), findsWidgets);
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

    testWidgets('InabaCovenantActivationCard renders pledge button and triggers callback',
        (tester) async {
      bool activated = false;

      await tester.pumpWidget(
        createTestWidget(
          InabaCovenantActivationCard(
            onActivate: () => activated = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('عَقْدُ العَزْمِ وَبِدَايَةُ المَسَار'), findsOneWidget);
      expect(find.text('اعْقِدِ العَزْمَ وَابْدَأِ المَسَارَ الآن'), findsOneWidget);

      await tester.tap(find.text('اعْقِدِ العَزْمَ وَابْدَأِ المَسَارَ الآن'));
      expect(activated, isTrue);
    });

    testWidgets('InabaActiveDailyStepCard renders active step action and completion button',
        (tester) async {
      bool completed = false;
      bool viewed = false;
      final plan = InabaRecoveryPlansSeedData.defaultPlans.first;

      await tester.pumpWidget(
        createTestWidget(
          InabaActiveDailyStepCard(
            currentDay: 1,
            plan: plan,
            onCompleteStep: () => completed = true,
            onViewFullPlan: () => viewed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('اليوم 1 من'), findsOneWidget);
      expect(find.text(plan.steps.first.title), findsOneWidget);
      expect(find.text('إتمام خطوة اليوم'), findsOneWidget);

      await tester.tap(find.text('إتمام خطوة اليوم'));
      expect(completed, isTrue);

      await tester.tap(find.text('الخطة كاملة'));
      expect(viewed, isTrue);
    });

    testWidgets('MihrabNumericKeypad renders digits strictly in LTR order (1 left, 3 right)',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          Directionality(
            textDirection: TextDirection.rtl,
            child: MihrabNumericKeypad(
              currentPin: '',
              onDigitPressed: (_) {},
              onBackspacePressed: () {},
              onClearPressed: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final pos1 = tester.getTopLeft(find.text('1')).dx;
      final pos2 = tester.getTopLeft(find.text('2')).dx;
      final pos3 = tester.getTopLeft(find.text('3')).dx;

      expect(pos1 < pos2, isTrue, reason: 'Digit 1 must be to the left of 2');
      expect(pos2 < pos3, isTrue, reason: 'Digit 2 must be to the left of 3');
    });

    testWidgets('InabaActiveDailyStepCard displays tomorrow lock banner when completed today',
        (tester) async {
      final now = DateTime.now();
      final stepCompletedToday = InabaRecoveryPlansSeedData.defaultPlans.first.steps.first.copyWith(
        isCompleted: true,
        completedAt: now,
      );
      final plan = InabaRecoveryPlansSeedData.defaultPlans.first.copyWith(
        steps: [
          stepCompletedToday,
          ...InabaRecoveryPlansSeedData.defaultPlans.first.steps.skip(1),
        ],
      );

      await tester.pumpWidget(
        createTestWidget(
          InabaActiveDailyStepCard(
            currentDay: 1,
            plan: plan,
            onCompleteStep: () {},
            onViewFullPlan: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('أتممت مهام اليوم بحمد الله • تُفتح مهام اليوم التالي غداً بإذن الله'),
        findsOneWidget,
      );
      expect(find.text('أتممت مهمة اليوم بحمد الله'), findsOneWidget);
    });
  });
}
