import 'package:dio/dio.dart';

class DioErrorHandler extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = handleDioError(err);
    handler.next(DioException(
        requestOptions: err.requestOptions, message: errorMessage));
  }

  String handleDioError(DioException e) {
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
        errorMessage = e.response!.data;
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Internal server error';
        break;
      case DioExceptionType.unknown:
      default:
        errorMessage = 'Something went wrong';
        break;
    }
    return errorMessage;
  }
}
