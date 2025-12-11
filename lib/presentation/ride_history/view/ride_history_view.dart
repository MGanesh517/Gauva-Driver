import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:gauva_driver/common/loading_view.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/presentation/home_page/widgets/activity_builder.dart';
import '../../../core/utils/custom_date_picker.dart';
import '../provider/ride_history_provider.dart';

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
          title: Text(
            localize(context).ride_history,
            style: context.bodyMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
            ),
          ),
          actions: [
            InkWell(
              onTap: () async {
                date = await customDatePickerReturnDate(
                  context,
                  initialDate: date,
                  lastDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 1000)),
                );
                setState(() {});
                await Future.delayed(const Duration(milliseconds: 100));
                _fetchData();
              },
              child: Row(
                children: [
                  Text(
                    date == null ? '' : DateFormat('dd-MM-yyyy', 'en').format(date!),
                    // AppLocalizations.of(context).today,
                    style: context.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF687387),
                    ),
                  ),
                  Gap(8.w),
                  Icon(Icons.calendar_month, color: ColorPalette.primary50, size: 24.h),
                  Gap(16.w),
                ],
              ),
            ),
          ],
        ),
        body: rideState.when(
          initial: () => Center(child: Text(localize(context).no_rides_yet)),
          loading: () => const LoadingView(),
          error: (e) => Center(child: Text(localize(context).error_with_msg(e.message))),
          success: (orders) {
            if (orders.isEmpty) {
              return Center(
                child: Text(localize(context).no_rides_yet, style: context.bodyLarge?.copyWith(color: Colors.red)),
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: activityBuilder(context, orderList: orders, showPrice: true),
            );
          },
        ),
      ),
    );
  }
}
