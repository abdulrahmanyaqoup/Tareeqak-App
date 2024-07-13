import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:finalproject/env/env.dart';

Dio createDio() {
  var dio = Dio();
  dio.options.baseUrl = Env.URI;
  dio.options.headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Content-Security-Policy': "default-src 'self'",
    'X-Content-Type-Options': 'nosniff',
    'X-Frame-Options': 'DENY',
    'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
    'X-XSS-Protection': '1; mode=block',
  };
  dio.httpClientAdapter = Http2Adapter(
    ConnectionManager(
      idleTimeout: const Duration(milliseconds: 10000),
      onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
    ),
  );
  return dio;
}

final Dio dio = createDio();
