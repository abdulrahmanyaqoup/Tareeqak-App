import 'dart:convert';

import 'package:finalproject/api/dioClient.dart';

class OtpApi {
  Future<String> verifyOTP(String email, String otp) async {
    final response = await dio.post(
      'api/otpverification',
      data: {
        'email': email,
        'otp': otp,
      },
    );
    return jsonEncode(response.data);
  }
}
