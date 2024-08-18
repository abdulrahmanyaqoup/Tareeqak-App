import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api/userApi/userApi.dart';
import '../model/models.dart';

@immutable
class UserState {
  const UserState({
    this.user = const User(),
    this.userList = const [],
    this.filteredUsers = const [],
    this.isLoggedIn = false,
    this.isSearching = false,
  });

  final User user;
  final List<User> userList;
  final bool isLoggedIn;
  final List<User> filteredUsers;
  final bool isSearching;

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

@immutable
class UserProvider extends AutoDisposeAsyncNotifier<UserState> {
  UserProvider({required this.storage, required this.userApi});
  final FlutterSecureStorage storage;
  final UserApi userApi;

  @override
  UserState build() {
    return const UserState();
  }

  Future<void> checkLoginStatus() async {
    state = const AsyncLoading();
    final token = await storage.read(key: 'token');

    if (token == null) {
      state = await AsyncValue.guard(() async => state.requireValue);
      return;
    }

    final userData = await userApi.getUser(token);
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
    final response = await userApi.register(
      user: user,
      password: password,
    );
    state = await AsyncValue.guard(() async => state.requireValue);
    return response;
  }

  Future<void> signInVerifiedUser(Map<String, dynamic> response) async {
    final token = response['token'] as String;
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
    final response = await userApi.login(email: email, password: password);
    final token = response['token'] as String;
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
    final users = await userApi.getUsers();
    state = await AsyncValue.guard(() async {
      return state.requireValue.copyWith(
        userList: users,
      );
    });
  }

  Future<void> updateUser(User updatedUser) async {
    final token = await storage.read(key: 'token');

    final response =
        await userApi.update(user: updatedUser, token: token ?? '');
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
    final token = await storage.read(key: 'token') ?? '';

    final response = await userApi.delete(token: token);
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

  Future<void> clearFilters() async {
    state = await AsyncValue.guard(() async {
      return state.requireValue.copyWith(
        filteredUsers: <User>[],
        isSearching: false,
      );
    });
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
  () => UserProvider(
    storage: const FlutterSecureStorage(),
    userApi: UserApi(),
  ),
);
