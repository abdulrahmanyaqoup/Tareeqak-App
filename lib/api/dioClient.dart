import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
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

  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => false;
    return client;
  };

  dio.interceptors.add(DioExceptionHandler());

  return dio;
}

final Dio dio = createDio();
