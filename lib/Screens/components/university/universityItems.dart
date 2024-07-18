import 'package:finalproject/Screens/components/university/universityItem.dart';
import 'package:flutter/material.dart';

class UniversityGrid extends StatelessWidget {
  const UniversityGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => UniversityGridItem(
          title: 'University ${index + 1}',
          imagePath: 'assets/images/university_${index + 1}.png',
        ),
        childCount: 8,
      ),
    );
  }
}
