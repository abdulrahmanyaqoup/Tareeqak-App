import 'package:flutter/foundation.dart';

import 'major.dart';

@immutable
class School {
  const School({
    required this.name,
    required this.description,
    required this.facts,
    required this.majors,
  });

  factory School.fromMap(Map<String, dynamic> map) {
    final majorsList = map['majors'] as List<dynamic>? ?? [];
    final majors = majorsList
        .map((m) => Major.fromMap(m as Map<String, dynamic>))
        .toList();
    return School(
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      facts: List<String>.from(map['facts'] as List<dynamic>? ?? const []),
      majors: majors,
    );
  }

  final String name;
  final String description;
  final List<String> facts;
  final List<Major> majors;

  School copyWith({
    String? name,
    String? description,
    List<String>? facts,
    List<Major>? majors,
  }) {
    return School(
      name: name ?? this.name,
      description: description ?? this.description,
      facts: facts ?? this.facts,
      majors: majors ?? this.majors,
    );
  }
}
