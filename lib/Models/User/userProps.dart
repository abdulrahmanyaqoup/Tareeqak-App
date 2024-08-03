import 'package:flutter/foundation.dart';

@immutable
class UserProps {
  final String university;
  final String school;
  final String major;
  final String contact;
  final String image;

  const UserProps({
    this.university = '',
    this.school = '',
    this.major = '',
    this.contact = '',
    this.image = '',
  });

  UserProps copyWith({
    String? university,
    String? school,
    String? major,
    String? contact,
    String? image,
  }) {
    return UserProps(
      university: university ?? this.university,
      school: school ?? this.school,
      major: major ?? this.major,
      contact: contact ?? this.contact,
      image: image ?? this.image,
    );
  }

  static UserProps fromMap(Map<String, dynamic> map) {
    return UserProps(
      university: map['university'] ?? '',
      school: map['school'] ?? '',
      major: map['major'] ?? '',
      contact: map['contact'] ?? '',
      image: map['image'] ?? '',
    );
  }
}
