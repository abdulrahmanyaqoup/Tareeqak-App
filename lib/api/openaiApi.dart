import 'dioClient.dart';

class OpenaiApi {
  Future<String> sendMessage(String message) async {
    final response = await dio.post<dynamic>(
      'api/openai/response',
      data: {
        'message': message,
      },
    );
    return response.data as String;
  }
}
