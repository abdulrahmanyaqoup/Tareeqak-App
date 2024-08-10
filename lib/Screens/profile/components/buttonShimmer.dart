import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ButtonShimmer extends StatelessWidget {
  const ButtonShimmer({super.key, this.height = 50.0, this.width = 120.0});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
