class DriverStatusMessage {
  final int driverId;
  final bool isOnline;
  final String timestamp;

  DriverStatusMessage({required this.driverId, required this.isOnline, required this.timestamp});

  factory DriverStatusMessage.fromJson(Map<String, dynamic> json) {
    return DriverStatusMessage(
      driverId: json['driverId'] as int,
      isOnline: json['isOnline'] as bool,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'driverId': driverId, 'isOnline': isOnline, 'timestamp': timestamp};
  }
}
