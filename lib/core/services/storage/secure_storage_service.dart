import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class SecureStorageService {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage secureStorage;

  const SecureStorageServiceImpl(this.secureStorage);

  @override
  Future<void> write(String key, String value) =>
      secureStorage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => secureStorage.read(key: key);

  @override
  Future<void> delete(String key) => secureStorage.delete(key: key);

  @override
  Future<void> deleteAll() => secureStorage.deleteAll();
}

