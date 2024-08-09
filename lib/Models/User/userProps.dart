import 'package:flutter/foundation.dart';

@immutable
class UserProps {
  const UserProps({
    this.university = '',
    this.school = '',
    this.major = '',
    this.contact = '',
    this.image = '',
  });

  factory UserProps.fromMap(Map<String, dynamic> map) {
    return UserProps(
      university: map['university'] as String? ?? '',
      school: map['school'] as String? ?? '',
      major: map['major'] as String? ?? '',
      contact: map['contact'] as String? ?? '',
      image: map['image'] as String? ?? '',
    );
  }

  final String university;
  final String school;
  final String major;
  final String contact;
  final String image;

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
}
