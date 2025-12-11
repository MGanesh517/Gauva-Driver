class ReportTypeResponse {
  ReportTypeResponse({
    this.success,
    this.message,
    this.data,});

  ReportTypeResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? success;
  String? message;
  Data? data;
  ReportTypeResponse copyWith({  bool? success,
    String? message,
    Data? data,
  }) => ReportTypeResponse(  success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
    this.reportTypes,});

  Data.fromJson(dynamic json) {
    if (json['types'] != null) {
      reportTypes = [];
      json['types'].forEach((v) {
        reportTypes?.add(ReportTypes.fromJson(v));
      });
    }
  }
  List<ReportTypes>? reportTypes;
  Data copyWith({  List<ReportTypes>? reportTypes,
  }) => Data(  reportTypes: reportTypes ?? this.reportTypes,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (reportTypes != null) {
      map['types'] = reportTypes?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class ReportTypes {
  ReportTypes({
    this.id,
    this.reportType,
    this.createdAt,
    this.updatedAt,});

  ReportTypes.fromJson(dynamic json) {
    id = json['id'];
    reportType = json['report_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? reportType;
  String? createdAt;
  String? updatedAt;
  ReportTypes copyWith({  num? id,
    String? reportType,
    String? createdAt,
    String? updatedAt,
  }) => ReportTypes(  id: id ?? this.id,
    reportType: reportType ?? this.reportType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['report_type'] = reportType;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}