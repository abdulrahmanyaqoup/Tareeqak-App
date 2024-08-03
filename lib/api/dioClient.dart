import 'dart:io';

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
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json',
    },
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    sendTimeout: const Duration(seconds: 3),
    persistentConnection: true,
  );

  dio.httpClientAdapter = Http2Adapter(
    ConnectionManager(
      idleTimeout: const Duration(seconds: 10),
      // Ignore bad certificate for development
      onClientCreate: (_, config) => config.onBadCertificate = (_) => false,
    ),
  );

  dio.interceptors.add(DioExceptionHandler());

  return dio;
}

final Dio dio = createDio();
