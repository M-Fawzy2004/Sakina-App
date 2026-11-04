import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Service contract managing native biometric & device passcode verification.
abstract interface class BiometricAuthService {
  Future<bool> canAuthenticate();
  Future<bool> authenticate({required String localizedReason});
  Future<List<BiometricType>> getAvailableBiometrics();
}

/// Production implementation of [BiometricAuthService] delegating to [LocalAuthentication].
class BiometricAuthServiceImpl implements BiometricAuthService {
  final LocalAuthentication _auth;

  const BiometricAuthServiceImpl(this._auth);

  @override
  Future<bool> canAuthenticate() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck || isSupported;
    } on PlatformException catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticate({required String localizedReason}) async {
    try {
      final isSupported = await canAuthenticate();
      if (!isSupported) {
        return false;
      }

      return await _auth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException catch (_) {
      return false;
    }
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      return const [];
    } 
  }
}
