import 'package:dio/dio.dart';

class DioExceptionHandler extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = _handleDioException(err);
    handler.next(DioException(
        requestOptions: err.requestOptions, message: errorMessage));
  }

  String _handleDioException(DioException e) {
    final String errorMessage;
    switch (e.type) {
      case DioExceptionType.cancel:
        errorMessage = 'Request was cancelled';
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive timeout';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Send timeout';
        break;
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 502 || e.response?.statusCode == 503) {
          errorMessage = 'Internal server error';
        } else {
          errorMessage = e.response!.data;
        }
        break;
      case DioExceptionType.badCertificate:
        errorMessage = "Internal Server Error";
        break;
      case DioExceptionType.connectionError:
        errorMessage = "Connection Error";
        break;
      case DioExceptionType.unknown:
      default:
        errorMessage = 'Something went wrong';
        break;
    }
    return errorMessage;
  }
}
