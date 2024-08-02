import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:finalproject/api/dioExceptionHandler.dart';
import 'package:finalproject/env/env.dart';

Dio createDio() {
  var dio = Dio();
  dio.options = BaseOptions(
    baseUrl: Env.URI,
    responseType: ResponseType.json,
    headers: {
      'x-api-key': Env.API_KEY,
      'content-Type': 'application/json; charset=UTF-8',
      'accept': 'application/json',
    },
  );

  dio.httpClientAdapter = Http2Adapter(
    ConnectionManager(
      idleTimeout: const Duration(minutes: 1),
      onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
    ),
  );

  dio.interceptors.add(DioExceptionHandler());

  return dio;
}

final Dio dio = createDio();
