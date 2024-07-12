import 'dart:convert';

import 'package:finalproject/Provider/user_provider.dart';
import 'package:finalproject/Services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<bool> {
  final Ref ref;
  AuthController(this.ref) : super(true) {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    if (token != null && token.isNotEmpty) {
      state = true;
    }
  }

  Future<void> signIn(
      String email, String password, Function(String) onError) async {
    try {
      String response =
          await AuthService().signInUser(email: email, password: password);
      String userData = response;
      String token = jsonDecode(response)['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('x-auth-token', token);
      ref.read(userProvider.notifier).setUser(userData);
      state = true;
    } catch (e) {
      onError(e.toString());
      state = false;
    }
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', '');
    state = false;
  }
}
