class TripModel {
  final int? tripId;
  final String? tripCode;
  final String? vehicleDisplayName;
  final String? vehicleType;
  final String? pickupAddress;
  final String? dropAddress;
  final String? status;
  final int? availableSeats;
  final int? totalSeats;
  final int? seatsBooked;
  final double? totalPrice;
  final double? currentPerHeadPrice;
  final DateTime? scheduledDeparture;
  final bool? isPrivate;

  TripModel({
    this.tripId,
    this.tripCode,
    this.vehicleDisplayName,
    this.vehicleType,
    this.pickupAddress,
    this.dropAddress,
    this.status,
    this.availableSeats,
    this.totalSeats,
    this.seatsBooked,
    this.totalPrice,
    this.currentPerHeadPrice,
    this.scheduledDeparture,
    this.isPrivate,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      tripId: json['tripId'] ?? json['id'],
      tripCode: json['tripCode'],
      vehicleDisplayName: json['vehicleDisplayName'],
      vehicleType: json['vehicleType'],
      pickupAddress: json['pickupAddress'],
      dropAddress: json['dropAddress'],
      status: json['status'] ?? json['tripStatus'],
      availableSeats: json['availableSeats'],
      totalSeats: json['totalSeats'],
      seatsBooked: json['seatsBooked'],
      totalPrice: (json['totalPrice'] ?? json['totalFare'])?.toDouble(),
      currentPerHeadPrice: json['currentPerHeadPrice']?.toDouble(),
      scheduledDeparture: json['scheduledDeparture'] != null ? DateTime.parse(json['scheduledDeparture']) : null,
      isPrivate: json['isPrivate'] ?? (json['bookingType'] == 'PRIVATE'),
    );
  }
}
