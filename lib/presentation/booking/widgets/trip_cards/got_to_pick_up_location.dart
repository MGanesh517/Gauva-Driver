import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/enums/booking_status.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';
import 'package:gauva_driver/data/models/order_response/order_model/order/order.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/booking/provider/driver_providers.dart';
import 'package:gauva_driver/presentation/booking/view_model/loading_notifier.dart';
import 'package:gauva_driver/presentation/booking/widgets/trip_cards/action_sheet.dart';
import 'package:gauva_driver/presentation/home_page/widgets/rider_details.dart';

import '../../provider/ride_providers.dart';

Widget gotoPickupLocation(BuildContext context, Order? order) => Consumer(
  builder: (context, ref, _) {
    final rideOrderNotifier = ref.read(rideOrderNotifierProvider.notifier);
    final rideOrderState = ref.watch(rideOrderNotifierProvider);
    final onTripNotifier = ref.read(ontripStatusNotifier.notifier);
    final isLoading = ref.watch(loadingProvider);

    return actionSheet(
      context,
      riderInfo: riderDetails(context, rideOrderState.whenOrNull(success: (order) => order?.rider)),
      title: localize(context).rider_waiting_move_now,
      description: localize(context).time_to_pickup,
      image: Assets.images.goToPickUpLocation.image(height: 134.h, width: 232.w, fit: BoxFit.fill),
      actions: [
        Expanded(
          child: AppPrimaryButton(
            isLoading: isLoading,
            onPressed: () {
              rideOrderNotifier.saveOrderStatus(
                status: 'go_to_pickup',
                onSuccess: (v) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onTripNotifier.updateOnTripStatus(status: BookingStatus.arrivedAtPickupPoint);
                  });
                },
              );
            },
            child: Text(
              localize(context).go_to_pickup_location,
              style: context.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  },
);
