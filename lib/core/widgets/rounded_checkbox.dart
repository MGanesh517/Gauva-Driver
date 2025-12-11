import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';

class RoundedCheckbox extends StatelessWidget {
  final bool isSelected;

  const RoundedCheckbox({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isSelected ? context.colorScheme.primary : Colors.transparent,
      border: isSelected ? null : Border.all(color: context.colorScheme.outlineVariant),
    ),
    width: 20,
    height: 20,
    child: isSelected
        ? Icon(Ionicons.checkmark, size: 12, color: isSelected ? Colors.white : Colors.transparent)
        : const SizedBox(),
  );
}
