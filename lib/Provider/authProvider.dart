import 'dart:convert';

import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Services/authService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final bool isLoggedIn;
  AuthState({this.isLoggedIn = false});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  AuthNotifier(this.ref) : super(AuthState(isLoggedIn: false)) {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    if (token != null && token.isNotEmpty) {
      String response = await AuthService().getUserData();
      final userNotifier = ref.read(userProvider.notifier);
      userNotifier.setUser(response);
      state = AuthState(isLoggedIn: true);
    } else {
      state = AuthState(isLoggedIn: false);
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
      state = AuthState(isLoggedIn: true);
    } catch (e) {
      onError(e.toString());
      state = AuthState(isLoggedIn: false);
    }
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('x-auth-token');
    state = AuthState(isLoggedIn: false);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref));
