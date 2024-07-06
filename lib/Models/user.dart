import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String token;
  final String password;
  final UserProps userProps;

  User({
    this.id = '',
    required this.name,
    required this.email,
    this.token = '',
    required this.password,
    required this.userProps,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    String? password,
    UserProps? userProps,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      password: password ?? this.password,
      userProps: userProps ?? this.userProps,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'token': token,
      'password': password,
      'userProps': userProps.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
      password: map['password'] ?? '',
      userProps: UserProps.fromMap(map['userProps']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}

class UserProps {
  final String university;
  final String major;
  final String contact;
  final String image;

  UserProps({
    required this.university,
    required this.major,
    required this.contact,
    required this.image,
  });

  UserProps copyWith({
    String? university,
    String? major,
    String? contact,
    String? image,
  }) {
    return UserProps(
      university: university ?? this.university,
      major: major ?? this.major,
      contact: contact ?? this.contact,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'university': university,
      'major': major,
      'contact': contact,
      'image': image,
    };
  }

  factory UserProps.fromMap(Map<String, dynamic> map) {
    return UserProps(
      university: map['university'] ?? '',
      major: map['major'] ?? '',
      contact: map['contact'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProps.fromJson(String source) =>
      UserProps.fromMap(json.decode(source));
}
