import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/presentation/home_page/widgets/current_location_view.dart';
import 'package:gauva_driver/presentation/home_page/widgets/top_bar_online_offline.dart';

Widget top(BuildContext context) => Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.w),
  child: Column(
    children: [
      topBarOnlineOffline(context),
      Container(
        height: 1.h,
        width: double.infinity,
        color: ColorPalette.neutralF6,
        margin: EdgeInsets.symmetric(vertical: 8.h),
      ),
      currentLocationView(context),
    ],
  ),
);
