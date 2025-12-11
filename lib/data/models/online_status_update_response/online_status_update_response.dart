class OnlineStatusUpdateResponse {
  OnlineStatusUpdateResponse({
    this.message,
    this.data,
    this.isOnline,
    this.success,
  });

  OnlineStatusUpdateResponse.fromJson(dynamic json) {
    message = json['message'];
    isOnline = json['isOnline'];
    success = json['success'];
    
    // Handle new API format (isOnline at root level)
    if (json['isOnline'] != null) {
      // New API format: { isOnline: true/false, success: true, message: "..." }
      final status = json['isOnline'] == true ? 'online' : 'offline';
      data = Data(status: status);
    } else if (json['data'] != null) {
      // Old API format: { message: "...", data: { status: "..." } }
      data = Data.fromJson(json['data']);
    }
  }
  
  String? message;
  Data? data;
  bool? isOnline;
  bool? success;
  
  OnlineStatusUpdateResponse copyWith({
    String? message,
    Data? data,
    bool? isOnline,
    bool? success,
  }) => OnlineStatusUpdateResponse(
    message: message ?? this.message,
    data: data ?? this.data,
    isOnline: isOnline ?? this.isOnline,
    success: success ?? this.success,
  );
  
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['isOnline'] = isOnline;
    map['success'] = success;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    this.status,
  });

  Data.fromJson(dynamic json) {
    status = json['status'];
  }
  
  String? status;
  
  Data copyWith({
    String? status,
  }) => Data(
    status: status ?? this.status,
  );
  
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    return map;
  }
}