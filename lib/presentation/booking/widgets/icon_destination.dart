import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';

class IconDestination extends StatelessWidget {
  final bool isPickupPoint;
  final Color? color;
  const IconDestination({
    super.key,
    this.isPickupPoint = false, this.color,

  });

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(4.r),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: logo.image(height: 25.h, width: 25.w, fit: BoxFit.fill, color: color),
    );

  AssetGenImage get logo => isPickupPoint ? Assets.images.pickUp : Assets.images.destination;
}
