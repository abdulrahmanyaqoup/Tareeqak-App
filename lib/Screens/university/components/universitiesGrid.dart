import 'package:finalproject/Screens/university/components/universityCard.dart';
import 'package:flutter/material.dart';

import '../../../Provider/universityProvider.dart';

class UniversitiesGrid extends StatefulWidget {
  final UniversityState universityState;

  const UniversitiesGrid({super.key, required this.universityState});

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
          final university = widget.universityState.universities[index];
          return UniversityCard(
            university: university,
          );
        },
        childCount: widget.universityState.universities.length,
      ),
    );
  }
}
