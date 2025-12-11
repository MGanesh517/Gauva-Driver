import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/services/navigation_service.dart';
import '../../../gen/assets.gen.dart';
import '../../theme/color_palette.dart';
import '../../utils/is_dark_mode.dart';

class AppBackButton extends StatelessWidget {
  final Function()? onPressed;
  final Color? color;
  const AppBackButton({
    super.key,
    this.onPressed,
    this.color
  });

  @override
  Widget build(BuildContext context) => CupertinoButton(
        onPressed: onPressed ?? (){
          NavigationService.pop();
        },
        padding: const EdgeInsets.all(0), minimumSize: const Size(0, 0),
        child: Assets.images.arrowLeft.image(height: 24.h, width: 24.w, color: isDarkMode() ? Colors.white : color ?? ColorPalette.neutral50)
    );
}
