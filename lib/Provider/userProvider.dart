import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:finalproject/api/userApi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Models/User/user.dart';

class UserState {
  final User user;
  final List<User> userList;
  List<User> filteredUsers;
  final bool isLoggedIn;

  UserState({
    this.user = const User(),
    this.userList = const [],
    this.filteredUsers = const [],
    this.isLoggedIn = false,
  });

  UserState copyWith({
    User? user,
    List<User>? userList,
    List<User>? filteredUsers,
    bool? isLoggedIn,
  }) {
    return UserState(
      user: user ?? this.user,
      userList: userList ?? this.userList,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class UserProvider extends AutoDisposeAsyncNotifier<UserState> {
  @override
  UserState build() {
    return UserState();
  }

  Future<void> checkLoginStatus() async {
    state = const AsyncLoading();
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');

    if (token == null) return;
    try {
      Map<String, dynamic> userData = await UserApi().getUser(token);
      final User user = User.fromMap(userData);
      state = await AsyncValue.guard(() async {
        return state.valueOrNull!.copyWith(
          user: user,
          isLoggedIn: true,
        );
      });
    } on DioException catch (error) {
      throw error.message!;
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
    return response;
  }

  Future<void> signInVerifiedUser(User user, String token) async {
    state = const AsyncLoading();
    const storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: token);
    state = await AsyncValue.guard(() async {
      return state.valueOrNull!.copyWith(
        user: user,
        isLoggedIn: true,
      );
    });
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();

    try {
      Map<String, dynamic> response =
          await UserApi().signInUser(email: email, password: password);
      String token = response['token'] as String;
      const storage = FlutterSecureStorage();
      await storage.write(key: 'token', value: token);
      state = await AsyncValue.guard(() async {
        return state.valueOrNull!.copyWith(
          user: User.fromMap(response),
          isLoggedIn: true,
        );
      });
    } on DioException catch (error) {
      throw error.message!;
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');

    state = await AsyncValue.guard(() async {
      return state.valueOrNull!.copyWith(
        user: const User(),
        isLoggedIn: false,
      );
    });
  }

  Future<void> getAllUsers() async {
    state = const AsyncLoading();

    try {
      List<User> users = await UserApi().getAllUsers();
      state = await AsyncValue.guard(() async {
        return state.valueOrNull!.copyWith(
          userList: users,
          filteredUsers: users,
        );
      });
    } on DioException catch (error) {
      throw error.message!;
    }
  }

  Future<void> updateUser(User updatedUser) async {
    state = const AsyncLoading();
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');

    try {
      Map<String, dynamic> response =
          await UserApi().updateUser(updates: updatedUser, token: token ?? '');
      final User user = User.fromMap(response);
      final currentState = state.valueOrNull!;
      final List<User> updatedUserList = currentState.userList
          .map((user1) => user1.email == user.email ? user : user1)
          .toList();
      state = await AsyncValue.guard(() async {
        return currentState.copyWith(
          user: user,
          userList: updatedUserList,
          filteredUsers: updatedUserList,
        );
      });
    } on DioException catch (error) {
      throw error.message!;
    }
  }

  Future<String> deleteUser() async {
    state = const AsyncLoading();
    const storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token') ?? '';

    try {
      String response = await UserApi().deleteUser(token: token);
      await storage.delete(key: 'token');
      final currentState = state.valueOrNull!;

      List<User> refreshUserList = currentState.userList
          .where((user) => user.email != currentState.user.email)
          .toList();
      state = await AsyncValue.guard(() async {
        return currentState.copyWith(
          userList: refreshUserList,
          filteredUsers: refreshUserList,
          user: const User(),
          isLoggedIn: false,
        );
      });

      return response;
    } on DioException catch (error) {
      throw error.message!;
    }
  }

  Future<void> filterUsers(List<User> allUsers, String? university,
      String? school, String? major) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      List<User> filterUsers = allUsers.where((user) {
        final matchUniversity =
            university == null || user.userProps.university == university;
        final matchSchool = school == null || user.userProps.school == school;
        final matchMajor = major == null || user.userProps.major == major;
        return matchUniversity && matchSchool && matchMajor;
      }).toList();
      return state.valueOrNull!.copyWith(filteredUsers: filterUsers);
    });
  }
}

final userProvider =
    AutoDisposeAsyncNotifierProvider<UserProvider, UserState>(UserProvider.new);
