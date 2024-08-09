import 'package:dio/dio.dart';

class DioExceptionHandler extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final errorMessage = _handleDioException(err);
    handler.next(DioException(
        requestOptions: err.requestOptions, message: errorMessage,),);
  }

  String _handleDioException(DioException e) {
    final String errorMessage;
    switch (e.type) {
      case DioExceptionType.cancel:
        errorMessage = 'Request was cancelled';
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout';
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive timeout';
      case DioExceptionType.sendTimeout:
        errorMessage = 'Send timeout';
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 502 || e.response?.statusCode == 503) {
          errorMessage = 'Internal server error';
        } else {
          errorMessage = e.response!.data as String;
        }
      case DioExceptionType.badCertificate:
        errorMessage = 'Internal Server Error';
      case DioExceptionType.connectionError:
        errorMessage = 'Connection Error';
      case DioExceptionType.unknown:
        errorMessage = 'Something went wrong';
    }
    return errorMessage;
  }
}
