import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/enums/booking_status.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';
import 'package:gauva_driver/data/models/order_response/order_model/order/order.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/booking/provider/driver_providers.dart';
import 'package:gauva_driver/presentation/booking/widgets/trip_cards/action_sheet.dart';

import '../../../../core/utils/localize.dart';
import '../../provider/ride_providers.dart';
import '../../view_model/loading_notifier.dart';

Widget reachedDestination(BuildContext context, Order? order) => Consumer(
  builder: (context, ref, _) {
    final rideOrderNotifier = ref.read(rideOrderNotifierProvider.notifier);
    final rideOrderState = ref.read(rideOrderNotifierProvider);
    final onTripNotifier = ref.read(ontripStatusNotifier.notifier);

    return actionSheet(
      context,
      title: localize(context).reached_passenger_destination,
      description: localize(context).trip_ended_passenger_destination,
      image: Assets.images.reachedDestination.image(height: 130.h, width: 194.w, fit: BoxFit.fill),
      actions: [
        Expanded(
          child: AppPrimaryButton(
            isLoading: ref.watch(loadingProvider),
            onPressed: () async {
              print('✅ reachedDestination: Complete ride button pressed');
              
              // Get order ID - try multiple sources
              int? orderId = order?.id;
              
              if (orderId == null) {
                orderId = rideOrderState.maybeWhen(
                  success: (o) => o?.id,
                  orElse: () => null,
                );
              }
              
              // Fallback: try localStorage
              if (orderId == null) {
                orderId = await LocalStorageService().getOrderId();
              }

              print('✅ reachedDestination: Order ID: $orderId');

              if (orderId == null) {
                print('❌ reachedDestination: Order ID is null, cannot complete ride');
                return;
              }

              print('✅ reachedDestination: Calling completeRide API instead of dropped_off...');

              // Call the completeRide API instead of dropped_off status
              rideOrderNotifier.completeRide(
                orderId: orderId,
                onSuccess: (v) {
                  print('✅ reachedDestination: Ride completed successfully');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onTripNotifier.updateOnTripStatus(status: BookingStatus.payment);
                  });
                },
                onError: (failure) {
                  print('❌ reachedDestination: Failed to complete ride: ${failure.message}');
                },
              );
            },
            child: Text(
              localize(context).reached_destination,
              style: context.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  },
);
