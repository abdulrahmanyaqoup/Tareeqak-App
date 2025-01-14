import 'package:flutter/material.dart';

import '../../../model/models.dart';
import 'universityCard.dart';

class UniversitiesGrid extends StatelessWidget {
  const UniversitiesGrid({required this.universities, super.key});

  final List<University> universities;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
        bottom: 20,
      ),
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
