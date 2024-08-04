import 'package:finalproject/Models/University/university.dart';
import 'package:finalproject/Screens/university/components/universityCard.dart';
import 'package:flutter/material.dart';

class UniversitiesGrid extends StatefulWidget {
  final List<University> universities;

  const UniversitiesGrid({super.key, required this.universities});

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
