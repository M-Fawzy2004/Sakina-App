import 'package:sakina_app/core/errors/exceptions.dart';
import 'package:sakina_app/core/errors/failures.dart';

/// Centralized utility translating technical exceptions, network errors,
/// and failures into compassionate, dignified, user-facing Arabic messages.
abstract final class ErrorMapper {
  /// Maps any audio playback or streaming error to a friendly user message.
  static String mapAudioError(dynamic error) {
    if (error == null) {
      return 'تعذر تشغيل المقطع الصوتي، يرجى المحاولة لاحقاً';
    }

    final raw = error.toString().toLowerCase();

    // 1. Network / Connectivity issues
    if (raw.contains('socketexception') ||
        raw.contains('failed host lookup') ||
        raw.contains('network') ||
        raw.contains('connection refused') ||
        raw.contains('timed out') ||
        raw.contains('clientexception') ||
        raw.contains('offline') ||
        raw.contains('no address associated')) {
      return 'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة للاستماع للتلاوة';
    }

    // 2. Resource not found / dead stream link (404 / Source error)
    if (raw.contains('404') ||
        raw.contains('not found') ||
        raw.contains('source error') ||
        raw.contains('media unavailable') ||
        raw.contains('empty source')) {
      return 'عذراً، تسجيل هذه السورة غير متاح حالياً على الخادم، يرجى تجربة سورة أخرى';
    }

    // 3. Server timeout or temporary server issue (500, 502, 503)
    if (raw.contains('500') ||
        raw.contains('502') ||
        raw.contains('503') ||
        raw.contains('server error') ||
        raw.contains('bad gateway')) {
      return 'خادم البث يشهد ضغطاً مؤقتاً، يرجى المحاولة بعد قليل';
    }

    // 4. Decode or Audio Player initialization error
    if (raw.contains('decod') ||
        raw.contains('format') ||
        raw.contains('codec') ||
        raw.contains('playerexception') ||
        raw.contains('platformexception')) {
      return 'تعذر تهيئة مشغل الصوت لهذه التلاوة، يرجى إعادة المحاولة';
    }

    // 5. Existing Arabic message without technical trace
    if (error is AppException && !_containsTechnicalArtifacts(error.message)) {
      return cleanMessage(error.message);
    }
    if (error is Failure && !_containsTechnicalArtifacts(error.message)) {
      return cleanMessage(error.message);
    }

    return 'تعذر تشغيل التلاوة حالياً، يرجى المحاولة لاحقاً';
  }

  /// Maps general data or repository errors to polite Arabic messages.
  static String mapGeneralError(dynamic error) {
    if (error == null) {
      return 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً';
    }

    if (error is NetworkFailure || error is NetworkException) {
      return 'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة';
    }
    if (error is AudioPlaybackFailure || error is AudioPlaybackException) {
      return 'تعذر تشغيل المقطع الصوتي، يرجى المحاولة لاحقاً';
    }
    if (error is CacheFailure || error is CacheException) {
      return 'تعذر الوصول إلى البيانات المخزنة، يرجى المحاولة مجدداً';
    }

    final raw = error.toString().toLowerCase();

    if (raw.contains('socketexception') ||
        raw.contains('failed host lookup') ||
        raw.contains('network') ||
        raw.contains('connection refused') ||
        raw.contains('clientexception')) {
      return 'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة';
    }

    if (error is Failure && !_containsTechnicalArtifacts(error.message)) {
      return cleanMessage(error.message);
    }

    return 'حدث خطأ غير متوقع، يرجى المحاولة مجدداً في وقت لاحق';
  }

  /// Sanitizes any raw message to strip out developer traces, class names, and stack traces.
  static String cleanMessage(String? rawMessage) {
    if (rawMessage == null || rawMessage.trim().isEmpty) {
      return 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً';
    }

    // If message contains developer exception tags or stack traces, filter them
    if (_containsTechnicalArtifacts(rawMessage)) {
      // Extract the human prefix before colon if available in Arabic
      final colonIndex = rawMessage.indexOf(':');
      if (colonIndex > 0) {
        final prefix = rawMessage.substring(0, colonIndex).trim();
        if (_isArabic(prefix) && !_containsTechnicalArtifacts(prefix)) {
          return prefix;
        }
      }
      return 'تعذر إتمام العملية، يرجى المحاولة مجدداً';
    }

    return rawMessage.trim();
  }

  static bool _containsTechnicalArtifacts(String text) {
    final lower = text.toLowerCase();
    return lower.contains('exception') ||
        lower.contains('error:') ||
        lower.contains('stacktrace') ||
        lower.contains('nullcheck') ||
        lower.contains('nosuchmethod') ||
        lower.contains('failed host lookup') ||
        lower.contains('errno =') ||
        lower.contains('os error') ||
        lower.contains('http status') ||
        lower.contains('source error') ||
        lower.contains('typeerror') ||
        lower.contains('format_error');
  }

  static bool _isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}
