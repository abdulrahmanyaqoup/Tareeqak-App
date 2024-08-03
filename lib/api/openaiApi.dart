import 'package:finalproject/api/dioClient.dart';

class OpenaiApi {
  Future<String> sendMessage(String message) async {
    final response = await dio.post(
      'api/openai/response',
      data: {
        'message': message,
      },
    );
    return response.data;
  }
}
