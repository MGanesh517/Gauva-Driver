import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/core/utils/helpers.dart';
import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';

import 'package:gauva_driver/data/models/subscription/subscription_plan_model.dart';
import 'package:gauva_driver/presentation/subscription/provider/subscription_providers.dart';

class SubscriptionPlansScreen extends ConsumerStatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  ConsumerState<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends ConsumerState<SubscriptionPlansScreen> {
  late Razorpay _razorpay;
  int? _purchasingPlanId;
  String? _currentOrderId;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionPlansNotifierProvider.notifier).getPlans();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Use the stored orderId from purchase response, or fallback to Razorpay response
    final orderIdToVerify = _currentOrderId ?? response.orderId;

    if (orderIdToVerify != null) {
      ref
          .read(paymentVerificationNotifierProvider.notifier)
          .verifyPayment(
            orderId: orderIdToVerify,
            paymentId: response.paymentId,
            onSuccess: () {
              showNotification(message: "Payment Verified & Subscription Activated!", isSuccess: true);
              // Refresh current subscription and pop
              ref.read(currentSubscriptionNotifierProvider.notifier).getCurrentSubscription();
              Navigator.pop(context); // Go back to home/online screen
            },
            onError: (message) {
              showNotification(message: "Payment Verification Failed: $message");
            },
          );
    } else {
      showNotification(message: "Order ID missing. Cannot verify payment.");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showNotification(message: "Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showNotification(message: "External Wallet: ${response.walletName}");
  }

  void _initiatePurchase(SubscriptionPlan plan) {
    if (_purchasingPlanId != null) return;

    setState(() {
      _purchasingPlanId = plan.id;
      _currentOrderId = null; // Reset previous order ID
    });

    ref
        .read(purchaseSubscriptionNotifierProvider.notifier)
        .purchaseSubscription(
          planId: plan.id,
          onSuccess: (response) {
            setState(() {
              _purchasingPlanId = null;
              _currentOrderId = response.orderId; // Store the order ID
            });
            var options = {
              'key': response.razorpayKey,
              'amount': (response.orderAmount * 100).toInt(), // in paise
              'name': 'Gauva Subscription',
              'description': plan.displayName ?? 'Driver Subscription',
              'order_id': response.orderId,
              'prefill': {
                'contact': '9999999999', // Ideally fetch from user profile
                'email': 'driver@example.com', // Ideally fetch from user profile
              },
              'external': {
                'wallets': ['paytm'],
              },
              'notes': {'transaction_id': response.transactionId.toString(), 'type': 'subscription'},
            };
            try {
              _razorpay.open(options);
            } catch (e) {
              showNotification(message: "Error launching payment: $e");
            }
          },
          onError: (message) {
            setState(() {
              _purchasingPlanId = null;
            });
            showNotification(message: message);
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionPlansNotifierProvider);
    final purchaseState = ref.watch(purchaseSubscriptionNotifierProvider);
    final isLoadingPurchase = purchaseState.maybeWhen(loading: () => true, orElse: () => false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Subscription', style: context.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: state.when(
        initial: () => const SizedBox(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (failure) => Center(child: Text(failure.message)),
        success: (plans) {
          if (plans.isEmpty) {
            return const Center(child: Text("No subscription plans available"));
          }
          return ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: plans.length,
            separatorBuilder: (context, index) => Gap(16.h),
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: ColorPalette.neutral90),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.displayName ?? plan.subscriptionType.replaceAll('_', ' '),
                      style: context.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: ColorPalette.neutral20),
                    ),
                    Gap(8.h),
                    Text(plan.description ?? '', style: context.bodyMedium?.copyWith(color: ColorPalette.neutral50)),
                    Gap(12.h),
                    Row(
                      children: [
                        Text(
                          '₹${plan.price.toStringAsFixed(0)}',
                          style: context.displaySmall?.copyWith(
                            color: ColorPalette.primary50,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (plan.durationDays != null)
                          Text(
                            ' / ${plan.durationDays} Days',
                            style: context.bodyMedium?.copyWith(color: ColorPalette.neutral50),
                          ),
                      ],
                    ),
                    Gap(16.h),
                    AppPrimaryButton(
                      isLoading: _purchasingPlanId == plan.id,
                      onPressed: isLoadingPurchase ? null : () => _initiatePurchase(plan),
                      child: Text(
                        'Subscribe Now',
                        style: context.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
