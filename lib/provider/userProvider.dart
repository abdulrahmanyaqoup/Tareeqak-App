import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api/userApi.dart';
import '../model/models.dart';

class UserState {
  UserState({
    this.user = const User(),
    this.userList = const [],
    this.filteredUsers = const [],
    this.isLoggedIn = false,
    this.isSearching = false,
  });

  final User user;
  final List<User> userList;
  final bool isLoggedIn;
  List<User> filteredUsers;
  bool isSearching;

  UserState copyWith({
    User? user,
    List<User>? userList,
    List<User>? filteredUsers,
    bool? isLoggedIn,
    bool? isSearching,
  }) {
    return UserState(
      user: user ?? this.user,
      userList: userList ?? this.userList,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isSearching: isSearching ?? this.isSearching,
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
    final token = await storage.read(key: 'token');

    if (token == null) {
      state = await AsyncValue.guard(() async => state.requireValue);
      return;
    }

    final userData = await UserApi().getUser(token);
    final user = User.fromMap(userData);
    state = await AsyncValue.guard(() async {
      return state.requireValue.copyWith(
        user: user,
        isLoggedIn: true,
      );
    });
  }

  Future<String> signUp(
    User user,
    String password,
  ) async {
    final response = await UserApi().signUp(
      user: user,
      password: password,
    );
    state = await AsyncValue.guard(() async => state.requireValue);
    return response;
  }

  Future<void> signInVerifiedUser(Map<String, dynamic> response) async {
    final token = response['token'] as String;
    const storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: token);
    final user = User.fromMap(response['user'] as Map<String, dynamic>);
    final currentState = state.requireValue;
    final refreshUserList = <User>[...currentState.userList, user];
    state = await AsyncValue.guard(() async {
      return state.requireValue.copyWith(
        user: user,
        userList: refreshUserList,
        filteredUsers: <User>[],
        isLoggedIn: true,
      );
    });
  }

  Future<void> signIn(String email, String password) async {
    final response =
        await UserApi().signInUser(email: email, password: password);
    final token = response['token'] as String;
    const storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: token);
    final user = User.fromMap(response['user'] as Map<String, dynamic>);
    state = await AsyncValue.guard(() async {
      return state.requireValue.copyWith(
        user: user,
        isLoggedIn: true,
      );
    });
  }

  Future<void> signOut() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');

    state = await AsyncValue.guard(() async {
      return state.requireValue.copyWith(
        user: const User(),
        isLoggedIn: false,
      );
    });
  }

  Future<void> getAllUsers() async {
    state = const AsyncLoading();
    final users = await UserApi().getAllUsers();
    state = await AsyncValue.guard(() async {
      return state.requireValue.copyWith(
        userList: users,
      );
    });
  }

  Future<void> updateUser(User updatedUser) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final response =
        await UserApi().updateUser(user: updatedUser, token: token ?? '');
    final user = User.fromMap(response);

    final currentState = state.requireValue;
    final updatedUserList = currentState.userList
        .map((user1) => user1.email == user.email ? user : user1)
        .toList();
    state = await AsyncValue.guard(() async {
      return currentState.copyWith(
        user: user,
        userList: updatedUserList,
        filteredUsers: <User>[],
      );
    });
  }

  Future<String> deleteUser() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token') ?? '';

    final response = await UserApi().deleteUser(token: token);
    await storage.delete(key: 'token');
    final currentState = state.requireValue;
    final refreshUserList = currentState.userList
        .where((user) => user.email != currentState.user.email)
        .toList();
    state = await AsyncValue.guard(() async {
      return currentState.copyWith(
        userList: refreshUserList,
        filteredUsers: <User>[],
        user: const User(),
        isLoggedIn: false,
      );
    });
    return response;
  }

  Future<void> filterUsers(
    List<User> allUsers,
    String? university,
    String? school,
    String? major,
  ) async {
    state = await AsyncValue.guard(() async {
      final filterUsers = allUsers.where((user) {
        final matchUniversity =
            university == null || user.userProps.university == university;
        final matchSchool = school == null || user.userProps.school == school;
        final matchMajor = major == null || user.userProps.major == major;
        return matchUniversity && matchSchool && matchMajor;
      }).toList();
      return state.requireValue
          .copyWith(filteredUsers: filterUsers, isSearching: true);
    });
  }
}

final userProvider = AsyncNotifierProvider.autoDispose<UserProvider, UserState>(
  UserProvider.new,
);