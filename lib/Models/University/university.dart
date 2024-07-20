import 'package:flutter/foundation.dart';

import 'school.dart';

@immutable
class University {
  final String name;
  final String description;
  final List<String> facts;
  final List<School> schools;

  const University(
      {required this.name,
      required this.description,
      required this.facts,
      required this.schools});

  University copyWith({
    String? name,
    String? description,
    List<String>? facts,
    List<School>? schools,
  }) {
    return University(
      name: name ?? this.name,
      description: description ?? this.description,
      facts: facts ?? this.facts,
      schools: schools ?? this.schools,
    );
  }

  static University fromMap(Map<String, dynamic> map) {
    var schoolsList = map['schools'] as List<dynamic>? ?? [];
    List<School> schools = schoolsList
        .map((s) => School.fromMap(s as Map<String, dynamic>))
        .toList();
    return University(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      facts: List<String>.from(map['facts'] ?? []),
      schools: schools,
    );
  }
}
