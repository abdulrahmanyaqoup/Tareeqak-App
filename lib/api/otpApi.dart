import 'dioClient.dart';

class OtpApi {
  Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
    final response = await dio.post<dynamic>(
      'api/otp/verify',
      data: {
        'email': email,
        'otp': otp,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteUnverified(String email) async {
    await dio.delete<dynamic>(
      'api/otp/delete',
      data: {
        'email': email,
      },
    );
  }
}
