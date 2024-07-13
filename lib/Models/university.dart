import 'dart:convert';

import 'package:finalproject/Models/schools.dart';

class University {
  final String name;
  final String description;
  final String logo;
  final List<Schools> schools;

  const University({
    this.name = '',
    this.description = '',
    this.logo = '',
    this.schools = const [],
  });

  static University initial() {
    return const University();
  }

  University copyWith({
    String? id,
    String? name,
    String? logo,
    List<Schools>? schools,
  }) =>
      University(
        name: name ?? this.name,
        logo: logo ?? this.logo,
        schools: schools ?? this.schools,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'logo': logo,
        'schools': schools.map((school) => school.toMap()).toList(),
      };

  static University fromMap(Map<String, dynamic> map) => University(
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        logo: map['logo'] ?? '',
        schools: List<Schools>.from(
            map['schools']?.map((x) => Schools.fromMap(x)) ?? const []),
      );

  String toJson() => json.encode(toMap());

  static University fromJson(String source) => fromMap(json.decode(source));
}
