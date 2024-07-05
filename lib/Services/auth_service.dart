import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:finalproject/Models/user.dart';
import 'package:finalproject/Screens/user/profile.dart';
import 'package:finalproject/Screens/user/signup.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:finalproject/Utils/constants.dart';
import 'package:finalproject/Provider/user_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required WidgetRef ref,
    required String email,
    required String password,
    required String name,
    File? imageFile,
  }) async {
    try {
      UserProps userProps = UserProps(
        university: '',
        major: '',
        contact: '',
        image: '',
      );
      User user = User(
          name: name, password: password, email: email, userProps: userProps);

      http.Response res = await http.post(
        Uri.parse('${dotenv.env['uri']}/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
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
        Uri.parse('${dotenv.env['uri']}/api/signin'),
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

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('${dotenv.env['uri']}/api/user/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${dotenv.env['uri']}/api/user'),
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
  }) async {
    try {
      http.Response res = await http.get(
        Uri.parse('${dotenv.env['uri']}/api/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (res.statusCode == 200) {
        List<dynamic> users = jsonDecode(res.body);
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
    required Map<String, dynamic> updates,
    required String token,
    File? imageFile,
  }) async {
    try {
      if (updates.isEmpty && imageFile == null) {
        showSnackBar(context, 'No updates provided');
        return;
      }

      if (imageFile != null) {
        final mimeType = lookupMimeType(imageFile.path);
        if (!['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
            .contains(mimeType)) {
          showSnackBar(context,
              'Unsupported image format. Allowed formats are: jpg, jpeg, png, webp.');
          return;
        }

        updates['userProps']['image'] =
            base64Encode(await imageFile.readAsBytes());
      }

      http.Response res = await http.patch(
        Uri.parse('${dotenv.env['uri']}/api/user/$userId'),
        body: jsonEncode(updates),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'User updated successfully');
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
        Uri.parse('${dotenv.env['uri']}/api/user/$userId'),
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

  void signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', '');
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
      (route) => false,
    );
  }
}
