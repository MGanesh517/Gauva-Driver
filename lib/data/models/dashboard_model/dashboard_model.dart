import '../order_response/order_model/order/order.dart';

class DashboardModel {
  String? driverStatus;
  DashboardWallet? wallet;
  List<Order>? rides;

  DashboardModel({this.driverStatus, this.wallet, this.rides});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    driverStatus = json['driverStatus'];
    wallet = json['wallet'] != null ? DashboardWallet.fromJson(json['wallet']) : null;
    if (json['rides'] != null) {
      rides = [];
      json['rides'].forEach((v) {
        rides!.add(Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driverStatus'] = driverStatus;
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    if (this.rides != null) {
      data['rides'] = rides!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DashboardWallet {
  num? balance;
  num? todaysEarnings;
  num? cancelRide;
  num? rideComplete;

  DashboardWallet({this.balance, this.todaysEarnings, this.cancelRide, this.rideComplete});

  DashboardWallet.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    todaysEarnings = json['today\'s Earnings']; // Handling special key with space/quote
    if (todaysEarnings == null) {
      // Fallback for standard naming if backend changes mind
      todaysEarnings = json['todayEarnings'] ?? json['todaysEarnings'];
    }
    cancelRide = json['cance_ride'];
    rideComplete = json['ride_complete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    data['today\'s Earnings'] = todaysEarnings;
    data['cance_ride'] = cancelRide;
    data['ride_complete'] = rideComplete;
    return data;
  }
}
