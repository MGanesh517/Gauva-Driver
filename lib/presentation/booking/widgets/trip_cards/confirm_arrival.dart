import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/enums/booking_status.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';
import 'package:gauva_driver/data/models/order_response/order_model/order/order.dart';
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:gauva_driver/presentation/booking/provider/cancel_button_provider.dart';
import 'package:gauva_driver/presentation/booking/provider/driver_providers.dart';
import 'package:gauva_driver/presentation/booking/widgets/trip_cards/action_sheet.dart';
import 'package:gauva_driver/presentation/home_page/widgets/rider_details.dart';

import '../../../../core/utils/localize.dart';
import '../../provider/ride_providers.dart';

Widget confirmArrival(BuildContext context, Order? order) => Consumer(
  builder: (context, ref, _) {
    final rideOrderNotifier = ref.read(rideOrderNotifierProvider.notifier);
    final rideOrderState = ref.watch(rideOrderNotifierProvider);
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
            onPressed: () async {
              print('🔘 ==========================================');
              print('🔘 confirmArrival: OK button pressed');

              // No API call when arriving - just show OK button
              // When OK is clicked, ALWAYS prompt for OTP, then confirm pickup

              // Get order ID - try multiple sources
              int? orderId = order?.id;

              if (orderId == null) {
                orderId = rideOrderState.maybeWhen(success: (o) => o?.id, orElse: () => null);
              }

              // Fallback: try localStorage
              if (orderId == null) {
                orderId = await LocalStorageService().getOrderId();
              }

              print('🔘 confirmArrival: Order ID: $orderId');
              print('🔘 confirmArrival: Order from param: ${order?.id}');
              print(
                '🔘 confirmArrival: Order from state: ${rideOrderState.maybeWhen(success: (o) => o?.id, orElse: () => null)}',
              );

              if (orderId == null) {
                print('❌ confirmArrival: Order ID is null, cannot proceed');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Order ID not found')));
                }
                return;
              }

              // Get OTP from order to show as hint (but still require user to enter it)
              final orderOtp = order?.otp != null
                  ? (order!.otp is int ? order.otp.toString() : order.otp.toString())
                  : null;

              print('🔘 confirmArrival: Order OTP: $orderOtp');
              print('🔘 confirmArrival: Showing OTP dialog...');

              // Always prompt user to enter OTP
              final otpString = await showDialog<String>(
                context: context,
                builder: (dialogContext) {
                  final controller = TextEditingController(text: orderOtp ?? '');
                  String enteredOtp = orderOtp ?? '';

                  return AlertDialog(
                    title: const Text('Enter OTP'),
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

              print('🔘 confirmArrival: OTP dialog returned: $otpString');

              // If user cancelled or didn't enter OTP, return
              if (otpString == null || otpString.isEmpty) {
                print('⚠️ confirmArrival: User cancelled or OTP is empty');
                return;
              }

              // Parse OTP
              final otp = int.tryParse(otpString);
              if (otp == null) {
                print('❌ confirmArrival: Invalid OTP: $otpString');
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Invalid OTP. Please enter a valid number.')));
                return;
              }

              print('✅ confirmArrival: Valid OTP entered: $otp');
              print('✅ confirmArrival: Calling startRide API: /api/v1/ride/$orderId/start');

              // Call the startRide API with OTP (this will confirm pickup and start the ride)
              rideOrderNotifier.startRide(
                orderId: orderId,
                otp: otp,
                onSuccess: (v) {
                  print('✅ confirmArrival: Start ride API successful - transitioning to headingToDestination');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onTripNotifier.updateOnTripStatus(status: BookingStatus.headingToDestination);
                    cancelTimerNotifier.cancelTimer();
                  });
                },
                onError: (failure) {
                  print('❌ confirmArrival: Failed to start ride: ${failure.message}');
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Failed to start ride: ${failure.message}')));
                  }
                },
              );
            },
            child: Text(
              'OK',
              style: context.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  },
);
