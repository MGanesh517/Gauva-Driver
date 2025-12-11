import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

Widget buildNetworkImage({
  required String? imageUrl,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  Widget? placeholder,
  Widget? errorWidget,
  double? errorIconSize = 50,
}) {
  if (imageUrl == null || imageUrl.trim().isEmpty) {
    return errorWidget ??
        Icon(
          Icons.broken_image,
          size: errorIconSize,
          color: Colors.grey,
        );
  }

  return CachedNetworkImage(
    imageUrl: imageUrl,
    width: width,
    height: height,
    fit: fit,
    placeholder: (context, url) => placeholder ??
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
          ),
        ),
    errorWidget: (context, url, error) => errorWidget ??
        Icon(
          Icons.error_outline,
          size: errorIconSize,
          color: Colors.redAccent,
        ),
  );
}
