import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/common/loading_view.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/presentation/account_page/provider/terms_and_privacy_provider.dart';

class RateCardPage extends ConsumerStatefulWidget {
  const RateCardPage({super.key});

  @override
  ConsumerState<RateCardPage> createState() => _RateCardPageState();
}

class _RateCardPageState extends ConsumerState<RateCardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rateCardProvider.notifier).getRateCard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = "Rate Card";

    return Scaffold(
      backgroundColor: isDarkMode() ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          title, // localize(context).rate_card ?? "Rate Card"
          style: TextStyle(
            color: isDarkMode() ? Colors.white : Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode() ? Colors.black : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkMode() ? Colors.white : Colors.black),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(rateCardProvider);
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const LoadingView(),
            success: (data) {
              // Handle null or empty data
              if (data.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 64.r,
                          color: isDarkMode() ? Colors.white54 : Colors.black54,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No Rate Card Available',
                          style: TextStyle(
                            color: isDarkMode() ? Colors.white : Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Rate card information is currently not available.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: isDarkMode() ? Colors.white70 : Colors.black54, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Display HTML content with error handling
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Html(
                  data: data.trim().isEmpty ? '<p>No content available</p>' : data,
                  style: {"body": Style(color: isDarkMode() ? Colors.white : Colors.black, fontSize: FontSize(14.sp))},
                ),
              );
            },
            error: (failure) => ErrorWidget(state),
          );
        },
      ),
    );
  }
}
