import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/data/models/coupon/coupon_model.dart';
import 'package:gauva_driver/presentation/subscription/provider/coupon_providers.dart';

class CouponListScreen extends ConsumerStatefulWidget {
  final double planPrice;

  const CouponListScreen({super.key, required this.planPrice});

  @override
  ConsumerState<CouponListScreen> createState() => _CouponListScreenState();
}

class _CouponListScreenState extends ConsumerState<CouponListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch coupons when screen loads
    Future.microtask(() => ref.read(couponListNotifierProvider.notifier).getCoupons());
  }

  @override
  Widget build(BuildContext context) {
    final couponState = ref.watch(couponListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Coupons', style: context.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: couponState.when(
        initial: () => const Center(child: Text('Loading coupons...')),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (failure) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
              Gap(16.h),
              Text(
                failure.message,
                style: context.bodyMedium?.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              Gap(16.h),
              ElevatedButton(
                onPressed: () => ref.read(couponListNotifierProvider.notifier).getCoupons(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        success: (coupons) {
          if (coupons.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_offer_outlined, size: 64.sp, color: ColorPalette.neutral50),
                  Gap(16.h),
                  Text('No coupons available', style: context.titleMedium?.copyWith(color: ColorPalette.neutral50)),
                ],
              ),
            );
          }

          final validCoupons = coupons
              .where((coupon) => coupon.canBeUsed && coupon.isValidForAmount(widget.planPrice))
              .toList();

          final invalidCoupons = coupons
              .where((coupon) => !coupon.canBeUsed || !coupon.isValidForAmount(widget.planPrice))
              .toList();

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (validCoupons.isNotEmpty) ...[
                  Text(
                    'Available for this plan',
                    style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: ColorPalette.neutral20),
                  ),
                  Gap(12.h),
                  ...validCoupons.map((coupon) => _buildCouponCard(coupon, isValid: true)),
                ],

                if (invalidCoupons.isNotEmpty) ...[
                  Gap(24.h),
                  Text(
                    'Not applicable',
                    style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: ColorPalette.neutral50),
                  ),
                  Gap(12.h),
                  ...invalidCoupons.map((coupon) => _buildCouponCard(coupon, isValid: false)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCouponCard(Coupon coupon, {required bool isValid}) {
    final discount = coupon.calculateDiscount(widget.planPrice);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isValid ? ColorPalette.primary50.withOpacity(0.3) : ColorPalette.neutral90,
          width: 1.5,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isValid ? () => Navigator.pop(context, coupon.code) : null,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Coupon Icon
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: isValid ? ColorPalette.primary50.withOpacity(0.1) : ColorPalette.neutral90,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.local_offer,
                        color: isValid ? ColorPalette.primary50 : ColorPalette.neutral50,
                        size: 20.sp,
                      ),
                    ),
                    Gap(12.w),
                    // Coupon Code
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coupon.code,
                            style: context.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isValid ? ColorPalette.neutral20 : ColorPalette.neutral50,
                            ),
                          ),
                          Gap(4.h),
                          Text(
                            coupon.description ?? '',
                            style: context.bodySmall?.copyWith(color: ColorPalette.neutral50),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Discount Badge
                    if (isValid)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Text(
                          coupon.discountType == 'PERCENTAGE'
                              ? '${coupon.discountValue.toInt()}% OFF'
                              : '₹${coupon.discountValue.toInt()} OFF',
                          style: context.bodySmall?.copyWith(color: Colors.green.shade700, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),

                if (isValid) ...[
                  Gap(12.h),
                  Divider(color: ColorPalette.neutral90, height: 1),
                  Gap(12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'You save: ₹${discount.toStringAsFixed(0)}',
                        style: context.bodyMedium?.copyWith(color: Colors.green.shade700, fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 14.sp, color: ColorPalette.primary50),
                    ],
                  ),
                ] else ...[
                  Gap(8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(4.r)),
                    child: Text(
                      _getInvalidReason(coupon),
                      style: context.bodySmall?.copyWith(color: Colors.orange.shade700, fontSize: 11.sp),
                    ),
                  ),
                ],

                // Expiry info
                if (coupon.expiryDate != null) ...[
                  Gap(8.h),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12.sp, color: ColorPalette.neutral50),
                      Gap(4.w),
                      Text(
                        'Valid till ${_formatDate(coupon.expiryDate!)}',
                        style: context.bodySmall?.copyWith(color: ColorPalette.neutral50, fontSize: 11.sp),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getInvalidReason(Coupon coupon) {
    if (coupon.isExpired) return 'Expired';
    if (coupon.isUsageLimitExceeded) return 'Usage limit reached';
    if (!coupon.isActive) return 'Not active';
    if (coupon.minAmount != null && widget.planPrice < coupon.minAmount!) {
      return 'Minimum amount: ₹${coupon.minAmount!.toInt()}';
    }
    if (coupon.maxAmount != null && widget.planPrice > coupon.maxAmount!) {
      return 'Maximum amount: ₹${coupon.maxAmount!.toInt()}';
    }
    return 'Not applicable';
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
