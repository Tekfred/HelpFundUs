import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_config.dart';
import 'api_exception.dart';
import 'interceptors/api_logging_interceptor.dart';
import 'interceptors/auth_interceptor.dart';

/// Shared Dio wrapper for all feature data sources.
///
/// It owns common timeouts, bearer-token injection and consistent error
/// mapping. Feature code should depend on this class rather than on Dio.
class ApiClient {
  ApiClient({
    Dio? dio,
    String? baseUrl,
    AccessTokenProvider? tokenProvider,
    bool enableLogging = kDebugMode,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl ?? ApiConfig.baseUrl,
               connectTimeout: ApiConfig.connectTimeout,
               receiveTimeout: ApiConfig.receiveTimeout,
               sendTimeout: ApiConfig.sendTimeout,
               headers: const {'Accept': 'application/json'},
             ),
           ) {
    if (tokenProvider != null) {
      _dio.interceptors.add(AuthInterceptor(tokenProvider: tokenProvider));
    }
    _dio.interceptors.add(ApiLoggingInterceptor(enabled: enableLogging));
  }

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => request<T>(
    path,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
  );

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => request<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options?.copyWith(method: 'POST') ?? Options(method: 'POST'),
    cancelToken: cancelToken,
  );

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => request<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options?.copyWith(method: 'PUT') ?? Options(method: 'PUT'),
    cancelToken: cancelToken,
  );

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => request<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options?.copyWith(method: 'DELETE') ?? Options(method: 'DELETE'),
    cancelToken: cancelToken,
  );

  Future<Response<T>> request<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
