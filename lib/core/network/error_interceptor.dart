import 'package:dio/dio.dart';
import 'package:sakina_app/core/errors/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapDioExceptionToAppException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
        message: exception.message,
      ),
    );
  }

  AppException _mapDioExceptionToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'انتهت مهلة الاتصال بالخادم، يرجى التحقق من الشبكة',
        );

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final responseData = err.response?.data;
        String message = 'حدث خطأ في الخادم ($statusCode)';

        if (responseData is Map<String, dynamic> && responseData.containsKey('message')) {
          message = responseData['message'].toString();
        } else if (responseData is String && responseData.isNotEmpty) {
          message = responseData;
        }

        if (statusCode == 401 || statusCode == 403) {
          return UnauthorizedException(message: message, statusCode: statusCode);
        }

        return ServerException(message: message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return const UnexpectedException(message: 'تم إلغاء الطلب من قبل المستخدم');

      case DioExceptionType.badCertificate:
        return const NetworkException(message: 'شهادة أمان الخادم غير موثوقة');

      case DioExceptionType.unknown:
      default:
        return UnexpectedException(
          message: err.message ?? 'حدث خطأ غير معروف في معالجة الشبكة',
        );
    }
  }
}
