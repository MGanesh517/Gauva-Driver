class StartRideRequest {
  final String otp;

  StartRideRequest({required this.otp});

  Map<String, dynamic> toJson() {
    return {'otp': otp};
  }
}
