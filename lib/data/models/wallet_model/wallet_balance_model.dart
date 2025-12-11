class WalletBalanceModel {
  WalletBalanceModel({
      this.message, 
      this.data,});

  WalletBalanceModel.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  Data? data;
WalletBalanceModel copyWith({  String? message,
  Data? data,
}) => WalletBalanceModel(  message: message ?? this.message,
  data: data ?? this.data,
);
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
  Data({
    this.wallet,
    this.paymentWithdraw,
    this.paymentHistory,});

  Data.fromJson(dynamic json) {
    wallet = json['wallet'];
    paymentWithdraw = json['payment_withdraw'];
    paymentHistory = json['payment_history'];
  }
  num? wallet;
  num? paymentWithdraw;
  num? paymentHistory;
  Data copyWith({  num? wallet,
    num? paymentWithdraw,
    num? paymentHistory,
  }) => Data(  wallet: wallet ?? this.wallet,
    paymentWithdraw: paymentWithdraw ?? this.paymentWithdraw,
    paymentHistory: paymentHistory ?? this.paymentHistory,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['wallet'] = wallet;
    map['payment_withdraw'] = paymentWithdraw;
    map['payment_history'] = paymentHistory;
    return map;
  }

}