import 'package:finalproject/api/dioClient.dart';

class OtpApi {
  Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
    final response = await dio.post(
      'api/otp/verify',
      data: {
        'email': email,
        'otp': otp,
      },
    );
    return response.data;
  }

  Future deleteUnverified(String email) async {
    await dio.delete(
      'api/otp/delete',
      data: {
        'email': email,
      },
    );
  }
}