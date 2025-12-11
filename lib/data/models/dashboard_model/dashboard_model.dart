class DashboardModel {
  String? message;
  DashboardData? data;

  DashboardModel({this.message, this.data});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? DashboardData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DashboardData {
  num? wallet;
  num? todayEarning;
  num? cancelRide;
  num? completeRide;

  DashboardData({this.wallet, this.todayEarning, this.cancelRide, this.completeRide});

  DashboardData.fromJson(Map<String, dynamic> json) {
    wallet = json['wallet'];
    todayEarning = json['today_earning'];
    cancelRide = json['cancel_ride'];
    completeRide = json['complete_ride'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wallet'] = wallet;
    data['today_earning'] = todayEarning;
    data['cancel_ride'] = cancelRide;
    data['complete_ride'] = completeRide;
    return data;
  }
}
