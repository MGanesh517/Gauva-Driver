import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/common/loading_view.dart';
// import 'package:gauva_driver/core/theme/text_theme.dart'; // Standard text theme
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/presentation/account_page/provider/terms_and_privacy_provider.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/localize.dart';
import '../../../core/widgets/error_view.dart';

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
    // "Rate Card" key might need to be added to l10n, using hardcoded for now or use similar
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
            success: (data) => SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Html(
                data: data,
                style: {"body": Style(color: isDarkMode() ? Colors.white : Colors.black, fontSize: FontSize(14.sp))},
              ),
            ),
            error: (failure) => ErrorView(message: failure.message),
          );
        },
      ),
    );
  }
}
