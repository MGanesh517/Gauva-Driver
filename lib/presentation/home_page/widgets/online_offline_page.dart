import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/common/shimmer_loader.dart';
import 'package:gauva_driver/presentation/home_page/widgets/offline_view.dart';
import 'package:gauva_driver/presentation/home_page/widgets/online_offline_switch.dart';
import 'package:gauva_driver/presentation/home_page/widgets/online_view.dart';

import '../../booking/provider/driver_providers.dart';

Widget onlineOfflinePage(BuildContext context) => Consumer(
  builder: (context, ref, _) {
    final status = ref.watch(driverStatusNotifierProvider);
    final bool isLoading = status.whenOrNull(loading: () => true) ?? false;
    return ValueListenableBuilder<bool>(
      valueListenable: isOnlineNotifier,
      builder: (context, isOnline, _) => isLoading
          ? Expanded(
              child: buildShimmer(
                height: double.infinity,
                width: double.infinity,
                borderRadius: BorderRadius.circular(8.r),
                child: const SizedBox(width: double.infinity),
              ),
            )
          : isOnline
          ? onlineView(context)
          : Expanded(child: offlineView(context)),
    );
  },
);
