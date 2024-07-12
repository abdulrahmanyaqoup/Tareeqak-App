import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:finalproject/Models/user.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required WidgetRef ref,
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
        id: '',
        name: name,
        email: email,
        password: password,
        token: '',
        userProps: userProps,
      );

      final uri = Uri.parse('${dotenv.env['uri']}/api/users/register');

      var request = http.MultipartRequest('POST', uri);

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
            contentType: MediaType('image', 'jpeg/jpg/png/webp'),
          ),
        );
      }

      request.fields.addAll({
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'university': userProps.university,
        'major': userProps.major,
        'contact': userProps.contact,
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
      };

      http.Response response = await http.post(
        Uri.parse('${dotenv.env['uri']}/api/users/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'x-auth-token': prefs.getString('x-auth-token') ?? '',
      };

      http.Response userRes = await http.get(
          Uri.parse('${dotenv.env['uri']}/api/users/current'),
          headers: headers);

      return userRes.body;
    } catch (e) {
      return '';
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      http.Response response = await http.get(
        Uri.parse('${dotenv.env['uri']}/api/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      List<dynamic> userJsonList = jsonDecode(response.body);
      List<User> users =
          userJsonList.map((userJson) => User.fromMap(userJson)).toList();
      return users;
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateUser({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uri = Uri.parse('${dotenv.env['uri']}/api/users/update/$userId');
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
        Uri.parse('${dotenv.env['uri']}/api/users/delete/$id'),
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
