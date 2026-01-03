class PurchaseSubscriptionResponse {
  final String orderId;
  final double orderAmount;
  final String orderCurrency;
  final String razorpayKey;
  final int transactionId;
  final int planId;
  final double amount;
  final String status;
  final double? discountAmount;
  final String? appliedCouponCode;

  PurchaseSubscriptionResponse({
    required this.orderId,
    required this.orderAmount,
    required this.orderCurrency,
    required this.razorpayKey,
    required this.transactionId,
    required this.planId,
    required this.amount,
    required this.status,
    this.discountAmount,
    this.appliedCouponCode,
  });

  factory PurchaseSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseSubscriptionResponse(
      orderId: json['orderId'],
      orderAmount: (json['orderAmount'] as num).toDouble(),
      orderCurrency: json['orderCurrency'],
      razorpayKey: json['razorpayKey'],
      transactionId: json['transactionId'],
      planId: json['planId'],
      amount: (json['amount'] as num).toDouble(),
      status: json['status'],
      discountAmount: json['discountAmount'] != null ? (json['discountAmount'] as num).toDouble() : null,
      appliedCouponCode: json['appliedCouponCode'],
    );
  }
}
