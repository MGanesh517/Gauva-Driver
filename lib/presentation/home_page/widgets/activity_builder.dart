import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/data/models/order_response/order_model/order/order.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:gauva_driver/presentation/home_page/widgets/activity_card.dart';

import '../../../core/routes/app_routes.dart';

Widget activityBuilder(BuildContext context, {List<Order> orderList = const <Order>[], bool showPrice = false}) =>
    ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: orderList.length,
      itemBuilder: (context, index) {
        final order = orderList[index];
        return activityCard(
          context,
          order: order,
          onTap: () {
            NavigationService.pushNamed(AppRoutes.rideHistoryDetail, arguments: order);
          },
          showCancelItem: order.status != null && order.status!.toLowerCase() == 'cancelled',
          showPrice: showPrice,
        );
      },
    );
