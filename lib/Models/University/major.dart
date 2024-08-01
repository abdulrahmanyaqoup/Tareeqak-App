import 'package:flutter/foundation.dart';

@immutable
class Major {
  final String name;
  final String description;
  final List<String> facts;
  final List<String> jobs;
  final String roadmap;

  const Major({
    required this.name,
    required this.description,
    required this.facts,
    required this.jobs,
    required this.roadmap,
  });

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

  static Major fromMap(Map<String, dynamic> map) {
    return Major(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      facts: List<String>.from(map['facts'] ?? []),
      jobs: List<String>.from(map['jobs'] ?? []),
      roadmap: map['roadmap'] ?? '',
    );
  }
}