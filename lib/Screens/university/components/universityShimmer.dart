import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UniversityShimmer extends StatelessWidget {
  const UniversityShimmer({super.key});

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
          return Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 2),
                      color: Theme.of(context).primaryColor.withOpacity(.2),
                      spreadRadius: 0,
                      blurRadius: 3,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 20,
                      width: 100,
                      color: Colors.grey[100]!,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 20,
                      width: 60,
                      color: Colors.grey[100]!,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
