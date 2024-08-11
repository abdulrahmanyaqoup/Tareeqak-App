import 'package:flutter/material.dart';

import '../../../Models/University/university.dart';
import 'universityCard.dart';

class UniversitiesGrid extends StatelessWidget {
  const UniversitiesGrid({required this.universities, super.key});

  final List<University> universities;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(15),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          mainAxisExtent: 200,
        ),
        itemBuilder: (context, index) {
          final university = universities[index];
          return UniversityCard(
            university: university,
          );
        },
        itemCount: universities.length,
      ),
    );
  }
}
