import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/home_page/widgets/online_offline_switch.dart';

Widget topBarOnlineOffline(BuildContext context) => Row(
  children: [
    Image.asset(Assets.images.appLogo.path, height: 65.h, width: 65.w, fit: BoxFit.fill),
    const Spacer(),
    onlineOfflineSwitch(context),
  ],
);
