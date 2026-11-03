import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/inaba_recovery/data/datasources/inaba_recovery_plans_local_data_source.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  late MockPreferencesService mockPrefs;
  late InabaRecoveryPlansLocalDataSource dataSource;

  const plansKey = 'sakina_inaba_recovery_plans_v1';

  setUp(() {
    mockPrefs = MockPreferencesService();
    dataSource = InabaRecoveryPlansLocalDataSourceImpl(mockPrefs);
  });

  group('InabaRecoveryPlansLocalDataSource Tests', () {
    test('returns default plans when no saved plans in preferences', () async {
      when(() => mockPrefs.getString(plansKey)).thenReturn(null);
      when(() => mockPrefs.setString(plansKey, any()))
          .thenAnswer((_) async => true);

      final plans = await dataSource.getRecoveryPlans();
      expect(plans.length, 3);
      expect(plans[0].id, 'plan_7_days');
      expect(plans[1].id, 'plan_30_days');
      expect(plans[2].id, 'plan_sos_urgent');
    });

    test('togglePlanDayStep updates step completion and persists to preferences',
        () async {
      when(() => mockPrefs.getString(plansKey)).thenReturn(null);
      when(() => mockPrefs.setString(plansKey, any()))
          .thenAnswer((_) async => true);

      final updatedPlan = await dataSource.togglePlanDayStep(
        planId: 'plan_7_days',
        dayNumber: 3,
      );

      final day3 = updatedPlan.steps.firstWhere((s) => s.dayNumber == 3);
      expect(day3.isCompleted, isTrue);
    });
  });
}

