import 'package:equatable/equatable.dart';

/// Immutable domain layer failure contract returned by Repositories and UseCases.
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة',
    super.statusCode,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'تعذر الوصول إلى البيانات المخزنة محلياً',
    super.statusCode,
  });
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, super.statusCode});
}

class AudioPlaybackFailure extends Failure {
  const AudioPlaybackFailure({
    super.message = 'تعذر تشغيل المقطع الصوتي، يرجى المحاولة لاحقاً',
    super.statusCode,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'جلسة المستخدم غير صالحة أو منتهية',
    super.statusCode,
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً',
    super.statusCode,
  });
}

