import 'package:dio/dio.dart';

enum ApiErrorType {
  configuration,
  cancelled,
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  noConnection,
  unauthorised,
  forbidden,
  notFound,
  server,
  invalidResponse,
  unknown,
}

/// A transport-independent error that repositories can expose to features.
class ApiException implements Exception {
  const ApiException({
    required this.type,
    required this.message,
    this.statusCode,
    this.data,
  });

  final ApiErrorType type;
  final String message;
  final int? statusCode;
  final Object? data;

  factory ApiException.fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final responseMessage = _messageFrom(data);

    if (error.type == DioExceptionType.cancel) {
      return ApiException(
        type: ApiErrorType.cancelled,
        message: 'The request was cancelled.',
        statusCode: statusCode,
        data: data,
      );
    }
    if (error.type == DioExceptionType.connectionTimeout) {
      return ApiException(
        type: ApiErrorType.connectionTimeout,
        message: 'Unable to connect. Please try again.',
        statusCode: statusCode,
        data: data,
      );
    }
    if (error.type == DioExceptionType.sendTimeout) {
      return ApiException(
        type: ApiErrorType.sendTimeout,
        message: 'The request took too long to send.',
        statusCode: statusCode,
        data: data,
      );
    }
    if (error.type == DioExceptionType.receiveTimeout) {
      return ApiException(
        type: ApiErrorType.receiveTimeout,
        message: 'The server took too long to respond.',
        statusCode: statusCode,
        data: data,
      );
    }
    if (error.type == DioExceptionType.connectionError) {
      return ApiException(
        type: ApiErrorType.noConnection,
        message: 'No internet connection is available.',
        statusCode: statusCode,
        data: data,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return ApiException(
        type: ApiErrorType.server,
        message:
            responseMessage ??
            'Something went wrong on our side. Please try again.',
        statusCode: statusCode,
        data: data,
      );
    }

    return switch (statusCode) {
      401 => ApiException(
        type: ApiErrorType.unauthorised,
        message:
            responseMessage ??
            'Your session has expired. Please sign in again.',
        statusCode: statusCode,
        data: data,
      ),
      403 => ApiException(
        type: ApiErrorType.forbidden,
        message:
            responseMessage ??
            'You do not have permission to perform this action.',
        statusCode: statusCode,
        data: data,
      ),
      404 => ApiException(
        type: ApiErrorType.notFound,
        message:
            responseMessage ?? 'The requested resource could not be found.',
        statusCode: statusCode,
        data: data,
      ),
      _ => ApiException(
        type: ApiErrorType.invalidResponse,
        message:
            responseMessage ??
            'We received an unexpected response. Please try again.',
        statusCode: statusCode,
        data: data,
      ),
    };
  }

  static String? _messageFrom(Object? data) {
    if (data is! Map) return null;
    for (final key in ['message', 'error', 'detail']) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  @override
  String toString() => 'ApiException($type, $statusCode): $message';
}
