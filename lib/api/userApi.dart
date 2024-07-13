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
        '/api/users/register?apiKey=${Env.API_KEY}',
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
        '/api/users/login?apiKey=${Env.API_KEY}',
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

      Response response = await dio.get(
          '${Env.URI}/api/users/current?apiKey=${Env.API_KEY}',
          options: options);
      return jsonEncode(response.data);
    } on DioException catch (e) {
      throw Exception(e.response!.data['error']);
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      Response response = await dio.get(
        '/api/users?apiKey=${Env.API_KEY}',
      );

      List<dynamic> userList = response.data;
      return userList.map((userJson) => User.fromMap(userJson)).toList();
    } on DioException catch (e) {
      throw Exception(e.response!.data['error']);
    }
  }

  Future<User> updateUser({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uri =
          Uri.parse('${Env.URI}/api/users/update/$userId??${Env.API_KEY}');
      var request = http.MultipartRequest('PATCH', uri);

      request.headers.addAll({
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': prefs.getString('x-auth-token') ?? '',
      });

      if (updates['userProps']['image'] != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            updates['userProps']['image'],
            contentType: MediaType('image', 'jpeg'),
          ).catchError((e) {
            return http.MultipartFile.fromBytes('image', []);
          }),
        );
      }

      request.fields.addAll({
        'name': updates['name'],
        'email': updates['email'],
        'password': '',
        'university': updates['userProps']['university'],
        'major': updates['userProps']['major'],
        'contact': updates['userProps']['contact'],
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return jsonDecode(response.body);
    } catch (e) {
      rethrow;
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
        Uri.parse('${Env.URI}/api/users/delete/$id?${Env.API_KEY}'),
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
