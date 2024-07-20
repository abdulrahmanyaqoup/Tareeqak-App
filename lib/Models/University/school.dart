import 'package:flutter/foundation.dart';

import 'major.dart';

@immutable
class School {
  final String name;
  final String description;
  final List<String> facts;
  final List<Major> majors;

  const School(
      {required this.name,
      required this.description,
      required this.facts,
      required this.majors});

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

  static School fromMap(Map<String, dynamic> map) {
    var majorsList = map['majors'] as List<dynamic>? ?? [];
    List<Major> majors = majorsList
        .map((m) => Major.fromMap(m as Map<String, dynamic>))
        .toList();
    return School(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      facts: List<String>.from(map['facts'] ?? []),
      majors: majors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'facts': facts,
      'majors': majors.map((m) => m.toJson()).toList(),
    };
  }
}
