import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/errors/error_mapper.dart';
import 'package:sakina_app/core/errors/exceptions.dart';
import 'package:sakina_app/core/errors/failures.dart';

void main() {
  group('ErrorMapper Tests', () {
    test('mapAudioError translates SocketException into offline message', () {
      final message = ErrorMapper.mapAudioError(
        'SocketException: OS Error: Failed host lookup: server11.mp3quran.net',
      );
      expect(message, contains('لا يوجد اتصال بالإنترنت'));
    });

    test('mapAudioError translates 404 and source error into missing stream message', () {
      final message = ErrorMapper.mapAudioError('(0) Source error: 404 Not Found');
      expect(message, contains('غير متاح حالياً'));
    });

    test('mapAudioError translates 500 server error into server pressure message', () {
      final message = ErrorMapper.mapAudioError('HttpException: 500 Server Error');
      expect(message, contains('ضغطاً مؤقتاً'));
    });

    test('mapAudioError translates PlayerException into initialization message', () {
      final message = ErrorMapper.mapAudioError('PlayerException: decode error');
      expect(message, contains('مشغل الصوت'));
    });

    test('mapAudioError handles AudioPlaybackFailure gracefully', () {
      const failure = AudioPlaybackFailure(message: 'تعذر تشغيل المقطع');
      final message = ErrorMapper.mapAudioError(failure);
      expect(message, 'تعذر تشغيل المقطع');
    });

    test('mapGeneralError maps NetworkFailure and NetworkException', () {
      const failure = NetworkFailure();
      expect(ErrorMapper.mapGeneralError(failure), contains('اتصال بالإنترنت'));

      const exception = NetworkException(message: 'Network down');
      expect(ErrorMapper.mapGeneralError(exception), contains('اتصال بالإنترنت'));
    });

    test('cleanMessage strips out developer exception stack artifacts', () {
      final cleaned = ErrorMapper.cleanMessage(
        'فشل استرجاع التلاوة: SocketException: Failed host lookup',
      );
      expect(cleaned, 'فشل استرجاع التلاوة');
      expect(cleaned.contains('SocketException'), isFalse);
    });

    test('cleanMessage returns polite fallback on raw unhandled error', () {
      final cleaned = ErrorMapper.cleanMessage(
        'TypeError: Null check operator used on a null value',
      );
      expect(cleaned, 'تعذر إتمام العملية، يرجى المحاولة مجدداً');
    });

    test('cleanMessage preserves clean Arabic text', () {
      const original = 'تم تحديث البيانات بنجاح';
      expect(ErrorMapper.cleanMessage(original), original);
    });
  });
}
