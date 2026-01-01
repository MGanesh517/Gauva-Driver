class BookingModel {
  final int? bookingId;
  final String? bookingCode;
  final String? status;
  final String? passengerName;
  final String? passengerPhone;
  final int? seatsBooked;
  final double? totalAmount;
  final String? paymentMethod;
  final String? tripCode;
  final String? pickupAddress;
  final String? dropAddress;
  final DateTime? scheduledDeparture;
  final bool? otpVerified;
  final int? passengersOnboarded;

  BookingModel({
    this.bookingId,
    this.bookingCode,
    this.status,
    this.passengerName,
    this.passengerPhone,
    this.seatsBooked,
    this.totalAmount,
    this.paymentMethod,
    this.tripCode,
    this.pickupAddress,
    this.dropAddress,
    this.scheduledDeparture,
    this.otpVerified,
    this.passengersOnboarded,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // Extract user data from nested 'user' object if available
    final user = json['user'] as Map<String, dynamic>?;

    return BookingModel(
      bookingId: json['bookingId'] ?? json['id'],
      bookingCode: json['bookingCode'],
      status: json['status'],
      passengerName: json['passengerName'] ?? user?['fullName'] ?? user?['name'],
      passengerPhone: json['passengerPhone'] ?? user?['phone'] ?? user?['mobile'],
      seatsBooked: json['seatsBooked'],
      totalAmount: json['totalAmount']?.toDouble(),
      paymentMethod: json['paymentMethod'],
      tripCode: json['tripCode'] ?? json['tripId']?.toString(), // Handle tripCode if available or fallback
      pickupAddress: json['pickupAddress'],
      dropAddress: json['dropAddress'],
      scheduledDeparture: json['scheduledDeparture'] != null ? DateTime.parse(json['scheduledDeparture']) : null,
      otpVerified: json['otpVerified'],
      passengersOnboarded: json['passengersOnboarded'],
    );
  }
}
