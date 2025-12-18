import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/utils/exit_app_dialogue.dart';
import 'package:gauva_driver/core/utils/set_status_bar_color.dart';
import 'package:gauva_driver/core/widgets/location_permission_wrapper.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:gauva_driver/presentation/account_page/view/account_page.dart';
import 'package:gauva_driver/presentation/dashboard/provider/dashboard_index_provider.dart';
import 'package:gauva_driver/presentation/intercity/intercity_dashboard.dart';
import 'package:gauva_driver/presentation/ride_history/view/ride_history_view.dart';
// import 'package:gauva_driver/presentation/wallet/views/wallet.dart'; // Commented out - Wallet page removed

import '../../booking/provider/driver_providers.dart';
import '../../booking/provider/websocket_provider.dart';
import '../../home_page/view/home_page.dart';
import '../../home_page/widgets/order_request_dialogue.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription? _rideRequestSubscription;

  @override
  void initState() {
    super.initState();
    setStatusBarColor(change: true);
    showOrderDialogueFromFirebase();

    // Listen for WebSocket Ride Requests
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(webSocketNotifierProvider.notifier);
      _rideRequestSubscription = notifier.newRideRequestStream.listen((data) {
        print('🚖 Dashboard: New Ride Request Stream Received: $data');

        // Extract ID (try multiple possible keys)
        final rideId =
            data['rideId'] ??
            data['id'] ??
            data['orderId'] ??
            data['order_id'] ??
            data['ride']?['id'] ??
            data['ride']?['rideId'];

        if (rideId != null) {
          if (mounted) {
            print('🚖 Dashboard: Triggering order request flow for ID: $rideId');
            // Use the same flow as Pusher to ensure consistency
            // This will start the timer, reset state, show dialogue, and fetch order details
            ref
                .read(driverStatusNotifierProvider.notifier)
                .orderRequest(data: {'order_id': rideId is int ? rideId : int.tryParse(rideId.toString()) ?? rideId});
          }
        } else {
          print('⚠️ Dashboard: Received ride request but ID is missing: $data');
          print('⚠️ Dashboard: Available keys: ${data.keys.toList()}');
        }
      });
    });
  }

  @override
  void dispose() {
    _rideRequestSubscription?.cancel();
    super.dispose();
  }

  Future<void> showOrderDialogueFromFirebase() async {
    try {
      final remoteMsg = await LocalStorageService().getRemoteMessage();

      if (remoteMsg != null) {
        // log(remoteMsg.toJson().toString());
        final sentTime = DateTime.tryParse(remoteMsg.sentTime ?? '');
        if (sentTime == null) {
          await LocalStorageService().clearRemoteMessage();
          return;
        }
        final now = DateTime.now().toUtc();
        final difference = now.difference(sentTime).inSeconds;
        if (difference > 30) {
          await LocalStorageService().clearRemoteMessage();
          return;
        }
        orderRequestDialogue(showFromFirebase: true, orderId: remoteMsg.orderId);
        await LocalStorageService().clearRemoteMessage();
      }
    } catch (e) {
      // delayShowMessage(show: (){showNotification(message: 'From dashboard $e');},);
    }
  }

  List<Widget> get _pages => [HomePage(), IntercityDashboard(), RideHistoryPage(), AccountPage()];

  void _onItemTapped(int index) {
    ref.read(dashboardIndexProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context) => ExitAppWrapper(
    child: LocationPermissionWrapper(
      child: Scaffold(
        key: _scaffoldKey,
        body: _pages[ref.watch(dashboardIndexProvider)],
        bottomNavigationBar: CustomBottomNavBar(currentIndex: ref.watch(dashboardIndexProvider), onTap: _onItemTapped),
      ),
    ),
  );
}
