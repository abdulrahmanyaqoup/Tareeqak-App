import 'dart:io';

import 'package:finalproject/api/userApi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Models/User/user.dart';

class UserState {
  final User user;
  final List<User> userList;
  final bool isLoggedIn;
  final bool isLoading;

  UserState({
    this.user = const User(),
    this.userList = const [],
    this.isLoggedIn = false,
    this.isLoading = true,
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
  UserNotifier() : super(UserState(user: const User()));

  Future<void> checkLoginStatus() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    if (token != null && token.isNotEmpty) {
      Map<String, dynamic> userData = await UserApi().getUser(token);
      state = state.copyWith(
          user: User.fromMap(userData), isLoggedIn: true, isLoading: false);
    }
  }

  Future<String> signUp(
    String name,
    String email,
    String password,
    String university,
    String school,
    String major,
    String contact,
    File? image,
  ) async {
    String response = await UserApi().signUp(
      name: name,
      email: email,
      password: password,
      university: university,
      school: school,
      major: major,
      contact: contact,
      image: image,
    );
    state = state.copyWith(isLoading: false);
    return response;
  }

  void signInVerfiedUser(User user, String tok) async {
    String token = tok;
    const storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: token);
    state = state.copyWith(user: user, isLoading: false, isLoggedIn: true);
  }

  Future<void> signIn(
    String email,
    String password,
  ) async {
    Map<String, dynamic> response =
        await UserApi().signInUser(email: email, password: password);
    String token = response['token'] as String;
    const storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: token);
    state = state.copyWith(user: User.fromMap(response), isLoggedIn: true);
  }

  Future<void> signOut() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
    state =
        state.copyWith(user: const User(), isLoggedIn: false, isLoading: false);
  }

  Future<void> getAllUsers() async {
    List<User> users = await UserApi().getAllUsers();
    state = state.copyWith(userList: users, isLoading: false);
  }

  Future<void> updateUser(updatedUser) async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    Map<String, dynamic> response =
        await UserApi().updateUser(updates: updatedUser, token: token ?? '');
    state = state.copyWith(
        user: User.fromMap(response), isLoggedIn: true, isLoading: false);
  }

  Future<String> deleteUser() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    String response = await UserApi().deleteUser(token: token ?? '');
    await storage.delete(key: 'token');
    List<User> refreshUserList =
        state.userList.where((user) => user.email != state.user.email).toList();
    state = state.copyWith(
        userList: refreshUserList, user: const User(), isLoggedIn: false);
    return response;
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, UserState>((ref) => UserNotifier());
