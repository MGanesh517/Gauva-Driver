import 'package:flutter/cupertino.dart';

import '../../theme/color_palette.dart';

class AppIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;

  const AppIconButton({
    super.key,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) => CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: onPressed, minimumSize: const Size(0, 0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorPalette.neutralVariant95,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: ColorPalette.primary30,
          size: 20,
        ),
      ),
    );
}
