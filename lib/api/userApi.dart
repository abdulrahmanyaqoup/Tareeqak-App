import 'dart:io';
import 'package:dio/dio.dart';
import 'package:finalproject/Models/User/user.dart';
import 'package:finalproject/api/dioClient.dart';

// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class UserApi {
  Future<String> signUp({
    required User user,
    required String password,
    File? image,
  }) async {
    FormData formData = FormData.fromMap({
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
      formData.files.add(MapEntry(
        'image',
        await MultipartFile.fromFile(image.path,
            contentType: MediaType('image', 'jpg/jpeg/webp/png')),
      ));
    }

    Response response = await dio.post(
      'api/users/register',
      data: formData,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> signInUser(
      {required String email, required String password}) async {
    Response response = await dio.post(
      'api/users/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getUser(String token) async {
    Options options = Options(headers: {
      'x-auth-token': token,
    });

    Response response = await dio.get('api/users/current', options: options);
    return response.data;
  }

  Future<List<User>> getAllUsers() async {
    Response response = await dio.get(
      'api/users',
    );
    List<dynamic> userList = response.data;
    return userList.map((user) => User.fromMap(user)).toList();
  }

  Future<Map<String, dynamic>> updateUser({
    required User user,
    required String token,
  }) async {
    FormData formData = FormData.fromMap({
      'image': user.userProps.image,
      'name': user.name,
      'university': user.userProps.university,
      'school': user.userProps.school,
      'major': user.userProps.major,
      'contact': user.userProps.contact,
    });

    if (user.userProps.image.isNotEmpty) {
      formData.files.add(MapEntry(
        'image',
        await MultipartFile.fromFile(
          user.userProps.image,
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
      'api/users/update',
      data: formData,
      options: options,
    );
    return response.data;
  }

  Future<String> deleteUser({
    required String token,
  }) async {
    Options options = Options(
      headers: {
        'x-auth-token': token,
      },
    );
    Response response = await dio.delete(
      'api/users/delete',
      options: options,
      data: {},
    );
    return response.data;
  }
}
