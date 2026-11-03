import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/inaba_recovery/domain/services/mihrab_pin_service.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  late MockPreferencesService mockPrefs;
  late MihrabPinService pinService;

  const pinKey = 'sakina_mihrab_sanctuary_pin_v1';

  setUp(() {
    mockPrefs = MockPreferencesService();
    pinService = MihrabPinServiceImpl(mockPrefs);
  });

  group('MihrabPinService Tests', () {
    test('hasPin returns false when no pin is stored', () {
      when(() => mockPrefs.getString(pinKey)).thenReturn(null);
      expect(pinService.hasPin(), isFalse);
    });

    test('hasPin returns true when valid 4-digit pin is stored', () {
      when(() => mockPrefs.getString(pinKey)).thenReturn('1234');
      expect(pinService.hasPin(), isTrue);
    });

    test('verifyPin returns true when matching pin is entered', () {
      when(() => mockPrefs.getString(pinKey)).thenReturn('5678');
      expect(pinService.verifyPin('5678'), isTrue);
      expect(pinService.verifyPin('0000'), isFalse);
    });

    test('setPin saves 4-digit pin to preferences', () async {
      when(() => mockPrefs.setString(pinKey, '9876'))
          .thenAnswer((_) async => true);

      final result = await pinService.setPin('9876');
      expect(result, isTrue);
      verify(() => mockPrefs.setString(pinKey, '9876')).called(1);
    });

    test('removePin clears stored pin from preferences', () async {
      when(() => mockPrefs.remove(pinKey)).thenAnswer((_) async => true);

      final result = await pinService.removePin();
      expect(result, isTrue);
      verify(() => mockPrefs.remove(pinKey)).called(1);
    });
  });
}

