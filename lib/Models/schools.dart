import 'dart:convert';

import 'package:finalproject/Models/majors.dart';
import 'package:finalproject/Models/university,dart';

class Schools {
  final String name;
  final String logo;
  final List<Majors> majors;
  const Schools({
    this.name = "",
    this.logo = "",
    this.majors = const [],
  });

  static University initial() {
    return const University();
  }

  Schools copyWith({
    String? name,
    String? logo,
    List<Majors>? majors,
  }) =>
      Schools(
        name: name ?? this.name,
        logo: logo ?? this.logo,
        majors: majors ?? this.majors,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'logo': logo,
        'majors': majors.map((magor) => magor.toMap()).toList(),
      };

  static Schools fromMap(Map<String, dynamic> map) => Schools(
        name: map['name'] ?? '',
        logo: map['logo'] ?? '',
        majors: List<Majors>.from(
            map['majors']?.map((x) => Majors.fromMap(x)) ?? const []),
      );

  String toJson() => json.encode(toMap());

  static Schools fromJson(String source) => fromMap(json.decode(source));
}
