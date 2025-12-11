import 'package:flutter/material.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';

import '../../theme/color_palette.dart';

class AppDialogHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color iconColor;

  const AppDialogHeader({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor = ColorPalette.primary30,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 24),
      Icon(icon, color: iconColor, size: 24),
      const SizedBox(height: 12),
      Text(title, style: context.headlineSmall),
      const SizedBox(height: 12),
      if (subtitle != null) ...[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(subtitle!, style: context.bodyMedium?.copyWith(color: context.theme.colorScheme.onSurfaceVariant)),
        ),
        const SizedBox(height: 12),
      ],
    ],
  );
}
