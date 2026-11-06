import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/inaba_recovery/data/datasources/static/inaba_recovery_plans_seed_data.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_cubit.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_state.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_daily_tasks_sheet.dart';

class MockInabaCubit extends Mock implements InabaCubit {}

void main() {
  late MockInabaCubit mockCubit;
  final defaultPlans = InabaRecoveryPlansSeedData.defaultPlans;

  setUp(() {
    mockCubit = MockInabaCubit();
    when(() => mockCubit.state).thenReturn(
      InabaState(
        status: InabaStatus.loaded,
        recoveryPlans: defaultPlans,
      ),
    );
    when(() => mockCubit.stream).thenAnswer(
      (_) => Stream.value(
        InabaState(
          status: InabaStatus.loaded,
          recoveryPlans: defaultPlans,
        ),
      ),
    );
    when(() => mockCubit.completePlanStep(any(), any()))
        .thenAnswer((_) async {});
  });

  Widget createTestWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.lightLuxury,
        darkTheme: AppTheme.darkLuxury,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: child),
        ),
      ),
    );
  }

  group('InabaDailyTasksSheet Widget Tests', () {
    testWidgets('renders practical action, dhikr counter, and completion button',
        (tester) async {
      final plan = defaultPlans.first;
      final step = plan.steps.first;

      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () {
                InabaDailyTasksSheet.show(
                  ctx,
                  planId: plan.id,
                  dayNumber: step.dayNumber,
                  cubit: mockCubit,
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap to open sheet
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.textContaining('مَهَامُ اليَوْمِ 1'), findsOneWidget);
      expect(find.text(step.title), findsOneWidget);
      expect(find.textContaining('الخُطْوَةُ التَّطْبِيقِيَّةُ'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.textContaining('الوِرْدُ النَّبَوِيُّ'),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.textContaining('الوِرْدُ النَّبَوِيُّ'), findsOneWidget);

      expect(find.textContaining('إِتْمَامُ مَهَامِ اليَوْمِ 1'), findsOneWidget);

      // Tap finish button
      await tester.tap(find.textContaining('إِتْمَامُ مَهَامِ اليَوْمِ 1'));
      await tester.pumpAndSettle(const Duration(seconds: 4));

      verify(() => mockCubit.completePlanStep(plan.id, 1)).called(1);
    });
  });
}
