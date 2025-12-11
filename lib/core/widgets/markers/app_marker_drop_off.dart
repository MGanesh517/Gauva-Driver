import 'package:flutter/material.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';

import 'app_marker.dart';

class AppMarkerDropOff extends StatelessWidget {
  final String address;

  const AppMarkerDropOff({super.key, required this.address});

  @override
  Widget build(BuildContext context) => AppMarker(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Destination', style: context.labelMedium),
        Text(
          address,
          overflow: TextOverflow.ellipsis,
          style: context.bodyMedium?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
        ),
      ],
    ),
  );
}
