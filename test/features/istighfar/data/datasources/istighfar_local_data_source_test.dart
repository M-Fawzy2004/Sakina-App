import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/features/istighfar/data/datasources/istighfar_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late IstighfarLocalDataSourceImpl dataSource;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    dataSource = IstighfarLocalDataSourceImpl(sharedPreferences: mockPrefs);
  });

  group('IstighfarLocalDataSource Tests', () {
    test('getIstighfarItems loads default items with cached preferences', () async {
      when(() => mockPrefs.getInt(any())).thenReturn(null);

      final items = await dataSource.getIstighfarItems();

      expect(items.isNotEmpty, isTrue);
      expect(items.first.id, 'istighfar_1');
      expect(items.first.currentCycleCount, 0);
      expect(items.first.lifetimeCount, 0);
    });

    test('incrementCount updates current cycle and lifetime count', () async {
      when(() => mockPrefs.getInt('istighfar_lifetime_istighfar_1')).thenReturn(10);
      when(() => mockPrefs.getInt('istighfar_current_istighfar_1')).thenReturn(5);
      when(() => mockPrefs.getInt('istighfar_target_istighfar_1')).thenReturn(33);
      when(() => mockPrefs.getInt('istighfar_laps_istighfar_1')).thenReturn(0);
      when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) async => true);

      final updated = await dataSource.incrementCount('istighfar_1');

      expect(updated.currentCycleCount, 6);
      expect(updated.lifetimeCount, 11);
      verify(() => mockPrefs.setInt('istighfar_lifetime_istighfar_1', 11)).called(1);
      verify(() => mockPrefs.setInt('istighfar_current_istighfar_1', 6)).called(1);
    });

    test('incrementCount completes lap and resets cycle when hitting target', () async {
      when(() => mockPrefs.getInt('istighfar_lifetime_istighfar_1')).thenReturn(32);
      when(() => mockPrefs.getInt('istighfar_current_istighfar_1')).thenReturn(32);
      when(() => mockPrefs.getInt('istighfar_target_istighfar_1')).thenReturn(33);
      when(() => mockPrefs.getInt('istighfar_laps_istighfar_1')).thenReturn(0);
      when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) async => true);

      final updated = await dataSource.incrementCount('istighfar_1');

      expect(updated.currentCycleCount, 0);
      expect(updated.lapsCompleted, 1);
      verify(() => mockPrefs.setInt('istighfar_laps_istighfar_1', 1)).called(1);
    });

    test('resetCurrentCycle resets cycle to 0 without affecting lifetime', () async {
      when(() => mockPrefs.getInt('istighfar_lifetime_istighfar_1')).thenReturn(50);
      when(() => mockPrefs.getInt('istighfar_target_istighfar_1')).thenReturn(33);
      when(() => mockPrefs.getInt('istighfar_laps_istighfar_1')).thenReturn(1);
      when(() => mockPrefs.setInt('istighfar_current_istighfar_1', 0))
          .thenAnswer((_) async => true);

      final reset = await dataSource.resetCurrentCycle('istighfar_1');

      expect(reset.currentCycleCount, 0);
      expect(reset.lifetimeCount, 50);
      verify(() => mockPrefs.setInt('istighfar_current_istighfar_1', 0)).called(1);
    });

    test('getTotalLifetimeCount calculates sum of all items', () async {
      when(() => mockPrefs.getInt(any())).thenReturn(0);
      when(() => mockPrefs.getInt('istighfar_lifetime_istighfar_1')).thenReturn(100);
      when(() => mockPrefs.getInt('istighfar_lifetime_subhanallah')).thenReturn(50);

      final total = await dataSource.getTotalLifetimeCount();

      expect(total, 150);
    });
  });
}
