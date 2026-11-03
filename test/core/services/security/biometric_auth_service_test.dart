import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/services/security/biometric_auth_service.dart';

class MockLocalAuthentication extends Mock implements LocalAuthentication {}

void main() {
  late MockLocalAuthentication mockAuth;
  late BiometricAuthService service;

  setUp(() {
    mockAuth = MockLocalAuthentication();
    service = BiometricAuthServiceImpl(mockAuth);
  });

  group('BiometricAuthService Tests', () {
    test('canAuthenticate returns true when device supports biometrics',
        () async {
      when(() => mockAuth.canCheckBiometrics).thenAnswer((_) async => true);
      when(() => mockAuth.isDeviceSupported()).thenAnswer((_) async => true);

      final result = await service.canAuthenticate();
      expect(result, isTrue);
    });

    test('canAuthenticate returns false when PlatformException thrown',
        () async {
      when(() => mockAuth.canCheckBiometrics)
          .thenThrow(PlatformException(code: 'ERROR'));

      final result = await service.canAuthenticate();
      expect(result, isFalse);
    });

    test('authenticate delegates to LocalAuthentication with fallback allowed',
        () async {
      when(() => mockAuth.canCheckBiometrics).thenAnswer((_) async => true);
      when(() => mockAuth.isDeviceSupported()).thenAnswer((_) async => true);
      when(
        () => mockAuth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
          persistAcrossBackgrounding:
              any(named: 'persistAcrossBackgrounding'),
        ),
      ).thenAnswer((_) async => true);

      final success = await service.authenticate(
        localizedReason: 'تأكيد هويتك',
      );

      expect(success, isTrue);
    });

    test('authenticate returns false when PlatformException occurs',
        () async {
      when(() => mockAuth.canCheckBiometrics).thenAnswer((_) async => true);
      when(() => mockAuth.isDeviceSupported()).thenAnswer((_) async => true);
      when(
        () => mockAuth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
          persistAcrossBackgrounding:
              any(named: 'persistAcrossBackgrounding'),
        ),
      ).thenThrow(PlatformException(code: 'CANCELLED'));

      final success = await service.authenticate(
        localizedReason: 'تأكيد هويتك',
      );

      expect(success, isFalse);
    });
  });
}

