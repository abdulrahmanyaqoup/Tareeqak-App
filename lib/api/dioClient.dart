import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:finalproject/api/dioErorrHandler.dart';
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
    'Content-Security-Policy': "default-src 'self'",
    'X-Content-Type-Options': 'nosniff',
    'X-Frame-Options': 'DENY',
    'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
    'X-XSS-Protection': '1; mode=block',
  };
  print(dio.options.headers);
  dio.httpClientAdapter = Http2Adapter(
    ConnectionManager(
      idleTimeout: const Duration(milliseconds: 10000),
      onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
    ),
  );

  dio.interceptors.add(DioErrorHandler());

  return dio;
}

final Dio dio = createDio();
