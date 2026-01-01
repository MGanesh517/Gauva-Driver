class SubscriptionPlan {
  final int id;
  final String vehicleType; // "BIKE", "AUTO", "CAR"
  final String subscriptionType; // "UNLIMITED", "INTERCITY_EARNING"
  final double price;
  final int? durationDays;
  final int? durationHours;
  final double? earningLimit;
  final double? percentage;
  final bool active;
  final String? displayName;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubscriptionPlan({
    required this.id,
    required this.vehicleType,
    required this.subscriptionType,
    required this.price,
    this.durationDays,
    this.durationHours,
    this.earningLimit,
    this.percentage,
    required this.active,
    this.displayName,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      vehicleType: json['vehicleType'],
      subscriptionType: json['subscriptionType'],
      price: (json['price'] as num).toDouble(),
      durationDays: json['durationDays'],
      durationHours: json['durationHours'],
      earningLimit: json['earningLimit'] != null ? (json['earningLimit'] as num).toDouble() : null,
      percentage: json['percentage'] != null ? (json['percentage'] as num).toDouble() : null,
      active: json['active'],
      displayName: json['displayName'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
