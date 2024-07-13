import 'dart:convert';

class Majors {
  final String name;
  final String logo;
  final String description;
  const Majors({
    this.name = "",
    this.logo = "",
    this.description = "",
  });

  static Majors initial() {
    return const Majors();
  }

  Majors copyWith({
    String? name,
    String? logo,
    String? description,
  }) =>
      Majors(
        name: name ?? this.name,
        logo: logo ?? this.logo,
        description: description ?? this.description,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'logo': logo,
        'description': description,
      };

  static Majors fromMap(Map<String, dynamic> map) => Majors(
        name: map['name'] ?? '',
        logo: map['logo'] ?? '',
        description: map['description'] ?? '',
      );

  String toJson() => json.encode(toMap());

  static Majors fromJson(String source) => fromMap(json.decode(source));
}
