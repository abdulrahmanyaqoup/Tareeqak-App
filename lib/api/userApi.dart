import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../Models/User/user.dart';
import 'dioClient.dart';
import 'dioExceptionHandler.dart';

class UserApi {
  Future<String> signUp({
    required User user,
    required String password,
    String? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'image': image,
        'name': user.name,
        'email': user.email,
        'password': password,
        'university': user.userProps.university,
        'school': user.userProps.school,
        'major': user.userProps.major,
        'contact': user.userProps.contact,
      });

      if (image != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              image,
              contentType: MediaType('image', 'jpg/jpeg/webp/png'),
            ),
          ),
        );
      }

      final response = await dio.post<dynamic>(
        'api/users/register',
        data: formData,
      );
      return response.data as String;
    } on DioException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<Map<String, dynamic>> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post<dynamic>(
        'api/users/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<Map<String, dynamic>> getUser(String token) async {
    try {
      final options = Options(
        headers: {
          'x-auth-token': token,
        },
      );
      final response =
          await dio.get<dynamic>('api/users/current', options: options);

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final response = await dio.get<dynamic>(
        'api/users',
      );
      final userList = response.data as List<dynamic>;
      return userList
          .map((user) => User.fromMap(user as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<Map<String, dynamic>> updateUser({
    required User user,
    required String token,
  }) async {
    try {
      final formData = FormData.fromMap({
        'image': user.userProps.image,
        'name': user.name,
        'university': user.userProps.university,
        'school': user.userProps.school,
        'major': user.userProps.major,
        'contact': user.userProps.contact,
      });

      if (user.userProps.image.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              user.userProps.image,
              contentType: MediaType('image', 'jpg/jpeg/webp/png'),
            ),
          ),
        );
      }
      final options = Options(
        headers: {
          'x-auth-token': token,
        },
      );
      final response = await dio.patch<dynamic>(
        'api/users/update',
        data: formData,
        options: options,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<String> deleteUser({
    required String token,
  }) async {
    try {
      final options = Options(
        headers: {
          'x-auth-token': token,
        },
      );
      final response = await dio.delete<dynamic>(
        'api/users/delete',
        options: options,
        data: {},
      );
      return response.data as String;
    } on DioException catch (e) {
      throw CustomException(e.message!);
    }
  }
}
