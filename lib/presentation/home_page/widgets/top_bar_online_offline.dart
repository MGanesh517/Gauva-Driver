import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/home_page/widgets/online_offline_switch.dart';

Widget topBarOnlineOffline(BuildContext context) => Row(
  children: [
    Assets.images.rideInHome.image(height: 38.h, width: 62.w, fit: BoxFit.fill),
    const Spacer(),
    onlineOfflineSwitch(context),
  ],
);
