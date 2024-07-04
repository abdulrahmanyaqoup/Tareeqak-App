import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String token;
  final String password;
  final UserProps userProps;

  User({
    this.id= '',
    required this.name,
    required this.email,
    this.token= '',
    required this.password,
    required this.userProps,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'password': password,
      'userProps': userProps.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
      password: map['password'] ?? '',
      userProps: UserProps.fromMap(map['userProps'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}

class UserProps {
  final String? university;
  final String? major;
  final String? contact;
  final String? image;

  UserProps({
    this.university,
    this.major,
    this.contact,
    this.image,
  });

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
      university: map['university'],
      major: map['major'],
      contact: map['contact'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProps.fromJson(String source) => UserProps.fromMap(json.decode(source));
}
