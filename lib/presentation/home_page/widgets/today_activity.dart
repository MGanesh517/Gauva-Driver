import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/common/loading_view.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/error_view.dart';
import 'package:gauva_driver/presentation/home_page/widgets/activity_builder.dart';
import 'package:gauva_driver/presentation/home_page/widgets/activity_top.dart';
import 'package:gauva_driver/presentation/home_page/provider/home_notifier_provider.dart';

Widget todayActivity(BuildContext context) => Padding(
  padding: EdgeInsets.symmetric(vertical: 9.0.h),
  child: Column(
    children: [
      activityTop(context),
      Expanded(
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(homeProvider);
            return state.when(
              initial: () => Center(child: Text(localize(context).initializing)),
              loading: () => const LoadingView(),
              success: (data) {
                if (data?.rides == null || data!.rides!.isEmpty) {
                  return Center(
                    child: Text(localize(context).no_rides_today, style: Theme.of(context).textTheme.bodyMedium),
                  );
                }
                return activityBuilder(context, orderList: data!.rides!, showPrice: true);
              },
              error: (e) => ErrorView(message: e.message),
            );
          },
        ),
      ),
    ],
  ),
);
