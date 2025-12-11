import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';

import '../../theme/color_palette.dart';

class AppCloseButton extends StatelessWidget {
  final Function() onPressed;

  const AppCloseButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => CupertinoButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(0), minimumSize: const Size(0, 0),
      child: const Icon(
        Ionicons.close,
        size: 24,
        color: ColorPalette.neutral50,
      ),
    );
}
