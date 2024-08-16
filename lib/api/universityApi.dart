import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../model/models.dart';
import 'dioClient.dart';
import 'dioExceptionHandler.dart';

@immutable
class UniversityApi {
  UniversityApi() : dio = DioClient.instance.dio;
  final Dio dio;

  Future<List<University>> getUniversities() async {
    try {
      final response = await dio.get<dynamic>('api/universities');

      final universityList = response.data as List<dynamic>;
      return universityList
          .map(
            (university) =>
                University.fromMap(university as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw CustomException(e.error);
    }
  }
}
