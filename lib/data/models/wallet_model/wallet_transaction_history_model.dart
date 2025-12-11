class WalletTransactionHistoryModel {
  WalletTransactionHistoryModel({this.message, this.data});

  WalletTransactionHistoryModel.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? WalletTransactionHistoryModelData.fromJson(json['data']) : null;
  }
  String? message;
  WalletTransactionHistoryModelData? data;
  WalletTransactionHistoryModel copyWith({String? message, WalletTransactionHistoryModelData? data}) =>
      WalletTransactionHistoryModel(message: message ?? this.message, data: data ?? this.data);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class WalletTransactionHistoryModelData {
  WalletTransactionHistoryModelData({this.transaction});

  WalletTransactionHistoryModelData.fromJson(dynamic json) {
    if (json['Transaction'] != null) {
      transaction = [];
      json['Transaction'].forEach((v) {
        transaction?.add(Transaction.fromJson(v));
      });
    }
  }
  List<Transaction>? transaction;
  WalletTransactionHistoryModelData copyWith({List<Transaction>? transaction}) =>
      WalletTransactionHistoryModelData(transaction: transaction ?? this.transaction);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (transaction != null) {
      map['Transaction'] = transaction?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Transaction {
  Transaction({
    this.id,
    this.orderId,
    this.rider,
    this.driverId,
    this.transaction,
    this.amount,
    this.method,
    this.paymentMode,
    this.createdAt,
    this.withdrawHistory,
    this.notes,
    this.status,
    this.type,
    this.currency,
    this.provider,
  });

  Transaction.fromJson(dynamic json) {
    id = json['id'];
    orderId = json['order_id'] ?? json['rideId'];
    rider = json['rider'] != null ? Rider.fromJson(json['rider']) : null;
    driverId = json['driver_id'] ?? json['driverId'];
    transaction = json['transaction'];
    amount = json['amount'];
    method = json['method'] ?? json['provider'];
    paymentMode = json['payment_mode'] ?? json['type'];
    createdAt = json['created_at'] ?? json['createdAt'];
    withdrawHistory = json['withdraw_history'] != null ? WithdrawHistory.fromJson(json['withdraw_history']) : null;
    notes = json['notes'];
    status = json['status'];
    type = json['type'];
    currency = json['currency'];
    provider = json['provider'];
  }
  num? id;
  num? orderId;
  Rider? rider;
  num? driverId;
  String? transaction;
  num? amount;
  String? method;
  String? paymentMode;
  String? createdAt;
  WithdrawHistory? withdrawHistory;
  String? notes;
  String? status;
  String? type;
  String? currency;
  String? provider;
  Transaction copyWith({
    num? id,
    num? orderId,
    Rider? rider,
    num? driverId,
    String? transaction,
    num? amount,
    String? method,
    String? paymentMode,
    String? createdAt,
    WithdrawHistory? withdrawHistory,
    String? notes,
    String? status,
    String? type,
    String? currency,
    String? provider,
  }) => Transaction(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    rider: rider ?? this.rider,
    driverId: driverId ?? this.driverId,
    transaction: transaction ?? this.transaction,
    amount: amount ?? this.amount,
    method: method ?? this.method,
    paymentMode: paymentMode ?? this.paymentMode,
    createdAt: createdAt ?? this.createdAt,
    withdrawHistory: withdrawHistory ?? this.withdrawHistory,
    notes: notes ?? this.notes,
    status: status ?? this.status,
    type: type ?? this.type,
    currency: currency ?? this.currency,
    provider: provider ?? this.provider,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['order_id'] = orderId;
    if (rider != null) {
      map['rider'] = rider?.toJson();
    }
    map['driver_id'] = driverId;
    map['transaction'] = transaction;
    map['amount'] = amount;
    map['method'] = method;
    map['payment_mode'] = paymentMode;
    map['created_at'] = createdAt;
    if (withdrawHistory != null) {
      map['withdraw_history'] = withdrawHistory?.toJson();
    }
    return map;
  }
}

class WithdrawHistory {
  WithdrawHistory({this.id, this.status});

  WithdrawHistory.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
  }
  num? id;
  String? status;
  WithdrawHistory copyWith({num? id, String? status}) =>
      WithdrawHistory(id: id ?? this.id, status: status ?? this.status);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    return map;
  }
}

class Rider {
  Rider({this.id, this.name, this.profilePicture});

  Rider.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    profilePicture = json['profile_picture'];
  }
  num? id;
  String? name;
  String? profilePicture;
  Rider copyWith({num? id, String? name, String? profilePicture}) =>
      Rider(id: id ?? this.id, name: name ?? this.name, profilePicture: profilePicture ?? this.profilePicture);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['profile_picture'] = profilePicture;
    return map;
  }
}
