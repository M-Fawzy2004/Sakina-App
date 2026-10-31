/// Base contract for all data and infrastructure layer exceptions.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() =>
      '$runtimeType(message: $message, statusCode: $statusCode)';
}

/// Thrown when remote API communication fails or returns non-2xx status.
class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode});
}

/// Thrown when device has no active internet interface or connection times out.
class NetworkException extends AppException {
  const NetworkException({required super.message, super.statusCode});
}

/// Thrown when local cache or key-value storage retrieval/persistence fails.
class CacheException extends AppException {
  const CacheException({required super.message, super.statusCode});
}

/// Thrown when SQLite database query, initialization, or migration fails.
class DatabaseException extends AppException {
  const DatabaseException({required super.message, super.statusCode});
}

/// Thrown when audio streaming, decoding, or pre-buffering fails.
class AudioPlaybackException extends AppException {
  const AudioPlaybackException({required super.message, super.statusCode});
}

/// Thrown when a secure token or auth credential is missing or rejected.
class UnauthorizedException extends AppException {
  const UnauthorizedException({required super.message, super.statusCode});
}

/// Thrown when an unhandled, unexpected, or cancellation error occurs.
class UnexpectedException extends AppException {
  const UnexpectedException({required super.message, super.statusCode});
}
