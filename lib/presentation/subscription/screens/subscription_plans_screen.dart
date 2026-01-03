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
import 'package:gauva_driver/data/models/coupon/coupon_model.dart';
import 'package:gauva_driver/presentation/subscription/provider/subscription_providers.dart';
import 'package:gauva_driver/presentation/subscription/provider/coupon_providers.dart';
import 'package:gauva_driver/presentation/subscription/screens/coupon_list_screen.dart';
import '../../profile/provider/profile_providers.dart';

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
            onSuccess: () async {
              showNotification(message: "Payment Verified & Subscription Activated!", isSuccess: true);
              // Refresh current subscription
              ref.read(currentSubscriptionNotifierProvider.notifier).getCurrentSubscription();

              // Refresh driver profile to update subscription status in app state
              await ref.read(driverDetailsNotifierProvider.notifier).getDriverDetails();

              if (mounted) {
                Navigator.pop(context); // Go back to home/online screen
              }
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionPlansNotifierProvider);

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
                child: InkWell(
                  onTap: () => _showPlanDetailsBottomSheet(plan),
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
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios, size: 16.sp, color: ColorPalette.primary50),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showPlanDetailsBottomSheet(SubscriptionPlan plan) {
    final TextEditingController couponController = TextEditingController();
    String? appliedCoupon;
    double? discountAmount;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final double originalPrice = plan.price;
            final double finalPrice = originalPrice - (discountAmount ?? 0);

            return Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2.r)),
                      ),
                    ),
                    Gap(20.h),

                    // Plan Title
                    Text(
                      plan.displayName ?? plan.subscriptionType.replaceAll('_', ' '),
                      style: context.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: ColorPalette.neutral20),
                    ),
                    Gap(8.h),
                    Text(plan.description ?? '', style: context.bodyMedium?.copyWith(color: ColorPalette.neutral50)),
                    Gap(20.h),

                    // Price Section
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: ColorPalette.primary50.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: ColorPalette.primary50.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Plan Price:', style: context.bodyMedium),
                              Text(
                                '₹${originalPrice.toStringAsFixed(0)}',
                                style: context.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  decoration: discountAmount != null ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ],
                          ),
                          if (discountAmount != null) ...[
                            Gap(8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Discount:', style: context.bodyMedium?.copyWith(color: Colors.green)),
                                Text(
                                  '- ₹${discountAmount!.toStringAsFixed(0)}',
                                  style: context.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Final Amount:', style: context.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                Text(
                                  '₹${finalPrice.toStringAsFixed(0)}',
                                  style: context.displaySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ColorPalette.primary50,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Gap(20.h),

                    // Coupon Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Have a Coupon Code?', style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        TextButton(
                          onPressed: () async {
                            final selectedCoupon = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(builder: (context) => CouponListScreen(planPrice: originalPrice)),
                            );

                            if (selectedCoupon != null) {
                              couponController.text = selectedCoupon;
                              // Fetch the actual coupon to calculate discount
                              final coupons = ref
                                  .read(couponListNotifierProvider)
                                  .maybeWhen(success: (data) => data, orElse: () => <Coupon>[]);

                              final couponIndex = coupons.indexWhere(
                                (c) => c.code.toUpperCase() == selectedCoupon.toUpperCase(),
                              );
                              if (couponIndex != -1) {
                                final coupon = coupons[couponIndex];
                                setState(() {
                                  appliedCoupon = selectedCoupon.toUpperCase();
                                  discountAmount = coupon.calculateDiscount(originalPrice);
                                });
                              }
                            }
                          },
                          child: Text(
                            'See All',
                            style: context.bodyMedium?.copyWith(
                              color: ColorPalette.primary50,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(12.h),

                    if (appliedCoupon == null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: couponController,
                              decoration: InputDecoration(
                                hintText: 'Enter coupon code',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                              ),
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ),
                          Gap(8.w),
                          ElevatedButton(
                            onPressed: () {
                              final code = couponController.text.trim();
                              if (code.isNotEmpty) {
                                // Fetch the actual coupon to calculate discount
                                final coupons = ref
                                    .read(couponListNotifierProvider)
                                    .maybeWhen(success: (data) => data, orElse: () => <Coupon>[]);

                                final couponIndex = coupons.indexWhere(
                                  (c) => c.code.toUpperCase() == code.toUpperCase(),
                                );

                                if (couponIndex != -1) {
                                  final coupon = coupons[couponIndex];
                                  if (coupon.canBeUsed && coupon.isValidForAmount(originalPrice)) {
                                    setState(() {
                                      appliedCoupon = code.toUpperCase();
                                      discountAmount = coupon.calculateDiscount(originalPrice);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          coupon.isExpired
                                              ? 'Coupon has expired'
                                              : coupon.isUsageLimitExceeded
                                              ? 'Coupon usage limit reached'
                                              : !coupon.isActive
                                              ? 'Coupon is not active'
                                              : 'Coupon not valid for this plan amount',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Invalid coupon code'), backgroundColor: Colors.red),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.primary50,
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                            ),
                            child: Text('Apply', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ] else ...[
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green.shade700, size: 20.sp),
                            Gap(8.w),
                            Expanded(
                              child: Text(
                                'Coupon Applied: $appliedCoupon',
                                style: context.bodyMedium?.copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  appliedCoupon = null;
                                  discountAmount = null;
                                  couponController.clear();
                                });
                              },
                              child: Text('Remove', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                    ],
                    Gap(24.h),

                    // Subscribe Button
                    AppPrimaryButton(
                      isLoading: _purchasingPlanId == plan.id,
                      onPressed: () {
                        Navigator.pop(context);
                        _initiatePurchaseWithCoupon(plan, appliedCoupon);
                      },
                      child: Text(
                        'Proceed to Payment',
                        style: context.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _initiatePurchaseWithCoupon(SubscriptionPlan plan, String? couponCode) {
    if (_purchasingPlanId != null) return;

    setState(() {
      _purchasingPlanId = plan.id;
      _currentOrderId = null;
    });

    ref
        .read(purchaseSubscriptionNotifierProvider.notifier)
        .purchaseSubscription(
          planId: plan.id,
          couponCode: couponCode,
          onSuccess: (response) {
            setState(() {
              _purchasingPlanId = null;
              _currentOrderId = response.orderId;
            });

            final options = {
              'key': response.razorpayKey,
              'amount': (response.orderAmount * 100).toInt(),
              'currency': response.orderCurrency,
              'name': 'Gauva Subscription',
              'description': plan.displayName ?? 'Subscription Plan',
              'order_id': response.orderId,
              'prefill': {'contact': '', 'email': ''},
            };

            _razorpay.open(options);
          },
          onError: (message) {
            setState(() {
              _purchasingPlanId = null;
            });
            showNotification(message: message);
          },
        );
  }
}
