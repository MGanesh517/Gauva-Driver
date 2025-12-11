import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/enums/booking_status.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/routes/app_routes.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/core/utils/is_arabic.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';
import 'package:gauva_driver/data/models/order_response/order_model/order/order.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/booking/provider/driver_providers.dart';
import 'package:gauva_driver/presentation/booking/provider/home_providers.dart';
import 'package:gauva_driver/presentation/booking/provider/pusher_provider.dart';
import 'package:gauva_driver/presentation/booking/widgets/trip_cards/action_sheet.dart';

import '../../../../core/utils/is_dark_mode.dart';
import '../../provider/ride_providers.dart';
import '../../view_model/loading_notifier.dart';

Widget paymentReceived(BuildContext context, Order? order) => Consumer(
  builder: (context, ref, _) {
    final rideOrderNotifier = ref.read(rideOrderNotifierProvider.notifier);
    // final rideOrderState = ref.watch(rideOrderNotifierProvider);
    final tripStateNotifier = ref.read(ontripStatusNotifier.notifier);
    final bookingNotifier = ref.read(bookingNotifierProvider.notifier);
    final pusherNotifier = ref.read(pusherNotifierProvider.notifier);
    return actionSheet(
      context,
      title: localize(context).ride_complete,
      description: localize(context).trip_ended_wait_payment,
      image: Assets.images.paymentReceived.image(height: 125.h, width: 201.w, fit: BoxFit.fill),
      content: serviceOverView(
        context,
        order!,
        widgets: [
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: rowText(context, title: localize(context).payment_method, value: order.payMethod?.capitalize()),
          ),
        ],
      ),
      actions: [
        Expanded(
          child: AppPrimaryButton(
            isLoading: ref.watch(loadingProvider),
            onPressed: () {
              rideOrderNotifier.saveOrderStatus(
                status: 'completed',
                onSuccess: (v) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    tripStateNotifier.updateOnTripStatus(status: BookingStatus.initial);

                    pusherNotifier.disconnect();
                    bookingNotifier.resetToInitial();
                    await LocalStorageService().clearOrderId();
                    pusherNotifier.setupPusherListeners();
                    NavigationService.pushNamedAndRemoveUntil(AppRoutes.dashboard);
                  });
                },
              );
            },
            child: Text(
              localize(context).payment_received,
              style: context.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  },
);

Widget serviceOverView(BuildContext context, Order order, {List<Widget>? widgets}) => Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.r),
    border: Border.all(color: const Color(0xFFF1F7FE)),
  ),
  child: Column(
    children: [
      if (widgets != null) ...widgets,
      Padding(
        padding: EdgeInsets.all(8.0.r),
        child: rowText(
          context,
          title: localize(context).rideCharge,
          value:
              '₹'
              '${order.subTotal ?? 0.00}',
        ),
      ),
      // Padding(
      //   padding: EdgeInsets.all(8.0.r),
      //   child: rowText(context,
      //       title: localize(context).service_charge,
      //       value: '₹' '${order.service?.baseFare ?? 0.00}'),
      // ),
      Padding(
        padding: EdgeInsets.only(left: 8.0.w, right: 8.w, bottom: 8.h),
        child: rowText(context, title: localize(context).discount, value: '₹' + (order.discount ?? 0).toString()),
      ),
      Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.r), bottomLeft: Radius.circular(8.r)),
          color: isDarkMode() ? Colors.grey.shade900 : const Color(0xFFF6F4FE),
        ),
        child: rowText(
          context,
          title: localize(context).total_amount,
          value:
              '₹'
              '${order.payableAmount ?? 0.00}',
          fontWeight: FontWeight.w600,
          color: ColorPalette.primary50,
        ),
      ),
    ],
  ),
);

Widget rowText(
  BuildContext context, {
  required String title,
  value,
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  bool showBackground = false,
  Color? backgroundColor,
  Color? rVColor,
}) => Row(
  children: [
    Expanded(
      child: Text(
        title,
        textAlign: isArabic() ? TextAlign.right : TextAlign.left,
        style: context.bodyMedium?.copyWith(
          fontSize: (fontSize ?? 14).sp,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: isDarkMode() ? Colors.grey.shade500 : color ?? const Color(0xFF2E2E2E),
        ),
      ),
    ),
    Expanded(
      child: Container(
        decoration: showBackground
            ? BoxDecoration(borderRadius: BorderRadius.circular(4.r), color: backgroundColor)
            : null,
        child: Text(
          value ?? '',
          textAlign: isArabic() ? TextAlign.left : TextAlign.right,
          style: context.bodyMedium?.copyWith(
            fontSize: (fontSize ?? 14).sp,
            fontWeight: fontWeight ?? FontWeight.w400,
            color: isDarkMode() ? Colors.grey.shade500 : rVColor ?? color ?? const Color(0xFF2E2E2E),
          ),
        ),
      ),
    ),
  ],
);
