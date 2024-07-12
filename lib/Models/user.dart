import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String name;
  final String email;
  final UserProps userProps;

  const User({
    this.id = '',
    this.name = '',
    this.email = '',
    this.userProps = const UserProps(),
  });

  static User initial() {
    return const User();
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    UserProps? userProps,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        userProps: userProps ?? this.userProps,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'userProps': userProps.toMap(),
      };

  static User fromMap(Map<String, dynamic> map) => User(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        userProps: UserProps.fromMap(map['userProps'] as Map<String, dynamic>),
      );

  String toJson() => json.encode(toMap());

  static User fromJson(String source) => fromMap(json.decode(source));
}

@immutable
class UserProps {
  final String university;
  final String major;
  final String contact;
  final String image;

  const UserProps({
    this.university = '',
    this.major = '',
    this.contact = '',
    this.image = '',
  });

  static User initial() {
    return const User();
  }

  UserProps copyWith({
    String? university,
    String? major,
    String? contact,
    String? image,
  }) =>
      UserProps(
        university: university ?? this.university,
        major: major ?? this.major,
        contact: contact ?? this.contact,
        image: image ?? this.image,
      );

  Map<String, dynamic> toMap() => {
        'university': university,
        'major': major,
        'contact': contact,
        'image': image,
      };

  static UserProps fromMap(Map<String, dynamic> map) => UserProps(
        university: map['university'] ?? '',
        major: map['major'] ?? '',
        contact: map['contact'] ?? '',
        image: map['image'] ?? '',
      );

  String toJson() => json.encode(toMap());

  static UserProps fromJson(String source) => fromMap(json.decode(source));
}
