import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:finalproject/api/dioClient.dart';
import 'package:finalproject/env/env.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/Models/user.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
              contentType: MediaType('image', 'jpeg/webp/png')),
        ));
      }

      Response response = await dio.post(
        'api/users/register?apiKey=${Env.API_KEY}',
        data: formData,
      );

      return response.data['success'];
    } on DioException catch (e) {
      throw (e.response?.data['error']);
    }
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    try {
      Response response = await dio.post(
        'api/users/login?apiKey=${Env.API_KEY}',
        data: {
          'email': email,
          'password': password,
        },
      );
      return jsonEncode(response.data);
    } on DioException catch (e) {
      throw (e.response!.data['error']);
    }
  }

  Future<String> getUser(String token) async {
    try {
      Options options = Options(headers: {
        'x-auth-token': token,
      });

      Response response = await dio
          .get('api/users/current?apiKey=${Env.API_KEY}', options: options);
      return jsonEncode(response.data);
    } on DioException catch (e) {
      throw Exception(e.response!.data['error']);
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      Response response = await dio.get(
        'api/users?apiKey=${Env.API_KEY}',
      );

      List<dynamic> userList = response.data;
      return userList.map((userJson) => User.fromMap(userJson)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['error']);
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
            contentType: MediaType('image', 'jpeg/webp/png'),
          ),
        ));
      }
      Options options = Options(
        headers: {
          'x-auth-token': token,
        },
      );

      Response response = await dio.patch(
        'api/users/update/?apiKey=${Env.API_KEY}',
        data: formData,
        options: options,
      );

      return jsonEncode(response.data);
    } on DioException catch (e) {
      throw (e.response?.data['error']);
    }
  }

  Future<void> deleteUser({
    required BuildContext context,
    required WidgetRef ref,
    required String id,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      http.Response response = await http.delete(
        Uri.parse('api/users/delete/$id?${Env.API_KEY}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': prefs.getString('x-auth-token') ?? '',
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          prefs.setString('x-auth-token', '');
          Navigator.of(context).pushReplacementNamed('/signin');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
