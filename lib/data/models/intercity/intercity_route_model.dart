class IntercityRouteModel {
  final int? id;
  final String? originName;
  final String? destinationName;
  final String? routeCode;
  final double? distanceKm;
  final int? durationMinutes;
  final bool? isActive;
  final bool? bidirectional;
  final double? priceMultiplier;

  IntercityRouteModel({
    this.id,
    this.originName,
    this.destinationName,
    this.routeCode,
    this.distanceKm,
    this.durationMinutes,
    this.isActive,
    this.bidirectional,
    this.priceMultiplier,
  });

  factory IntercityRouteModel.fromJson(Map<String, dynamic> json) {
    return IntercityRouteModel(
      id: json['id'],
      originName: json['originName'],
      destinationName: json['destinationName'],
      routeCode: json['routeCode'],
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      durationMinutes: json['durationMinutes'],
      isActive: json['isActive'],
      bidirectional: json['bidirectional'],
      priceMultiplier: (json['priceMultiplier'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originName': originName,
      'destinationName': destinationName,
      'routeCode': routeCode,
      'distanceKm': distanceKm,
      'durationMinutes': durationMinutes,
      'isActive': isActive,
      'bidirectional': bidirectional,
      'priceMultiplier': priceMultiplier,
    };
  }
}
