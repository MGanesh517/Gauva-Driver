import 'package:flutter/material.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';

import 'app_marker.dart';

class AppMarkerPickup extends StatelessWidget {
  final String address;

  const AppMarkerPickup({super.key, required this.address});

  @override
  Widget build(BuildContext context) => AppMarker(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pick-up point', style: context.labelMedium),
        Text(
          address,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.bodyMedium?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
        ),
      ],
    ),
  );
}
