import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class MyShimmer extends StatelessWidget {
  const MyShimmer({super.key,
    required this.width,
     this.height,
    required this.radius,
    this.color,
  });
  final double width;
  final double? height;
  final double radius;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return  Shimmer.fromColors(
      period: const Duration(milliseconds: 800),
      baseColor: Colors.blue.shade100,
      highlightColor: Colors.blue.shade200,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(radius),topRight: Radius.circular(radius)),
            color: color
        ),
      ),
    );
  }
}