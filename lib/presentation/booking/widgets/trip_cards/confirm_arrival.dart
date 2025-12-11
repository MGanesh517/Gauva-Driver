import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/enums/booking_status.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';
import 'package:gauva_driver/data/models/order_response/order_model/order/order.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/booking/provider/cancel_button_provider.dart';
import 'package:gauva_driver/presentation/booking/provider/driver_providers.dart';
import 'package:gauva_driver/presentation/booking/widgets/trip_cards/action_sheet.dart';
import 'package:gauva_driver/presentation/home_page/widgets/rider_details.dart';

import '../../../../core/utils/localize.dart';
import '../../provider/ride_providers.dart';
import '../../view_model/loading_notifier.dart';

Widget confirmArrival(BuildContext context, Order? order) => Consumer(
  builder: (context, ref, _) {
    final rideOrderNotifier = ref.read(rideOrderNotifierProvider.notifier);
    final rideOrderState = ref.read(rideOrderNotifierProvider);
    final onTripNotifier = ref.read(ontripStatusNotifier.notifier);
    final cancelTimerNotifier = ref.read(cancelButtonEnableTimerProvider.notifier);

    return actionSheet(
      context,
      riderInfo: riderDetails(context, order?.rider),
      title: localize(context).arrived_pickup_point,
      description: localize(context).reached_pickup_wait,
      image: Assets.images.confirmArrival.image(height: 130.h, width: 194.w, fit: BoxFit.fill),
      actions: [
        Expanded(
          child: AppPrimaryButton(
            isLoading: ref.watch(loadingProvider),
            onPressed: () {
              rideOrderNotifier.saveOrderStatus(
                status: 'confirm_arrival',
                onSuccess: (v) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onTripNotifier.updateOnTripStatus(status: BookingStatus.pickupConfirmed);
                    cancelTimerNotifier.startTimer();
                  });
                },
              );
            },
            child: Text(
              localize(context).tap_to_confirm_arrival,
              style: context.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  },
);
