import 'package:dio/dio.dart';

class DioExceptionHandler extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final errorMessage = _handleDioException(err);
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        error: errorMessage,
        response: err.response,
        type: err.type,
        message: err.message,
      ),
    );
  }

  String _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 502 || e.response?.statusCode == 503) {
          return 'Internal server error';
        } else {
          return e.response!.data as String;
        }
      case DioExceptionType.badCertificate:
        return 'Internal Server Error';
      case DioExceptionType.connectionError:
        return 'Connection Error';
      case DioExceptionType.unknown:
        return 'Something went wrong';
    }
  }
}

class CustomException implements Exception {
  CustomException(this.message);

  final dynamic message;

  @override
  String toString() => message as String;
}
