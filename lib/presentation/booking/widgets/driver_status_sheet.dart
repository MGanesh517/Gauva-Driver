import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/widgets/app_card_sheet.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:gauva_driver/presentation/booking/provider/ride_providers.dart';
import 'package:gauva_driver/presentation/booking/views/sheets/chat_sheet.dart';
import 'package:gauva_driver/presentation/booking/widgets/estimated_time_widget.dart';
import 'package:gauva_driver/presentation/booking/widgets/trip_cards/confirm_arrival.dart';
import 'package:gauva_driver/presentation/booking/widgets/trip_cards/confirm_pick_up.dart';
import 'package:gauva_driver/presentation/booking/widgets/trip_cards/got_to_pick_up_location.dart';
import 'package:gauva_driver/presentation/booking/widgets/trip_cards/payment_received.dart';
import 'package:gauva_driver/presentation/booking/widgets/trip_cards/reached_destination.dart';
import 'package:gauva_driver/presentation/booking/widgets/trip_cards/ride_started.dart';
import '../../../data/models/order_response/order_model/order/order.dart';
import '../provider/driver_providers.dart';

class DriverStatusSheet extends ConsumerStatefulWidget {
  const DriverStatusSheet({super.key});

  @override
  ConsumerState<DriverStatusSheet> createState() => _DriverStatusSheetState();
}

class _DriverStatusSheetState extends ConsumerState<DriverStatusSheet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _isVisible = true;

  final double hiddenOffset = 0.85; // how much hidden when minimized

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      LocalStorageService().saveChatState(isOpen: false);
    });
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, hiddenOffset),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _toggleSheet() {
    if (_isVisible) {
      _controller.forward(); // hide
    } else {
      _controller.reverse(); // show
    }
    setState(() => _isVisible = !_isVisible);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_isVisible && details.delta.dy < -6) {
      _toggleSheet(); // drag up to show
    } else if (_isVisible && details.delta.dy > 6) {
      _toggleSheet(); // drag down to hide
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onTripStatusState = ref.watch(ontripStatusNotifier);
    final Order? order = ref.watch(rideOrderNotifierProvider).whenOrNull(success: (d) => d);
    final isIOS = Platform.isIOS;
    return SafeArea(
      bottom: isIOS ? false : true,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SlideTransition(
          position: _animation,
          child: GestureDetector(
            onTap: _toggleSheet,
            onVerticalDragUpdate: _onDragUpdate,
            child: Container(
              width: double.infinity,
              decoration: context.responsive(
                const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                xl: const BoxDecoration(),
              ),
              child: _isVisible
                  ? AppCardSheet(
                      padding: onTripStatusState.whenOrNull(chat: () => EdgeInsets.zero),

                      /// this is for chat sheet appbar padding and design
                      child: onTripStatusState.when(
                        initial: () => const Text('Initializing'),
                        goForPickup: () => gotoPickupLocation(context, order),
                        arrivedAtPickupPoint: () => confirmArrival(context, order),
                        pickupConfirmed: () => confirmPickup(context, order),
                        rideStarted: () => rideStarted(context, order),
                        headingToDestination: () => headingToDestination(context),
                        reachedDestination: () => reachedDestination(context, order),
                        chat: () => const ChatSheet(),
                        payment: () => paymentReceived(context, order),
                      ),
                    )
                  : AppCardSheet(
                      child: SizedBox(height: 300.h, width: double.infinity),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
