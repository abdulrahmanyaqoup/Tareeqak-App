import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ButtonShimmer extends StatelessWidget {
  final double height;
  const ButtonShimmer({super.key, this.height = 50.0});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: 150,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100]!,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
