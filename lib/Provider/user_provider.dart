import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Models/user.dart';

class UserProvider extends StateNotifier<User> {
  UserProvider()
      : super(User(
          id: '',
          name: '',
          email: '',
          token: '',
          password: '',
          userProps: UserProps(
            university: '',
            major: '',
            contact: '',
            image: '',
          ),
        ));

  List<User> _userList = [];
  List<User> get userList => _userList;

  void setUser(String user) {
    state = User.fromJson(user);
  }

  void setUserFromModel(User user) {
    state = user;
  }

  void setUserList(List<User> users) {
    _userList = users;
  }

  void updateUserProps(UserProps userProps) {
    state = state.copyWith(userProps: userProps);
  }
}

final userProvider =
    StateNotifierProvider<UserProvider, User>((ref) => UserProvider());
