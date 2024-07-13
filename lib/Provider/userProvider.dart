import 'package:finalproject/api/userApi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Models/user.dart';

class UserState {
  final User user;
  final List<User> userList;
  final bool isLoading;
  final String? errorMessage;

  UserState({
    required this.user,
    this.userList = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  UserState copyWith({
    User? user,
    List<User>? userList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserState(
      user: user ?? this.user,
      userList: userList ?? this.userList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
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
    try {
      var userData = await AuthService().getUser(token);
      state = state.copyWith(user: User.fromJson(userData), isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> getAllUsers() async {
    try {
      List<User> users = await AuthService().getAllUsers();
      state = state.copyWith(userList: users, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void updateUser(
      String name, String email, String password, UserProps userProps) async {
    User updatedUser =
        state.user.copyWith(name: name, email: email, userProps: userProps);
    state = state.copyWith(user: updatedUser);
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, UserState>((ref) => UserNotifier());
