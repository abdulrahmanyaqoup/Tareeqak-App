import 'dart:io';
import 'package:finalproject/api/userApi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Models/User/user.dart';

class UserState {
  final User user;
  final List<User> userList;
  final bool isLoggedIn;

  UserState({
    this.user = const User(),
    this.userList = const [],
    this.isLoggedIn = false,
  });

  UserState copyWith({
    User? user,
    List<User>? userList,
    bool? isLoggedIn,
  }) {
    return UserState(
      user: user ?? this.user,
      userList: userList ?? this.userList,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class UserNotifier extends AutoDisposeAsyncNotifier<UserState> {
  UserNotifier() : super();

  @override
  Future<UserState> build() async {
    return UserState();
  }

  Future<void> checkLoginStatus() async {
    state = const AsyncValue.loading();
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    if (token != null && token.isNotEmpty) {
      state = await AsyncValue.guard(() async {
        Map<String, dynamic> userData = await UserApi().getUser(token);
        return state.value!.copyWith(
          user: User.fromMap(userData),
          isLoggedIn: true,
        );
      });
    } else {
      state = await AsyncValue.guard(() async {
        return state.value!.copyWith(
          user: const User(),
          isLoggedIn: false,
        );
      });
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
    state = const AsyncValue.loading();
    const storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: token);
    state = await AsyncValue.guard(() async {
      return state.value!.copyWith(user: user, isLoggedIn: true);
    });
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    Map<String, dynamic> response =
        await UserApi().signInUser(email: email, password: password);
    String token = response['token'] as String;
    const storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: token);
    state = await AsyncValue.guard(() async {
      return state.value!.copyWith(
        user: User.fromMap(response),
        isLoggedIn: true,
      );
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
    state = await AsyncValue.guard(() async {
      return state.value!.copyWith(
        user: const User(),
        isLoggedIn: false,
      );
    });
  }

  Future<void> getAllUsers() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      List<User> users = await UserApi().getAllUsers();
      return state.value!.copyWith(userList: users);
    });
  }

  Future<void> updateUser(User updatedUser) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'token');
      Map<String, dynamic> response =
          await UserApi().updateUser(updates: updatedUser, token: token ?? '');
      final User user = User.fromMap(response);
      return state.value!.copyWith(
        user: user,
        userList: state.value!.userList
            .map((user1) => user1.email == user.email ? user : user1)
            .toList(),
      );
    });
  }

  Future<String> deleteUser() async {
    state = const AsyncValue.loading();
    String response = '';
    state = await AsyncValue.guard(() async {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'token');
      response = await UserApi().deleteUser(token: token ?? '');
      await storage.delete(key: 'token');
      List<User> refreshUserList = state.value!.userList
          .where((user) => user.email != state.value!.user.email)
          .toList();
      return state.value!.copyWith(
        userList: refreshUserList,
        user: const User(),
        isLoggedIn: false,
      );
    });
    return response;
  }
}

final userProvider = AsyncNotifierProvider.autoDispose<UserNotifier, UserState>(
    UserNotifier.new);
