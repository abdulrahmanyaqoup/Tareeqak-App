import 'package:dio/dio.dart';

import 'dioClient.dart';
import 'dioExceptionHandler.dart';

class OtpApi {
  Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
    try {
      final response = await dio.post<dynamic>(
        'api/users/verifyUser',
        data: {
          'email': email,
          'otp': otp,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw CustomException(e.error);
    }
  }

  Future<void> deleteUnverified(String email) async {
    try {
      await dio.delete<dynamic>(
        'api/users/deleteUnverified',
        data: {
          'email': email,
        },
      );
    } on DioException catch (e) {
      throw CustomException(e.error);
    }
  }
}
