import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/buttons/app_back_button.dart';
import 'package:gauva_driver/data/models/order_response/order_model/order/order.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:gauva_driver/presentation/home_page/widgets/readable_location_view.dart';
import 'package:gauva_driver/presentation/ride_history_detail/widget/rider_and_location.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/utils/helpers.dart';
import '../../booking/widgets/trip_cards/payment_received.dart';

class RideHistoryDetail extends ConsumerWidget {
  const RideHistoryDetail({super.key, this.order});
  final Order? order;

  void _copyText(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    showNotification(message: localize(context).textCopied, isSuccess: true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isComplete = order?.status != null && order!.status!.toLowerCase().contains('completed');

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(color: isDarkMode() ? context.surface : Colors.white),
        child: issueButton(
          context,
          onTap: () {
            NavigationService.pushNamed(AppRoutes.reportIssue, arguments: order?.id);
          },
          title: localize(context).reportIssue,
          icon: Ionicons.book_outline,
          backgroundColor: const Color(0xFFFFF1EE),
          textColor: const Color(0xFFFF5630),
        ),
      ),
      appBar: AppBar(
        backgroundColor: isDarkMode() ? context.surface : Colors.white,
        leading: const AppBackButton(),
        title: Text(
          localize(context).rideDetails,
          style: context.bodyMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              _copyText(context, '${order?.id}');
            },
            child: IntrinsicWidth(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      (order?.id ?? 0).toString(),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorPalette.primary50,
                      ),
                    ),
                  ),
                  Gap(8.w),
                  const Icon(Icons.copy, color: ColorPalette.primary50, size: 20),
                ],
              ),
            ),
          ),
          Gap(16.w),
        ],
      ),
      body: Container(
        color: isDarkMode() ? Colors.black : Colors.white,
        margin: EdgeInsets.only(top: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              riderAndLocation(context, ref, order, showCancelItem: !isComplete),
              Gap(16.h),
              readAbleLocationView(context, order?.addresses),
              Gap(16.h),
              isComplete
                  ? serviceOverView(
                      context,
                      order!,
                      widgets: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0.w, right: 8.w, top: 8.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              rowText(
                                context,
                                title: localize(context).payment_method,
                                value: order?.payMethod?.capitalize(),
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              Gap(120.h),
            ],
          ),
        ),
      ),
    );
  }
}

Widget issueButton(
  BuildContext context, {
  String title = '',
  IconData? icon,
  Color? backgroundColor,
  Color? textColor,
  Function()? onTap,
}) => InkWell(
  onTap: onTap,
  child: Container(
    padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 8.w),
    decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(4.r)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: textColor, size: 18.h),
        Gap(6.w),
        Flexible(
          child: Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: context.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: textColor),
          ),
        ),
      ],
    ),
  ),
);
