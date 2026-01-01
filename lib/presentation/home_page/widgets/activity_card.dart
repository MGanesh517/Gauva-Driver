import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/build_network_image.dart';
import 'package:gauva_driver/core/utils/format_date.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';

import '../../../core/theme/color_palette.dart';
import '../../../core/utils/localize.dart';
import '../../../data/models/order_response/order_model/order/order.dart';
import '../../../gen/assets.gen.dart';

Widget activityCard(
  BuildContext context, {
  required Order order,
  Function()? onTap,
  bool showCancelItem = false,
  bool showPrice = false,
}) => Container(
  margin: EdgeInsets.only(bottom: 8.h),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.r),
    image: DecorationImage(image: Assets.images.activityBackground.provider(), fit: BoxFit.fill),
  ),
  child: rideActivityCard(context, order: order, onTap: onTap, showCancelItem: showCancelItem, showPrice: showPrice),
);

Widget rideActivityCard(
  BuildContext context, {
  required Order order,
  Function()? onTap,
  bool showCancelItem = false,
  bool showPrice = false,
}) => InkWell(
  onTap: onTap,
  child: Container(
    padding: EdgeInsets.all(8.r),
    decoration: BoxDecoration(
      color: isDarkMode() ? context.surface : null,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: const Color(0xFFEDEEF1), width: 1.w),
    ),
    child: Row(
      children: [
        // showCancelItem ? buildImageError(40, 40) : imageBuilder(order.rider?.profilePicture),
        // Gap(8.w),
        Expanded(
          child: rideDetails(context, order: order, showCancelItem: showCancelItem),
        ),
        Container(
          margin: EdgeInsets.only(right: 8.w),
          height: 56.h,
          width: 1.w,
          color: const Color(0xFFD7DAE0),
        ),

        ratingDate(context, showCancelItem: showCancelItem, order: order, showPrice: showPrice),
      ],
    ),
  ),
);

Widget ratingDate(BuildContext context, {bool showCancelItem = false, bool showPrice = false, required Order order}) =>
    SizedBox(
      width: 61.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          showCancelItem
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r), color: const Color(0xFFFFE4E4)),
                  child: Text(
                    localize(context).cancel_ride,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: context.bodyMedium?.copyWith(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFFF5630),
                    ),
                  ),
                )
              : showPrice
              ? Text(
                  '₹' + (order.payableAmount ?? 0).toString(),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorPalette.primary50,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Ionicons.star, color: Colors.amber, size: 16.h),
                    Gap(4.w),
                    Text(
                      (order.rider?.rating ?? 0).toString(),
                      style: context.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF24262D),
                      ),
                    ),
                  ],
                ),
          Gap(8.h),
          Text(
            formatDateEnglish(order.orderTime),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: context.bodyMedium?.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF687387),
            ),
          ),
        ],
      ),
    );

Widget rideDetails(BuildContext context, {required Order order, bool showCancelItem = false}) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      order.status?.capitalize() ?? 'N/A',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.bodyMedium?.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
      ),
    ),
    Gap(4.h),
    showCancelItem
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  infoChip(
                    context,
                    image: Assets.images.distanceLogo,
                    title: showCancelItem ? '' : '${(order.distance ?? 0).toStringAsFixed(2)} km',
                    imgColor: ColorPalette.primary50,
                  ),
                  Gap(8.w),
                  infoChip(
                    context,
                    image: Assets.images.watch,
                    title: showCancelItem ? '' : '${((order.duration ?? 0) / 60).toStringAsFixed(2)} min',
                    imgColor: Colors.green,
                    showVerticalDivider: false,
                  ),
                ],
              ),
              Gap(8.h),
              if (order.addresses?.pickupAddress != null) ...[
                Row(
                  children: [
                    Icon(Ionicons.location_outline, size: 14.sp, color: Colors.green),
                    Gap(4.w),
                    Expanded(
                      child: Text(
                        order.addresses!.pickupAddress!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodySmall?.copyWith(fontSize: 12.sp, color: const Color(0xFF687387)),
                      ),
                    ),
                  ],
                ),
                Gap(4.h),
              ],
              if (order.addresses?.dropAddress != null)
                Row(
                  children: [
                    Icon(Ionicons.location_outline, size: 14.sp, color: Colors.red),
                    Gap(4.w),
                    Expanded(
                      child: Text(
                        order.addresses!.dropAddress!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodySmall?.copyWith(fontSize: 12.sp, color: const Color(0xFF687387)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
  ],
);

Widget infoChip(
  BuildContext context, {
  String? title,
  AssetGenImage? image,
  String? netImage,
  bool expand = true,
  bool showVerticalDivider = true,
  Color? imgColor,
}) {
  Widget infoData() => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      image != null
          ? image.image(height: 16.h, width: 16.w, fit: BoxFit.contain, color: imgColor)
          : const SizedBox.shrink(),
      netImage != null
          ? buildNetworkImage(imageUrl: netImage, height: 16.h, width: 16.w, errorIconSize: 8.h, fit: BoxFit.fill)
          : const SizedBox.shrink(),
      Gap(4.w),
      Expanded(
        child: Text(
          title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: context.bodyMedium?.copyWith(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF687387),
          ),
        ),
      ),
      Gap(showVerticalDivider ? 8.w : 0),
      showVerticalDivider ? Container(height: 8.h, width: 1.w, color: const Color(0xFFD7DAE0)) : const SizedBox.shrink(),
    ],
  );
  return expand ? Expanded(child: infoData()) : infoData();
}

Widget imageBuilder(String? image, {double height = 40, double width = 40, double? radius}) => CircleAvatar(
  radius: radius,
  backgroundColor: ColorPalette.primary50,
  child: Padding(
    padding: const EdgeInsets.all(1),
    child: ClipOval(
      child: image != null
          ? CachedNetworkImage(
              imageUrl: image,
              height: height,
              width: width,
              fit: BoxFit.cover,
              placeholder: (_, __) => buildImagePlaceholder(height, width),
              errorWidget: (_, __, ___) => buildImageError(height, width),
            )
          : const CircleAvatar(backgroundColor: ColorPalette.primary50),
    ),
  ),
);

Widget buildImagePlaceholder(double height, double width) => Container(
  height: height,
  width: width,
  color: Colors.grey[300],
  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
);

Widget buildImageError(double height, double width) => Container(
  height: height,
  width: width,
  decoration: BoxDecoration(image: DecorationImage(image: Assets.images.cancelProfile.provider())),
);
