import 'dart:convert';

import 'package:finalproject/api/userApi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/user.dart';

class UserState {
  final User user;
  final List<User> userList;
  final bool isLoggedIn;
  final bool isLoading;

  UserState({
    required this.user,
    this.userList = const [],
    this.isLoggedIn = false,
    this.isLoading = false,
  });

  UserState copyWith({
    User? user,
    List<User>? userList,
    bool isLoggedIn = false,
    bool? isLoading,
  }) {
    return UserState(
      user: user ?? this.user,
      userList: userList ?? this.userList,
      isLoggedIn: isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState(user: User.initial()));

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    if (token != null && token.isNotEmpty) {
      var userData = await UserApi().getUser(token);
      state = state.copyWith(user: User.fromJson(userData), isLoading: false);
      state = state.copyWith(isLoggedIn: true, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signIn(
    String email,
    String password,
  ) async {
    String response =
        await UserApi().signInUser(email: email, password: password);
    String token = jsonDecode(response)['token'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('x-auth-token', token);
    state = state.copyWith(
        user: User.fromJson(response), isLoggedIn: true, isLoading: false);
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('x-auth-token');
    state = UserState(user: User.initial());
    state = state.copyWith(isLoggedIn: false, isLoading: false);
  }

  void setUser(User user) {
    state = state.copyWith(user: user);
  }

  Future<void> getAllUsers() async {
    List<User> users = await UserApi().getAllUsers();
    state = state.copyWith(userList: users, isLoading: false);
  }

  Future<void> updateUser(updatedUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    String user =
        await UserApi().updateUser(updates: updatedUser, token: token ?? '');
    state = state.copyWith(user: User.fromJson(user), isLoading: false);
  }

  Future<void> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    await UserApi().deleteUser(token: token ?? '');
    prefs.remove('x-auth-token');
    state = state.copyWith(user: User.initial(), isLoading: false);
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, UserState>((ref) => UserNotifier());
