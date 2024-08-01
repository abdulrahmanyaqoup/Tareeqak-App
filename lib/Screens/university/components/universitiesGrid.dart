import 'package:finalproject/Screens/university/components/universityCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Provider/universityProvider.dart';

class UniversitiesGrid extends ConsumerStatefulWidget {
  const UniversitiesGrid({super.key});

  @override
  _UniversitiesGridState createState() => _UniversitiesGridState();
}

class _UniversitiesGridState extends ConsumerState<UniversitiesGrid> {
  late Future<void> _universitiesFuture;

  @override
  void initState() {
    super.initState();
    _universitiesFuture =
        ref.read(universityProvider.notifier).getUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _universitiesFuture,
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
