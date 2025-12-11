import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/presentation/wallet/provider/provider.dart';
import 'package:gauva_driver/presentation/wallet/widgets/wallet_summery.dart';

import '../../../core/utils/is_dark_mode.dart';
import '../widgets/transaction_history.dart';

class Wallet extends ConsumerStatefulWidget {
  const Wallet({super.key});

  @override
  ConsumerState<Wallet> createState() => _WalletState();
}

class _WalletState extends ConsumerState<Wallet> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(walletsBalanceProvider.notifier).getWalletBalance();
      ref.read(transactionHistoryProvider.notifier).getTransactionHistory();
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(color: isDarkMode() ? Colors.black : Colors.white),
        child: Column(children: [walletSummery(context), Gap(16.h), transactionHistory(context)]),
      ),
    ),
  );
}
