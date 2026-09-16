import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logs request metadata in debug builds without exposing headers or payloads.
class ApiLoggingInterceptor extends Interceptor {
  ApiLoggingInterceptor({this.enabled = kDebugMode});

  final bool enabled;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      debugPrint('API → ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (enabled) {
      debugPrint('API ← ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      debugPrint(
        'API × ${err.response?.statusCode ?? err.type} ${err.requestOptions.uri}',
      );
    }
    handler.next(err);
  }
}
