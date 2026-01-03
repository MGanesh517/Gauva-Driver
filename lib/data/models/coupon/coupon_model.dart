class Coupon {
  final int id;
  final String code;
  final String? description;
  final String discountType; // 'PERCENTAGE' or 'FIXED'
  final double discountValue;
  final double? maxDiscount;
  final double? minAmount;
  final double? maxAmount;
  final int? usageLimit;
  final int usedCount;
  final DateTime? expiryDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Coupon({
    required this.id,
    required this.code,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.maxDiscount,
    this.minAmount,
    this.maxAmount,
    this.usageLimit,
    required this.usedCount,
    this.expiryDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      code: json['code'],
      description: json['description'],
      discountType: json['discountType'],
      discountValue: (json['discountValue'] as num).toDouble(),
      maxDiscount: json['maxDiscount'] != null ? (json['maxDiscount'] as num).toDouble() : null,
      minAmount: json['minAmount'] != null ? (json['minAmount'] as num).toDouble() : null,
      maxAmount: json['maxAmount'] != null ? (json['maxAmount'] as num).toDouble() : null,
      usageLimit: json['usageLimit'],
      usedCount: json['usedCount'] ?? 0,
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Calculate discount for a given amount
  double calculateDiscount(double amount) {
    if (discountType == 'PERCENTAGE') {
      double discount = (amount * discountValue) / 100;
      if (maxDiscount != null && discount > maxDiscount!) {
        discount = maxDiscount!;
      }
      return discount;
    } else {
      // FIXED discount
      return discountValue > amount ? amount : discountValue;
    }
  }

  // Check if coupon is valid for given amount
  bool isValidForAmount(double amount) {
    if (minAmount != null && amount < minAmount!) {
      return false;
    }
    if (maxAmount != null && amount > maxAmount!) {
      return false;
    }
    return true;
  }

  // Check if coupon is expired
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  // Check if usage limit exceeded
  bool get isUsageLimitExceeded {
    if (usageLimit == null) return false;
    return usedCount >= usageLimit!;
  }

  // Check if coupon can be used
  bool get canBeUsed {
    return isActive && !isExpired && !isUsageLimitExceeded;
  }
}
