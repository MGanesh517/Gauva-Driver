import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/presentation/home_page/provider/home_notifier_provider.dart';
import 'package:gauva_driver/presentation/home_page/widgets/online_offline_page.dart';
import 'package:gauva_driver/presentation/home_page/widgets/top.dart';
import 'package:gauva_driver/presentation/ride_history/provider/ride_history_provider.dart';

import '../../../core/utils/is_dark_mode.dart';
import '../../booking/provider/home_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    ref.read(bookingNotifierProvider.notifier).initialize();
    Future.microtask(() {
      ref.read(homeProvider.notifier).getDashboard();
      ref.read(rideHistoryProvider.notifier).getRideHistory(date: 'today');
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(color: isDarkMode() ? Colors.black : Colors.white),
        child: Column(mainAxisSize: MainAxisSize.min, children: [top(context), Gap(12.h), onlineOfflinePage(context)]),
      ),
    ),
  );
}
