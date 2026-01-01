import '../user_model/user_model.dart';

class DriverDetailsResponse {
  DriverDetailsResponse({this.message, this.data});

  DriverDetailsResponse.fromJson(dynamic json) {
    message = json['message'];

    // Handle new API format (flat structure) or old format (nested data.user)
    if (json['id'] != null) {
      // New API format: flat structure with driver profile (no message field)
      // Wrap it in the expected data.user structure for backward compatibility
      data = Data.fromNewApiFormat(json);
      message = message ?? 'Profile retrieved successfully';
    } else {
      // Old API format: nested structure
      data = json['data'] != null ? Data.fromJson(json['data']) : null;
    }
  }

  String? message;
  Data? data;

  DriverDetailsResponse copyWith({String? message, Data? data}) =>
      DriverDetailsResponse(message: message ?? this.message, data: data ?? this.data);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({this.user, this.token});

  Data.fromJson(dynamic json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  // Factory constructor for new API format (flat structure)
  factory Data.fromNewApiFormat(dynamic json) {
    // Map the new flat structure to User model
    final license = json['license'] as Map<String, dynamic>?;
    final vehicle = json['vehicle'] as Map<String, dynamic>?;

    final userJson = <String, dynamic>{
      'id': json['id'],
      'name': json['name'],
      'email': json['email'],
      'mobile': json['mobile'],
      'rating': json['rating'],
      'latitude': json['latitude'],
      'longitude': json['longitude'],
      'licence': license?['licenseNumber'],
      'vehicle_color': vehicle?['color'],
      'vehicle_plate': vehicle?['licensePlate'],
      'vehicle_regi_year': vehicle?['year'],
      'profile_picture': null, // Not in new API response
      'driver_status': json['role'],
      // Map bank details if needed
      'account_holder_name': json['accountHolderName'],
      'bank_name': json['bankName'],
      'account_number': json['accountNumber'],
      'ifsc_code': json['ifscCode'],
      'upi_id': json['upiId'],
      'service_type': vehicle?['serviceType'] ?? vehicle?['vehicleType'],
      'subscriptionActive': json['subscriptionActive'],
      'subscriptionType': json['subscriptionType'],
    };

    return Data(
      user: User.fromJson(userJson),
      token: null, // New API doesn't return token
    );
  }

  User? user;
  String? token;

  Data copyWith({User? user, String? token}) => Data(user: user ?? this.user, token: token ?? this.token);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['token'] = token;
    return map;
  }
}
