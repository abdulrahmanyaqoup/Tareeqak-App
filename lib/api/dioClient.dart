import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:finalproject/api/dioExceptionHandler.dart';
import 'package:finalproject/env/env.dart';

Dio createDio() {
  var dio = Dio();
  dio.options = BaseOptions(
    baseUrl: Env.URI,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  );
  dio.options.headers = {
    'x-api-key': Env.API_KEY,
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };
  print(dio.options.headers);
  dio.httpClientAdapter = Http2Adapter(
    ConnectionManager(
      idleTimeout: const Duration(milliseconds: 10000),
      onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
    ),
  );

  dio.interceptors.add(DioExceptionHandler());

  return dio;
}

final Dio dio = createDio();
