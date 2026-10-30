import 'package:dio/dio.dart';
import 'package:sakina_app/core/constants/app_constants.dart';
import 'package:sakina_app/core/errors/exceptions.dart';
import 'package:sakina_app/core/network/error_interceptor.dart';
import 'package:sakina_app/core/network/network_info.dart';

class DioClient {
  final NetworkInfo networkInfo;
  late final Dio dio;

  DioClient({required this.networkInfo, Dio? customDio}) {
    dio = customDio ??
        Dio(
          BaseOptions(
            connectTimeout: AppConstants.connectTimeout,
            receiveTimeout: AppConstants.receiveTimeout,
            sendTimeout: AppConstants.sendTimeout,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final connected = await networkInfo.isConnected;
          if (!connected) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                error: const NetworkException(
                  message: 'لا يوجد اتصال بالإنترنت، يرجى تفعيل الشبكة والمحاولة مجدداً',
                ),
              ),
            );
          }
          return handler.next(options);
        },
      ),
      ErrorInterceptor(),
    ]);
  }
}

