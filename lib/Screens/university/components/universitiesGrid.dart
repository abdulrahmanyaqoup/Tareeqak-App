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
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          mainAxisExtent: 200,
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
      ),
    );
  }
}
