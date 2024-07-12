import 'dart:convert';

import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/backend/authentication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final bool isLoggedIn;
  final bool isLoading;
  AuthState({this.isLoggedIn = false, this.isLoading = true});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  AuthNotifier(this.ref) : super(AuthState(isLoggedIn: false));

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    final userNotifier = ref.read(userProvider.notifier);
    if (token != null && token.isNotEmpty) {
      await userNotifier.getUser(token);
      state = AuthState(isLoggedIn: true, isLoading: false);
    } else {
      await userNotifier.clearUser();
      state = AuthState(isLoggedIn: false, isLoading: false);
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
      ref.read(userProvider.notifier).getUser(userData);
      state = AuthState(isLoggedIn: true, isLoading: false);
    } catch (e) {
      onError(e.toString());
      state = AuthState(isLoggedIn: false, isLoading: false);
    }
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', '');
    state = AuthState(isLoggedIn: false, isLoading: false);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref));
