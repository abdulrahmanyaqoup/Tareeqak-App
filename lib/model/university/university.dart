part of '../models.dart';

@immutable
class University {
  const University({
    required this.name,
    required this.description,
    required this.location,
    required this.city,
    required this.website,
    required this.facts,
    required this.schools,
  });

  factory University.fromMap(Map<String, dynamic> map) {
    final schoolsList = map['schools'] as List<dynamic>? ?? [];
    final schools = schoolsList
        .map((s) => School.fromMap(s as Map<String, dynamic>))
        .toList();
    return University(
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      location: map['location'] as String? ?? '',
      city: map['city'] as String? ?? '',
      website: map['website'] as String? ?? '',
      facts: List<String>.from(map['facts'] as List<dynamic>? ?? const []),
      schools: schools,
    );
  }

  final String name;
  final String description;
  final String location;
  final String city;
  final String website;
  final List<String> facts;
  final List<School> schools;

  University copyWith({
    String? name,
    String? description,
    String? location,
    String? city,
    String? website,
    List<String>? facts,
    List<School>? schools,
  }) {
    return University(
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      city: city ?? this.city,
      website: website ?? this.website,
      facts: facts ?? this.facts,
      schools: schools ?? this.schools,
    );
  }
}
