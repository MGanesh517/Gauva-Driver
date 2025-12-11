import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/common/loading_view.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/error_view.dart';
import 'package:gauva_driver/presentation/home_page/widgets/activity_builder.dart';
import 'package:gauva_driver/presentation/home_page/widgets/activity_top.dart';
import 'package:gauva_driver/presentation/ride_history/provider/ride_history_provider.dart';

Widget todayActivity(BuildContext context) => Padding(
  padding: EdgeInsets.symmetric(vertical: 9.0.h),
  child: Column(
    children: [
      activityTop(context),
      Expanded(
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(rideHistoryProvider);
            return state.when(
              initial: () => Text(localize(context).initializing),
              loading: () => const LoadingView(),
              success: (data) => activityBuilder(context, orderList: data),
              error: (e) => ErrorView(message: e.message),
            );
          },
        ),
      ),
    ],
  ),
);
