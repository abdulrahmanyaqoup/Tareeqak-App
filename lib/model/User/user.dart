import 'package:flutter/foundation.dart';

import 'userProps.dart';

@immutable
class User {
  const User({
    this.name = '',
    this.email = '',
    this.userProps = const UserProps(),
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      userProps: UserProps.fromMap(
        map['userProps'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  final String name;
  final String email;
  final UserProps userProps;

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
}
