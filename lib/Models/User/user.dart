import 'package:finalproject/Models/User/userProps.dart';
import 'package:flutter/foundation.dart';

@immutable
class User {
  final String name;
  final String email;
  final UserProps userProps;

  const User({
    this.name = '',
    this.email = '',
    this.userProps = const UserProps(),
  });

  User copyWith({
    String? name,
    String? email,
    UserProps? userProps,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      userProps: userProps ?? this.userProps,
    );
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      userProps: UserProps.fromMap(map['userProps'] as Map<String, dynamic>),
    );
  }
}
