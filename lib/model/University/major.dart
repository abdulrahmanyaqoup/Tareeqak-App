import 'package:flutter/foundation.dart';

@immutable
class Major {
  const Major({
    required this.name,
    required this.description,
    required this.facts,
    required this.jobs,
    required this.roadmap,
  });

  factory Major.fromMap(Map<String, dynamic> map) {
    return Major(
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      facts: List<String>.from(map['facts'] as List<dynamic>? ?? const []),
      jobs: List<String>.from(map['jobs'] as List<dynamic>? ?? const []),
      roadmap: map['roadmap'] as String? ?? '',
    );
  }

  final String name;
  final String description;
  final List<String> facts;
  final List<String> jobs;
  final String roadmap;

  Major copyWith({
    String? name,
    String? description,
    List<String>? facts,
    List<String>? jobs,
    String? roadmap,
  }) {
    return Major(
      name: name ?? this.name,
      description: description ?? this.description,
      facts: facts ?? this.facts,
      jobs: jobs ?? this.jobs,
      roadmap: roadmap ?? this.roadmap,
    );
  }
}
