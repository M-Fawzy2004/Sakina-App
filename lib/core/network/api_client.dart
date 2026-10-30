import 'package:dio/dio.dart';
import 'package:sakina_app/core/errors/exceptions.dart';
import 'package:sakina_app/core/network/dio_client.dart';

abstract interface class ApiClient {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
}

class ApiClientImpl implements ApiClient {
  final DioClient dioClient;

  const ApiClientImpl({required this.dioClient});

  Dio get _dio => dioClient.dio;

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw ServerException(message: e.message ?? 'فشل طلب الخادم');
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw ServerException(message: e.message ?? 'فشل إرسال البيانات');
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw ServerException(message: e.message ?? 'فشل تحديث البيانات');
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw ServerException(message: e.message ?? 'فشل حذف البيانات');
    }
  }
}

