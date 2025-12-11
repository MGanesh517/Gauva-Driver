import 'package:flutter/material.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmer({
  required double height,
  required double width,
  Widget? child,
  BorderRadius borderRadius = BorderRadius.zero,
  Color baseColor = const Color(0xFFE0E0E0),
  Color highlightColor = const Color(0xFFF5F5F5),
  EdgeInsets margin = EdgeInsets.zero,
}) => Stack(
  children: [
    Positioned.fill(
      child: Shimmer.fromColors(
        baseColor: isDarkMode() ? Colors.black : baseColor,
        highlightColor: isDarkMode() ? Colors.black12 : highlightColor,
        child: Container(
          height: height,
          width: width,
          margin: margin,
          decoration: BoxDecoration(color: isDarkMode() ? Colors.black : baseColor, borderRadius: borderRadius),
        ),
      ),
    ),
    Positioned(
      child: Padding(padding: const EdgeInsets.all(8.0), child: child ?? const SizedBox.shrink()),
    ),
  ],
);

Widget buildListShimmer({int itemCount = 6, bool shrinkWrap = false, ScrollPhysics? physics}) => ListView.builder(
  itemCount: itemCount,
  shrinkWrap: shrinkWrap,
  physics: physics,
  itemBuilder: (context, index) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        buildShimmer(height: 60, width: 60, borderRadius: BorderRadius.circular(8)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildShimmer(height: 16, width: double.infinity, borderRadius: BorderRadius.circular(4)),
              const SizedBox(height: 8),
              buildShimmer(height: 14, width: 150, borderRadius: BorderRadius.circular(4)),
            ],
          ),
        ),
      ],
    ),
  ),
);
