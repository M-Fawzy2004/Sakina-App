import 'package:sakina_app/core/services/storage/preferences_service.dart';

/// Local storage service managing numeric PIN passcode for the Mihrab Private Sanctuary.
/// Guarantees offline, secure, biometric-free local authentication.
abstract interface class MihrabPinService {
  bool hasPin();
  bool verifyPin(String pin);
  Future<bool> setPin(String pin);
  Future<bool> removePin();
}

class MihrabPinServiceImpl implements MihrabPinService {
  final PreferencesService _prefs;

  static const String _keyMihrabPin = 'sakina_mihrab_sanctuary_pin_v1';

  const MihrabPinServiceImpl(this._prefs);

  @override
  bool hasPin() {
    final stored = _prefs.getString(_keyMihrabPin);
    return stored != null && stored.trim().length >= 4;
  }

  @override
  bool verifyPin(String pin) {
    final stored = _prefs.getString(_keyMihrabPin);
    if (stored == null) return false;
    return stored.trim() == pin.trim();
  }

  @override
  Future<bool> setPin(String pin) async {
    if (pin.trim().length < 4) return false;
    return _prefs.setString(_keyMihrabPin, pin.trim());
  }

  @override
  Future<bool> removePin() async {
    return _prefs.remove(_keyMihrabPin);
  }
}

