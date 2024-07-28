import 'package:finalproject/Screens/components/university/components/universityCard.dart';
import 'package:finalproject/Provider/universityProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UniversityGrid extends ConsumerWidget {
  const UniversityGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(universityProvider.notifier).getUniversities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final universityState = ref.watch(universityProvider);
          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final university = universityState.universities[index];
                return UniversityCard(
                  university: university,
                );
              },
              childCount: universityState.universities.length,
            ),
          );
        }
      },
    );
  }
}
