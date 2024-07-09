import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
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
  );
  List<User> _userList = [];
  User get user => _user;
  List<User> get userList => _userList;
  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void setUserList(List<User> users) {
    _userList = users;
    notifyListeners();
  }

  void updateUserProps(UserProps userProps) {
    _user = User(
      id: _user.id,
      name: _user.name,
      email: _user.email,
      token: _user.token,
      password: _user.password,
      userProps: userProps,
    );
    notifyListeners();
  }
}

final userProvider = ChangeNotifierProvider((ref) => UserProvider());
