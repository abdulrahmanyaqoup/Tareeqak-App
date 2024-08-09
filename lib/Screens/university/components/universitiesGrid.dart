import 'package:flutter/material.dart';

import '../../../Models/University/university.dart';
import 'universityCard.dart';

class UniversitiesGrid extends StatefulWidget {

  const UniversitiesGrid({required this.universities, super.key});
  final List<University> universities;

  @override
  State<UniversitiesGrid> createState() => _UniversitiesGridState();
}

class _UniversitiesGridState extends State<UniversitiesGrid> {
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final university = widget.universities[index];
          return UniversityCard(
            university: university,
          );
        },
        childCount: widget.universities.length,
      ),
    );
  }
}
