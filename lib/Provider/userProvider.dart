import 'package:finalproject/api/userApi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/user.dart';

class UserState {
  final User user;
  final List<User> userList;
  final bool isLoading;

  UserState({
    required this.user,
    this.userList = const [],
    this.isLoading = false,
  });

  UserState copyWith({
    User? user,
    List<User>? userList,
    bool? isLoading,
  }) {
    return UserState(
      user: user ?? this.user,
      userList: userList ?? this.userList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState(user: User.initial()));

  Future<void> clearUser() async {
    state = UserState(user: User.initial());
  }

  Future<void> getUser(String token) async {
    state = state.copyWith(isLoading: true);
    var userData = await UserApi().getUser(token);
    state = state.copyWith(user: User.fromJson(userData), isLoading: false);
  }

  void setUser(User user) {
    state = state.copyWith(user: user);
  }

  Future<void> getAllUsers() async {
    state = state.copyWith(isLoading: true);
    List<User> users = await UserApi().getAllUsers();
    state = state.copyWith(userList: users, isLoading: false);
  }

  Future<void> updateUser(updatedUser) async {
    state = state.copyWith(isLoading: true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    String user =
        await UserApi().updateUser(updates: updatedUser, token: token ?? '');
    state = state.copyWith(user: User.fromJson(user), isLoading: false);
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, UserState>((ref) => UserNotifier());
