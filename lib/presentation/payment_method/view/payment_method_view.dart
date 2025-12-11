import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';

import '../../../common/loading_view.dart';
import '../provider/provider.dart';

class PaymentMethodsPage extends ConsumerStatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  ConsumerState<PaymentMethodsPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<PaymentMethodsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(paymentMethodsNotifierProvider.notifier).getPaymentMethods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appConfigState = ref.watch(paymentMethodsNotifierProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(paymentMethodsNotifierProvider.notifier).getPaymentMethods();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Payment methods')),
        body: appConfigState.when(
          loading: () => const LoadingView(),
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $message', style: context.labelLarge),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref.read(paymentMethodsNotifierProvider.notifier).getPaymentMethods();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          success: (data) {
            final methods = data;
            if (methods.isEmpty) {
              return const Center(child: Text('No payment methods available'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                final item = methods[index];
                return Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: item.logo ?? '',
                      width: 55.w,
                      height: 55.h,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(item.value ?? '', style: context.labelLarge)),
                  ],
                );
              },
              separatorBuilder: (context, index) => const Divider(indent: 24),
              itemCount: methods.length,
            );
          },
          initial: () => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
