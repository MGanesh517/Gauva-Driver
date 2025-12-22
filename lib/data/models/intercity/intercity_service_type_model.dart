class IntercityServiceType {
  final int id;
  final String vehicleType;
  final String displayName;
  final double totalPrice;
  final int maxSeats;
  final int minSeats;
  final String description;
  final String targetCustomer;
  final String recommendationTag;
  final int displayOrder;
  final bool isActive;
  final String? imageUrl;
  final String createdAt;
  final String updatedAt;

  IntercityServiceType({
    required this.id,
    required this.vehicleType,
    required this.displayName,
    required this.totalPrice,
    required this.maxSeats,
    required this.minSeats,
    required this.description,
    required this.targetCustomer,
    required this.recommendationTag,
    required this.displayOrder,
    required this.isActive,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IntercityServiceType.fromJson(Map<String, dynamic> json) => IntercityServiceType(
    id: json['id'] as int,
    vehicleType: json['vehicleType'] as String,
    displayName: json['displayName'] as String,
    totalPrice: (json['totalPrice'] as num).toDouble(),
    maxSeats: json['maxSeats'] as int,
    minSeats: json['minSeats'] as int,
    description: json['description'] as String,
    targetCustomer: json['targetCustomer'] as String,
    recommendationTag: json['recommendationTag'] as String,
    displayOrder: json['displayOrder'] as int,
    isActive: json['isActive'] as bool,
    imageUrl: json['imageUrl'] as String?,
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
  );
}
