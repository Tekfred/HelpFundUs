import 'dart:async';

import 'package:dio/dio.dart';

typedef AccessTokenProvider = FutureOr<String?> Function();

/// Adds a current bearer token to requests without coupling networking to a
/// specific authentication implementation.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.tokenProvider});

  final AccessTokenProvider tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenProvider();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
