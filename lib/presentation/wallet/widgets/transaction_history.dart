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
import 'package:gauva_driver/gen/assets.gen.dart';
import 'package:gauva_driver/presentation/wallet/provider/provider.dart';

import '../../../core/utils/build_network_image.dart';
import '../../../core/utils/custom_date_picker.dart';
import '../../../core/utils/format_date.dart';
import '../../../data/models/wallet_model/wallet_transaction_history_model.dart';

ValueNotifier<int> selectedTabIndex = ValueNotifier(0);

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
              Gap(8.w),
              InkWell(
                onTap: () async {
                  final date = await customDatePickerReturnDate(
                    context,
                    initialDate: state.dateTime,
                    lastDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 1000)),
                  );
                  notifier.updateDateTime(date);
                  await Future.delayed(const Duration(milliseconds: 100));
                  notifier.getTransactionHistory();
                },
                child: Row(
                  children: [
                    Text(
                      state.dateTime == null ? '' : DateFormat('dd/MM/yyyy', 'en').format(state.dateTime!),
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
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: isDarkMode() ? Colors.black : const Color(0xFFF6F7F9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                buildTabItem(context, localize(context).payment_received, 0),
                buildTabItem(context, localize(context).withdraw_history, 1),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<int>(
            valueListenable: selectedTabIndex,
            builder: (context, int v, _) => Expanded(
              child: selectedTabIndex.value == 0
                  ? transactionList(context, isPaymentReceive: true)
                  : transactionList(context, isPaymentReceive: false),
            ),
          ),
        ],
      );
    },
  ),
);

Widget buildTabItem(BuildContext context, String label, int index) => Consumer(
  builder: (context, ref, _) {
    final stateNotifier = ref.read(transactionHistoryProvider.notifier);
    final isSelected = selectedTabIndex.value == index;

    return Expanded(
      child: InkWell(
        onTap: () async {
          selectedTabIndex.value = index;
          stateNotifier.updatePaymentMode(index == 0 ? 'received' : 'withdraw');
          await stateNotifier.getTransactionHistory();
        },
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? isDarkMode()
                      ? Colors.black12
                      : Colors.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: isSelected ? Border.all(color: const Color(0xFFDFDBF9), width: 1.w) : null,
          ),
          child: Text(
            label,
            style: context.bodyMedium?.copyWith(
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? ColorPalette.primary50
                  : isDarkMode()
                  ? Colors.white
                  : const Color(0xFF24262D),
            ),
          ),
        ),
      ),
    );
  },
);

Widget transactionList(BuildContext context, {required bool isPaymentReceive}) => Consumer(
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
          itemBuilder: (context, index) =>
              transactionTile(context, transaction: data[index], isPaymentReceive: isPaymentReceive),
        );
      },
    );
  },
);

Widget transactionTile(BuildContext context, {required Transaction transaction, required bool isPaymentReceive}) =>
    Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: isDarkMode() ? Colors.black : const Color(0xFFF6F7F9),
        border: isDarkMode() ? Border.all(color: Colors.white) : null,
      ),
      child: Row(
        children: [
          isPaymentReceive
              ? CircleAvatar(
                  radius: 25.r,
                  backgroundColor: ColorPalette.primary50,
                  child: transaction.rider?.profilePicture != null
                      ? CircleAvatar(
                          radius: 24.r,
                          child: ClipOval(child: buildNetworkImage(imageUrl: transaction.rider?.profilePicture)),
                        )
                      : CircleAvatar(
                          radius: 24.r,
                          backgroundColor: ColorPalette.primary50,
                          child: Icon(Icons.account_balance_wallet, color: Colors.white, size: 20.r),
                        ),
                )
              : CircleAvatar(radius: 25.r, backgroundImage: Assets.images.paymentWithdrawCircle.provider()),
          Gap(8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPaymentReceive
                      ? (transaction.rider?.name ?? transaction.notes ?? 'Payment Received')
                      : localize(context).payment_withdraw,
                  style: context.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
                  ),
                ),
                Gap(4.h),
                Row(
                  children: [
                    richTextTransaction(
                      context,
                      title: localize(context).id,
                      value: (transaction.id ?? 'N/A').toString(),
                    ),
                    richTextTransaction(
                      context,
                      title: localize(context).method,
                      value: transaction.method ?? transaction.paymentMode ?? 'N/A',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 42.h,
            width: 1.w,
            color: Colors.grey.shade200,
            margin: EdgeInsets.only(right: 8.w),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  text: isPaymentReceive ? '+ ' : '- ',
                  style: context.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: isPaymentReceive ? Colors.greenAccent : Colors.red,
                  ),
                  children: [
                    TextSpan(
                      text: "₹${transaction.amount?.toStringAsFixed(2) ?? '0.00'}",
                      style: context.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: isDarkMode() ? Colors.grey.shade500 : const Color(0xFF24262D),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(4.h),
              Text(
                formatDateEnglish(transaction.createdAt),
                style: context.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );

Widget richTextTransaction(BuildContext context, {String? title, String? value}) => Expanded(
  child: RichText(
    text: TextSpan(
      text: title,
      style: context.bodyMedium?.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w400, color: const Color(0xFF565F73)),
      children: [
        TextSpan(
          text: value,
          style: context.bodyMedium?.copyWith(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: ColorPalette.primary50,
          ),
        ),
      ],
    ),
  ),
);
