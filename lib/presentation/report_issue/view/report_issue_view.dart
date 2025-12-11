import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';

import '../../../core/utils/localize.dart';
import '../../../core/widgets/buttons/app_back_button.dart';
import '../../../gen/assets.gen.dart';
import '../provider/report_provider.dart';
import '../widget/cancel_submit_button.dart';
import '../widget/details_field.dart';
import '../widget/report_type_dropdown.dart';
import '../widget/top_content.dart';

class ReportIssueView extends ConsumerStatefulWidget {
  const ReportIssueView(this.orderId, {super.key});
  final int? orderId;

  @override
  ConsumerState<ReportIssueView> createState() => _ReportIssueViewState();
}

class _ReportIssueViewState extends ConsumerState<ReportIssueView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(selectReportTypeProvider.notifier).reset();
      ref.read(reportTypesNotifierProvider.notifier).getReportTypes();
    });
  }

  TextEditingController detailsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    detailsController.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: isDarkMode() ? context.surface : Colors.white,
      leading: const AppBackButton(),
      title: Text(
        localize(context).reportIssue,
        style: context.bodyMedium?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
        ),
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    floatingActionButton: cancelSubmitButton(
      context,
      orderId: widget.orderId,
      details: detailsController,
      reportType: ref.watch(selectReportTypeProvider)?.reportType,
    ),
    body: Container(
      color: isDarkMode() ? context.surface : Colors.white,
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(top: 8.h, bottom: 100.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Assets.images.reportIssue.image(height: 60.h, width: 60.w, fit: BoxFit.fill),
            Gap(8.h),
            topContent(context),
            Gap(16.h),
            reportTypeDropdown(context),
            Gap(12.h),
            detailsField(context, detailsController),
          ],
        ),
      ),
    ),
  );
}
