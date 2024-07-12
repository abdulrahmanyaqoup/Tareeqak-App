import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Dio createDio() {
  var dio = Dio();
  dio.options.baseUrl = dotenv.env['uri'] ?? '';
  dio.httpClientAdapter = Http2Adapter(
    ConnectionManager(
      idleTimeout: const Duration(milliseconds: 10000),

      /// Assume your server supports HTTP/2:
      onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
    ),
  );
  return dio;
}

final Dio dio = createDio();
