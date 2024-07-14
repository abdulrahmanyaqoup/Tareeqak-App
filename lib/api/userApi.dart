import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:finalproject/api/dioClient.dart';
import 'package:finalproject/env/env.dart';
import 'package:finalproject/Models/user.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class UserApi {
  Future<String> signUp({
    required String email,
    required String password,
    required String name,
    String university = '',
    String major = '',
    String contact = '',
    File? image,
  }) async {
    try {
      UserProps userProps = UserProps(
        university: university,
        major: major,
        contact: contact,
        image: '',
      );

      User user = User(
        name: name,
        email: email,
        userProps: userProps,
      );

      FormData formData = FormData.fromMap({
        'name': user.name,
        'email': user.email,
        'password': password,
        'university': userProps.university,
        'major': userProps.major,
        'contact': userProps.contact,
      });

      if (image != null) {
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(image.path,
              contentType: MediaType('image', 'jpg/jpeg/webp/png')),
        ));
      }

      Response response = await dio.post(
        'api/users/register${Env.API_KEY}',
        data: formData,
      );
      return jsonEncode(response.data);
    } on DioException catch (e) {
      throw (e.response?.data);
    }
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    try {
      Response response = await dio.post(
        'api/users/login${Env.API_KEY}',
        data: {
          'email': email,
          'password': password,
        },
      );
      return jsonEncode(response.data);
    } on DioException catch (e) {
      throw (e.response?.data);
    }
  }

  Future<String> getUser(String token) async {
    try {
      Options options = Options(headers: {
        'x-auth-token': token,
      });

      Response response =
          await dio.get('api/users/current${Env.API_KEY}', options: options);
      return jsonEncode(response.data);
    } on DioException catch (e) {
      throw (e.response?.data);
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      Response response = await dio.get(
        'api/users${Env.API_KEY}',
      );
      List<dynamic> userList = response.data;
      return userList.map((userJson) => User.fromMap(userJson)).toList();
    } on DioException catch (e) {
      throw (e.response?.data);
    }
  }

  Future<String> updateUser({
    required User updates,
    required String token,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'name': updates.name,
        'email': updates.email,
        'university': updates.userProps.university,
        'major': updates.userProps.major,
        'contact': updates.userProps.contact,
      });
      if (updates.userProps.image.isNotEmpty) {
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(
            updates.userProps.image,
            contentType: MediaType('image', 'jpg/jpeg/webp/png'),
          ),
        ));
      }
      Options options = Options(
        headers: {
          'x-auth-token': token,
        },
      );

      Response response = await dio.patch(
        'api/users/update${Env.API_KEY}',
        data: formData,
        options: options,
      );

      return jsonEncode(response.data);
    } on DioException catch (e) {
      throw (e.response?.data);
    }
  }

  Future<String> deleteUser({
    required String token,
  }) async {
    try {
      Options options = Options(
        headers: {
          'x-auth-token': token,
        },
      );
      Response response = await dio.delete(
        'api/users/delete${Env.API_KEY}',
        options: options,
      );

      return jsonEncode(response.data);
    } on DioException catch (e) {
      throw (e.response?.data);
    }
  }
}
