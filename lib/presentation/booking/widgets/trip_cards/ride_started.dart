import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/enums/booking_status.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/helpers.dart';
import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';
import 'package:gauva_driver/data/models/order_response/order_model/order/order.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/booking/provider/driver_providers.dart';
import 'package:gauva_driver/presentation/booking/widgets/trip_cards/action_sheet.dart';
import 'package:gauva_driver/presentation/home_page/widgets/rider_details.dart';
import 'package:gauva_driver/presentation/home_page/widgets/location_time_calculated.dart';

import '../../../../core/utils/localize.dart';
import '../../provider/ride_providers.dart';

Widget rideStarted(BuildContext context, Order? order) => Consumer(
  builder: (context, ref, _) {
    final rideOrderNotifier = ref.read(rideOrderNotifierProvider.notifier);
    final rideOrderState = ref.watch(rideOrderNotifierProvider);
    final onTripNotifier = ref.read(ontripStatusNotifier.notifier);
    return actionSheet(
      context,
      riderInfo: riderDetails(context, order?.rider),
      locationTime: locationTime(context),
      title: localize(context).all_set_start_ride,
      description: localize(context).start_journey_navigation,
      image: Assets.images.startRide.image(height: 130.h, width: 194.w, fit: BoxFit.fill),
      actions: [
        Expanded(
          child: AppPrimaryButton(
            onPressed: () async {
              print('🚀 rideStarted: Start ride button pressed');
              
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

              print('🚀 rideStarted: Order ID: $orderId');

              if (orderId == null) {
                print('❌ rideStarted: Order ID is null, cannot proceed');
                if (context.mounted) {
                  showNotification(message: 'Error: Order ID not found', isSuccess: false);
                }
                return;
              }

              // Get OTP from order to show as hint (but still require user to enter it)
              final orderOtp = order?.otp != null
                  ? (order!.otp is int ? order.otp.toString() : order.otp.toString())
                  : null;

              print('🚀 rideStarted: Order OTP: $orderOtp');
              print('🚀 rideStarted: Showing OTP dialog...');

              // Always prompt user to enter OTP
              final otpString = await showDialog<String>(
                context: context,
                builder: (dialogContext) {
                  final controller = TextEditingController(text: orderOtp ?? '');
                  String enteredOtp = orderOtp ?? '';

                  return AlertDialog(
                    title: const Text('Enter OTP to Start Ride'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (orderOtp != null) ...[
                          Text(
                            'OTP: $orderOtp',
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600], fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 8.h),
                        ],
                        TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          decoration: const InputDecoration(hintText: 'Enter OTP'),
                          onChanged: (val) {
                            enteredOtp = val;
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(localize(context).cancel)),
                      TextButton(
                        onPressed: () {
                          final value = controller.text.trim();
                          Navigator.pop(dialogContext, value.isEmpty ? enteredOtp : value);
                        },
                        child: Text(localize(context).confirm),
                      ),
                    ],
                  );
                },
              );

              print('🚀 rideStarted: OTP dialog returned: $otpString');

              // If user cancelled or didn't enter OTP, return
              if (otpString == null || otpString.isEmpty) {
                print('⚠️ rideStarted: User cancelled or OTP is empty');
                return;
              }

              // Parse OTP
              final otp = int.tryParse(otpString);
              if (otp == null) {
                print('❌ rideStarted: Invalid OTP: $otpString');
                if (context.mounted) {
                  showNotification(message: 'Invalid OTP. Please enter a valid number.', isSuccess: false);
                }
                return;
              }

              print('✅ rideStarted: Valid OTP entered: $otp');
              print('✅ rideStarted: Calling startRide API...');

              // Call the startRide API with OTP
              rideOrderNotifier.startRide(
                orderId: orderId,
                otp: otp,
                onSuccess: (v) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onTripNotifier.updateOnTripStatus(status: BookingStatus.headingToDestination);
                  });
                },
                onError: (failure) {
                  print('❌ rideStarted: Failed to start ride: ${failure.message}');
                  if (context.mounted) {
                    showNotification(message: failure.message, isSuccess: false);
                  }
                },
              );
            },
            child: Text(
              localize(context).tap_to_start_ride,
              style: context.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  },
);
