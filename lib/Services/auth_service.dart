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

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          userNotifier.setUser(response.body);
          await prefs.setString(
              'x-auth-token', jsonDecode(response.body)['token']);
          print('respnse body    :' + response.body);
          prefs.setBool("isLoggedIn", true);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const Profile(),
            ),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> getUserData({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      final userNotifier = ref.read(userProvider.notifier);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        prefs.setString('x-auth-token', '');
      }

      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'x-auth-token': token!,
      };

      var tokenRes = await http.post(
        Uri.parse('${dotenv.env['uri']}/api/users/token'),
        headers: headers,
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
            Uri.parse('${dotenv.env['uri']}/api/users/current'),
            headers: headers);
        httpErrorHandle(
          response: userRes,
          context: context,
          onSuccess: () {
            userNotifier.setUser(userRes.body);
            print('userRes.body: ' + userRes.body); 
          },
        );
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
        List<User> users =
            usersJson.map((userJson) => User.fromMap(userJson)).toList();
        ref.read(userProvider.notifier).setUserList(users);
      } else {
        showSnackBar(context, 'Failed to fetch users');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> updateUser({
    required BuildContext context,
    required WidgetRef ref,
    required String userId,
    required String userToken,
    required Map<String, dynamic> updates,
    required String token,
  }) async {
    try {
      final userNotifier = ref.read(userProvider.notifier);
      final uri = Uri.parse('${dotenv.env['uri']}/api/users/update/$userId');
      var request = http.MultipartRequest('PATCH', uri);

      request.headers.addAll({
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userToken,
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

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final userProps = jsonDecode(response.body)['userProps'];
          userNotifier.updateUserProps(UserProps.fromMap(userProps));
          showSnackBar(context, 'user has been updated');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> deleteUser({
    required BuildContext context,
    required WidgetRef ref,
    required String id,

  }) async {
    try {
      final userNotidier = ref.read(userProvider.notifier);
      final prefs = await SharedPreferences.getInstance();
      http.Response response = await http.delete(
        Uri.parse(
            '${dotenv.env['uri']}/api/users/delete/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userNotidier.user.token,
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          prefs.remove('x-auth-token');
          Navigator.of(context).pushReplacementNamed('/signin');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signOut(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    final userNotifier = ref.read(userProvider.notifier);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('x-auth-token', '');
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
