import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:gauva_driver/common/loading_view.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';

import '../provider/ride_history_provider.dart';
import '../widget/ride_history_card.dart';

class RideHistoryPage extends ConsumerStatefulWidget {
  const RideHistoryPage({super.key});

  @override
  ConsumerState<RideHistoryPage> createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends ConsumerState<RideHistoryPage> {
  DateTime? date;
  @override
  void initState() {
    super.initState();
    date = null;
    Future.microtask(() => _fetchData());
  }

  void _fetchData() {
    ref
        .read(rideHistoryProvider.notifier)
        .getRideHistory(date: date == null ? null : DateFormat('yyyy-MM-dd', 'en').format(date!));
  }

  @override
  Widget build(BuildContext context) {
    final rideState = ref.watch(rideHistoryProvider);

    return RefreshIndicator(
      onRefresh: () async {
        _fetchData();
      },
      child: Scaffold(
        backgroundColor: isDarkMode() ? Colors.black : context.surface,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            localize(context).ride_history,
            style: context.bodyMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: rideState.when(
            initial: () => Center(child: Text(localize(context).no_rides_yet)),
            loading: () => const LoadingView(),
            error: (e) => Center(child: Text(localize(context).error_with_msg(e.message))),
            success: (orders) {
              if (orders.isEmpty) {
                return Center(
                  child: Text(localize(context).no_rides_yet, style: context.bodyLarge?.copyWith(color: Colors.red)),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return RideCard(order: order, showPrice: true);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
