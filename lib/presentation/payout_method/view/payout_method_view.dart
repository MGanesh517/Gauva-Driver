import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/buttons/app_back_button.dart';
import 'package:gauva_driver/presentation/payout_method/widget/add_button.dart';
import 'package:gauva_driver/presentation/payout_method/widget/custom_payment_card.dart';

import '../../../common/error_view.dart';
import '../../../common/loading_view.dart';
import '../../../data/models/my_card_model/my_card_model.dart';
import '../../wallet/provider/provider.dart';

class PayoutMethodView extends ConsumerStatefulWidget {
  const PayoutMethodView({super.key});

  @override
  ConsumerState<PayoutMethodView> createState() => _PayoutMethodViewState();
}

class _PayoutMethodViewState extends ConsumerState<PayoutMethodView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(myCardsProvider.notifier).myCards());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const AppBackButton(),
      title: Text(
        localize(context).payout_method,
        style: context.bodyMedium?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
        ),
      ),
      backgroundColor: isDarkMode() ? Colors.black : Colors.white,
    ),
    resizeToAvoidBottomInset: false,
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    floatingActionButton: Container(
      padding: EdgeInsets.all(16.r),
      color: isDarkMode() ? Colors.black : Colors.white,
      child: addButton(context),
    ),
    body: Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(myCardsProvider);
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const LoadingView(),
          success: (list) {
            if (list.isEmpty) {
              return Center(
                child: Text(localize(context).no_cards_yet, style: context.bodyLarge?.copyWith(color: Colors.red)),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 80.h),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final Cards card = list[index];

                return customPaymentCard(
                  context,
                  ref,
                  id: card.id,
                  paymentMethodName: card.name,
                  cardNumber: "*********${card.last4 ?? ''}",
                  cardHolderName: card.cardHolderName,
                  expiryDate: '**/${card.expMonth}/${card.expYear}',
                );
              },
            );
          },
          error: (e) => ErrorView(message: e.message),
        );
      },
    ),
  );
}
