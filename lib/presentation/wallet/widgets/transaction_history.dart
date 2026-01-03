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
import 'package:gauva_driver/core/widgets/error_view.dart';

import 'package:gauva_driver/presentation/wallet/provider/provider.dart';

import '../../../core/utils/custom_date_picker.dart';
import '../../../core/utils/format_date.dart';
import '../../../data/models/wallet_model/wallet_transaction_history_model.dart';

Widget transactionHistory(BuildContext context) => Expanded(
  child: Consumer(
    builder: (context, ref, _) {
      final state = ref.watch(transactionHistoryProvider);
      final notifier = ref.watch(transactionHistoryProvider.notifier);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  localize(context).transactions,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodyMedium?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
                  ),
                ),
              ),
              // Gap(8.w),
              // InkWell(
              //   onTap: () async {
              //     final date = await customDatePickerReturnDate(
              //       context,
              //       initialDate: state.dateTime,
              //       lastDate: DateTime.now(),
              //       firstDate: DateTime.now().subtract(const Duration(days: 1000)),
              //     );
              //     notifier.updateDateTime(date);
              //     await Future.delayed(const Duration(milliseconds: 100));
              //     notifier.getTransactionHistory();
              //   },
              //   child: Row(
              //     children: [
              //       Text(
              //         state.dateTime == null ? '' : DateFormat('dd/MM/yyyy', 'en').format(state.dateTime!),
              //         style: context.bodyMedium?.copyWith(
              //           fontSize: 14.sp,
              //           fontWeight: FontWeight.w400,
              //           color: const Color(0xFF687387),
              //         ),
              //       ),
              //       Gap(8.w),
              //       Icon(Icons.calendar_month, color: ColorPalette.primary50, size: 24.h),
              //       Gap(16.w),
              //     ],
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 16),
          // Tabs removed
          Expanded(child: transactionList(context)),
        ],
      );
    },
  ),
);

// Removed buildTabItem

Widget transactionList(BuildContext context) => Consumer(
  builder: (context, ref, _) {
    final state = ref.watch(transactionHistoryProvider);
    final transactions = state.transactions;

    return transactions.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const LoadingView(),
      error: (e) => ErrorView(message: e.message),
      success: (data) {
        if (data.isEmpty) {
          return Center(child: Text(localize(context).no_transactions_found));
        }
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => transactionTile(context, transaction: data[index]),
        );
      },
    );
  },
);

Widget transactionTile(BuildContext context, {required Transaction transaction}) {
  final isCredit = transaction.transaction?.toLowerCase() == 'credit';

  return Container(
    margin: EdgeInsets.only(bottom: 8.h),
    padding: EdgeInsets.all(12.r),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      color: isDarkMode() ? Colors.black : const Color(0xFFF6F7F9),
      border: isDarkMode() ? Border.all(color: Colors.white) : null,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: isCredit ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: isCredit ? Colors.green : Colors.red,
            size: 20.r,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.method ?? 'Transaction',
                style: context.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
                ),
              ),
              if (transaction.notes != null && transaction.notes!.isNotEmpty) ...[
                Gap(4.h),
                Text(
                  transaction.notes!,
                  style: context.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
              Gap(4.h),
              Text(
                formatDateEnglish(transaction.createdAt),
                style: context.bodyMedium?.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        Text(
          "${isCredit ? '+' : '-'} ₹${transaction.amount?.toStringAsFixed(2) ?? '0.00'}",
          style: context.bodyMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: isCredit ? Colors.green : Colors.red,
          ),
        ),
      ],
    ),
  );
}
