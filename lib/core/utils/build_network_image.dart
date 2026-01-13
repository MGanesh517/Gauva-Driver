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
  String? cacheKey,
  Duration? cacheDuration,
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
    // Optimized caching settings
    cacheKey: cacheKey ?? imageUrl, // Use custom cache key if provided
    maxWidthDiskCache: width != null ? (width * 2).toInt() : 1000, // Cache at 2x for retina
    maxHeightDiskCache: height != null ? (height * 2).toInt() : 1000,
    // Use memory cache for faster access
    memCacheWidth: width != null ? width.toInt() : null,
    memCacheHeight: height != null ? height.toInt() : null,
    // Placeholder
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
    // Error widget
    errorWidget: (context, url, error) => errorWidget ??
        Icon(
          Icons.error_outline,
          size: errorIconSize,
          color: Colors.redAccent,
        ),
    // Fade in animation for better UX
    fadeInDuration: const Duration(milliseconds: 200),
    fadeOutDuration: const Duration(milliseconds: 100),
  );
}
