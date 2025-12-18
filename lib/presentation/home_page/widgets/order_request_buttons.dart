import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:gauva_driver/presentation/booking/provider/ride_providers.dart';
import 'package:gauva_driver/presentation/booking/view_model/loading_notifier.dart';
import 'package:gauva_driver/presentation/booking/view_model/reverse_timer_notifier.dart';

import '../../../core/enums/booking_status.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/order_response/order_model/order/order.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/pusher_service.dart';
import '../../booking/provider/driver_providers.dart';

Widget orderRequestButtons(BuildContext context, {num? orderId, Order? order}) => Consumer(
  builder: (context, ref, _) {
    final driverStatusNotifier = ref.watch(driverStatusNotifierProvider.notifier);
    final onTripStatusNotifier = ref.watch(ontripStatusNotifier.notifier);
    final orderStatusNotifier = ref.read(rideOrderNotifierProvider.notifier);
    final timerNotifier = ref.read(reverseTimerProvider.notifier);
    final bool isLoading = ref.watch(loadingProvider);

    return Row(
      children: [
        Expanded(
          child: AppPrimaryButton(
            isLoading:
                (orderStatusNotifier.currentStatus.isNotEmpty && orderStatusNotifier.currentStatus.contains('rejected'))
                ? isLoading
                : false,
            isDisabled: isLoading,
            backgroundColor: const Color(0xFFF6F7F9),
            onPressed: () {
              if (orderId == null) return;
              timerNotifier.stopTimer();
              orderStatusNotifier.declineRide(
                orderId: orderId.toInt(),
                onError: (failure) async {
                  await LocalStorageService().clearOrderId();
                  driverStatusNotifier.online();
                  NavigationService.pop();
                },
                onSuccess: (data) async {
                  await LocalStorageService().clearOrderId();
                  driverStatusNotifier.online();
                  NavigationService.pop();
                },
              );
            },
            child: Text(
              localize(context).cancel,
              style: context.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
              ),
            ),
          ),
        ),
        Gap(16.w),
        Expanded(
          child: AppPrimaryButton(
            isLoading:
                (orderStatusNotifier.currentStatus.isNotEmpty && orderStatusNotifier.currentStatus.contains('accepted'))
                ? isLoading
                : false,
            isDisabled: isLoading,
            onPressed: () async {
              if (orderId == null) return;

              // Get OTP from order if available, otherwise ask user
              int? otp;
              if (order?.otp != null) {
                // OTP is available in order response, use it directly
                otp = order!.otp is int ? order.otp as int : int.tryParse(order.otp.toString());
                print('✅ Using OTP from order: $otp');
              } else {
                // OTP not in order, ask user to enter it
                final otpString = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    String enteredOtp = '';
                    return AlertDialog(
                      title: const Text('Enter OTP'),
                      content: TextField(
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        decoration: const InputDecoration(hintText: 'OTP'),
                        onChanged: (val) => enteredOtp = val,
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: Text(localize(context).cancel)),
                        TextButton(
                          onPressed: () => Navigator.pop(context, enteredOtp),
                          child: Text(localize(context).confirm),
                        ),
                      ],
                    );
                  },
                );

                if (otpString == null || otpString.isEmpty) return;
                otp = int.tryParse(otpString);
                if (otp == null) return;
              }

              if (otp == null) {
                // OTP is required but not available
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('OTP is required to accept ride')),
                );
                return;
              }

              timerNotifier.stopTimer();
              // NavigationService.pop(); // Keep dialog open while loading? Or pop first? Layout suggests sticking to button state.
              // Logic was popping dialogue before calls?
              // Existing logic popped dialogue at start. Let's keep it if loading overlay handles it?
              // But here buttons have loading state. If we pop, we lose buttons.
              // Let's NOT pop immediately to show loading on button.
              // Wait, previous code popped: NavigationService.pop();

              orderStatusNotifier.acceptRide(
                orderId: orderId.toInt(),
                otp: otp,
                onError: (failure) {
                  // Handle error
                },
                onSuccess: (data) async {
                  if (data == null) return;
                  
                  // Save order ID and order data for booking page
                  await LocalStorageService().saveOrderId(data.id ?? orderId.toInt());
                  
                  // Ensure order data is set in state (accept response should have it, but use existing if needed)
                  if (data.points == null && order?.points != null) {
                    // If accept response doesn't have points, use the order details we already fetched
                    orderStatusNotifier.setOrderData(order!);
                  }
                  
                  driverStatusNotifier.onTrip();
                  onTripStatusNotifier.updateOnTripStatus(status: BookingStatus.goForPickup);
                  NavigationService.pop(); // Pop request dialog
                  NavigationService.pushNamed(AppRoutes.bookingPage);
                  final userId = await LocalStorageService().getUserId();
                  PusherService().subscribeChannel('chat_$userId');
                },
              );
            },
            child: Text(
              localize(context).accept_ride,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  },
);
