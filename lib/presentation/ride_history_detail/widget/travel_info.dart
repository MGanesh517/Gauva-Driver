import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/presentation/ride_history_detail/widget/info_chip_wrapper.dart';

import '../../../core/theme/color_palette.dart';
import '../../../data/models/order_response/order_model/order/order.dart';
import '../../../gen/assets.gen.dart';
import '../../home_page/widgets/activity_card.dart';

Widget travelInfo(BuildContext context, Order? order, {bool showCancelItem = false}) => Row(
  children: [
    infoChipWrapper(
      child: infoChip(
        context,
        netImage: order?.service?.logo,
        title: showCancelItem ? '--' : order?.service?.name,
        expand: false,
        showVerticalDivider: false,
      ),
    ),
    Gap(8.w),
    infoChipWrapper(
      child: infoChip(
        context,
        image: Assets.images.distanceLogo,
        title: showCancelItem ? '--' : '${((order?.distance ?? 0) / 1000).toStringAsFixed(2)} km',
        expand: false,
        imgColor: ColorPalette.primary50,
        showVerticalDivider: false,
      ),
    ),
    Gap(8.w),
    infoChipWrapper(
      child: infoChip(
        context,
        image: Assets.images.watch,
        title: showCancelItem ? '--' : '${((order?.duration ?? 0) / 60).toStringAsFixed(2)} min',
        imgColor: Colors.green,
        expand: false,
        showVerticalDivider: false,
      ),
    ),
  ],
);
