import 'subscription_plan_model.dart';

class DriverSubscription {
  final int id;
  final int driverId;
  final SubscriptionPlan plan;
  final DateTime startTime;
  final DateTime? endTime;
  final double totalEarned;
  final String status; // "ACTIVE", "EXPIRED", "BLOCKED"
  final String? paymentId;
  final int? paymentTransactionId;
  final DateTime createdAt;
  final DateTime updatedAt;

  DriverSubscription({
    required this.id,
    required this.driverId,
    required this.plan,
    required this.startTime,
    this.endTime,
    required this.totalEarned,
    required this.status,
    this.paymentId,
    this.paymentTransactionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriverSubscription.fromJson(Map<String, dynamic> json) {
    return DriverSubscription(
      id: json['id'],
      driverId: json['driverId'],
      plan: SubscriptionPlan.fromJson(json['plan']),
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      totalEarned: (json['totalEarned'] as num).toDouble(),
      status: json['status'],
      paymentId: json['paymentId'],
      paymentTransactionId: json['paymentTransactionId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
