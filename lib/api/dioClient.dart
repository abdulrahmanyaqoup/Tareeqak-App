import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';

import '../env/env.dart';
import 'dioExceptionHandler.dart';

@immutable
class DioClient {
  const DioClient(this.dio);

  DioClient._singleTone()
      : dio = Dio(
          BaseOptions(
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
          ),
        ) {
    dio.httpClientAdapter = Http2Adapter(
      ConnectionManager(
        idleTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(const DioExceptionHandler());
  }

  static final DioClient _instance = DioClient._singleTone();
  static DioClient get instance => _instance;
  final Dio dio;
}
