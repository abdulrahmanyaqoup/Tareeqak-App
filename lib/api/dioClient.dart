import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';

import '../env/env.dart';
import 'dioExceptionHandler.dart';

Dio createDio() {
  final dio = Dio()
    ..options = BaseOptions(
      baseUrl: Env.URI,
      headers: {
        'apikey': Env.API_KEY,
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.acceptHeader: 'application/json',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 15),
      persistentConnection: true,
    )
    ..httpClientAdapter = Http2Adapter(
      ConnectionManager(
        idleTimeout: const Duration(seconds: 30),
      ),
    );

  dio.interceptors.add(DioExceptionHandler());

  return dio;
}

final Dio dio = createDio();
