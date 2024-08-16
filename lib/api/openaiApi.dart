import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'dioClient.dart';
import 'dioExceptionHandler.dart';

@immutable
class OpenaiApi {
  OpenaiApi() : dio = DioClient.instance.dio;
  final Dio dio;

  Future<String> sendMessage(String message) async {
    try {
      final response = await dio.post<dynamic>(
        'api/openai/response',
        data: {
          'message': message,
        },
      );
      return response.data as String;
    } on DioException catch (e) {
      throw CustomException(e.error);
    }
  }
}
