import 'dart:convert';
import 'dart:io';
import 'package:finalproject/Screens/user/signin.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/Models/user.dart';
import 'package:finalproject/Screens/user/profile.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:finalproject/Provider/user_provider.dart';
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

  void signInUser({
    required BuildContext context,
    required WidgetRef ref,
    required String email,
    required String password,
  }) async {
    try {
      final navigator = Navigator.of(context);
      final userNotifier = ref.read(userProvider.notifier);

      http.Response res = await http.post(
        Uri.parse('${dotenv.env['uri']}/api/users/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          userNotifier.setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void getUserData({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      final userNotifier = ref.read(userProvider.notifier);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        prefs.setString('x-auth-token', '');
        return;
      }

      var tokenRes = await http.post(
        Uri.parse('${dotenv.env['uri']}/api/users/token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${dotenv.env['uri']}/api/users/current'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        userNotifier.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

 void getAllUsers({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  try {
    http.Response res = await http.get(
      Uri.parse('${dotenv.env['uri']}/api/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (res.statusCode == 200) {
      List<dynamic> usersJson = jsonDecode(res.body);
      List<User> users = usersJson.map((userJson) => User.fromMap(userJson)).toList();
      ref.read(userProvider.notifier).setUserList(users);
    } else {
      showSnackBar(context, 'Failed to fetch users');
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
}


  void updateUser({
    required BuildContext context,
    required WidgetRef ref,
    required String userId,
    required String userToken,
    required Map<String, dynamic> updates,
    required String token,
    File? image,
  }) async {
    try {
      final uri = Uri.parse('${dotenv.env['uri']}/api/users/update/$userId');
      var request = http.MultipartRequest('PATCH', uri);
      request.headers.addAll({
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userToken,
      });
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
            contentType: MediaType('image', 'jpeg/jpg/png/webp'),
          ).catchError((e) {
            return e;
          }),
        );
      }
      request.fields.addAll({
        'name': updates['name'],
        'email': updates['email'],
        'password': updates['password'],
        'university': updates['userProps']['university'],
        'major': updates['userProps']['major'],
        'contact': updates['userProps']['contact'],
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, response.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void deleteUser({
    required BuildContext context,
    required String userId,
    required String token,
  }) async {
    try {
      http.Response res = await http.delete(
        Uri.parse('${dotenv.env['uri']}/api/users/delete/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'User deleted successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signOut(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    final userNotifier = ref.read(userProvider.notifier);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('x-auth-token');
    userNotifier.setUserFromModel(User(
      id: '',
      name: '',
      email: '',
      password: '',
      token: '',
      userProps: UserProps(
        university: '',
        major: '',
        contact: '',
        image: '',
      ),
    ));
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const Signin(),
      ),
      (route) => false,
    );
  }
}
