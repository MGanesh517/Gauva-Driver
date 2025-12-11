/// Payment Transaction Model for /api/v1/payments/transactions endpoint
class PaymentTransactionResponse {
  PaymentTransactionResponse({
    this.content,
    this.pageable,
    this.last,
    this.totalElements,
    this.totalPages,
    this.numberOfElements,
    this.first,
    this.size,
    this.number,
    this.sort,
    this.empty,
  });

  PaymentTransactionResponse.fromJson(dynamic json) {
    if (json['content'] != null) {
      content = [];
      json['content'].forEach((v) {
        content?.add(PaymentTransaction.fromJson(v));
      });
    }
    pageable = json['pageable'] != null ? Pageable.fromJson(json['pageable']) : null;
    last = json['last'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    numberOfElements = json['numberOfElements'];
    first = json['first'];
    size = json['size'];
    number = json['number'];
    sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    empty = json['empty'];
  }

  List<PaymentTransaction>? content;
  Pageable? pageable;
  bool? last;
  int? totalElements;
  int? totalPages;
  int? numberOfElements;
  bool? first;
  int? size;
  int? number;
  Sort? sort;
  bool? empty;

  PaymentTransactionResponse copyWith({
    List<PaymentTransaction>? content,
    Pageable? pageable,
    bool? last,
    int? totalElements,
    int? totalPages,
    int? numberOfElements,
    bool? first,
    int? size,
    int? number,
    Sort? sort,
    bool? empty,
  }) => PaymentTransactionResponse(
    content: content ?? this.content,
    pageable: pageable ?? this.pageable,
    last: last ?? this.last,
    totalElements: totalElements ?? this.totalElements,
    totalPages: totalPages ?? this.totalPages,
    numberOfElements: numberOfElements ?? this.numberOfElements,
    first: first ?? this.first,
    size: size ?? this.size,
    number: number ?? this.number,
    sort: sort ?? this.sort,
    empty: empty ?? this.empty,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (content != null) {
      map['content'] = content?.map((v) => v.toJson()).toList();
    }
    if (pageable != null) {
      map['pageable'] = pageable?.toJson();
    }
    map['last'] = last;
    map['totalElements'] = totalElements;
    map['totalPages'] = totalPages;
    map['numberOfElements'] = numberOfElements;
    map['first'] = first;
    map['size'] = size;
    map['number'] = number;
    if (sort != null) {
      map['sort'] = sort?.toJson();
    }
    map['empty'] = empty;
    return map;
  }
}

class PaymentTransaction {
  PaymentTransaction({
    this.id,
    this.rideId,
    this.userId,
    this.driverId,
    this.amount,
    this.currency,
    this.provider,
    this.type,
    this.providerPaymentId,
    this.providerRefundId,
    this.providerPaymentLinkId,
    this.status,
    this.notes,
    this.createdAt,
  });

  PaymentTransaction.fromJson(dynamic json) {
    id = json['id'];
    rideId = json['rideId'];
    userId = json['userId'];
    driverId = json['driverId'];
    amount = json['amount']?.toDouble();
    currency = json['currency'];
    provider = json['provider'];
    type = json['type'];
    providerPaymentId = json['providerPaymentId'];
    providerRefundId = json['providerRefundId'];
    providerPaymentLinkId = json['providerPaymentLinkId'];
    status = json['status'];
    notes = json['notes'];
    createdAt = json['createdAt'];
  }

  int? id;
  int? rideId;
  String? userId;
  int? driverId;
  double? amount;
  String? currency;
  String? provider;
  String? type;
  String? providerPaymentId;
  String? providerRefundId;
  String? providerPaymentLinkId;
  String? status;
  String? notes;
  String? createdAt;

  PaymentTransaction copyWith({
    int? id,
    int? rideId,
    String? userId,
    int? driverId,
    double? amount,
    String? currency,
    String? provider,
    String? type,
    String? providerPaymentId,
    String? providerRefundId,
    String? providerPaymentLinkId,
    String? status,
    String? notes,
    String? createdAt,
  }) => PaymentTransaction(
    id: id ?? this.id,
    rideId: rideId ?? this.rideId,
    userId: userId ?? this.userId,
    driverId: driverId ?? this.driverId,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    provider: provider ?? this.provider,
    type: type ?? this.type,
    providerPaymentId: providerPaymentId ?? this.providerPaymentId,
    providerRefundId: providerRefundId ?? this.providerRefundId,
    providerPaymentLinkId: providerPaymentLinkId ?? this.providerPaymentLinkId,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['rideId'] = rideId;
    map['userId'] = userId;
    map['driverId'] = driverId;
    map['amount'] = amount;
    map['currency'] = currency;
    map['provider'] = provider;
    map['type'] = type;
    map['providerPaymentId'] = providerPaymentId;
    map['providerRefundId'] = providerRefundId;
    map['providerPaymentLinkId'] = providerPaymentLinkId;
    map['status'] = status;
    map['notes'] = notes;
    map['createdAt'] = createdAt;
    return map;
  }
}

class Pageable {
  Pageable({this.pageNumber, this.pageSize, this.sort, this.offset, this.paged, this.unpaged});

  Pageable.fromJson(dynamic json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    offset = json['offset'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  int? pageNumber;
  int? pageSize;
  Sort? sort;
  int? offset;
  bool? paged;
  bool? unpaged;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pageNumber'] = pageNumber;
    map['pageSize'] = pageSize;
    if (sort != null) {
      map['sort'] = sort?.toJson();
    }
    map['offset'] = offset;
    map['paged'] = paged;
    map['unpaged'] = unpaged;
    return map;
  }
}

class Sort {
  Sort({this.sorted, this.unsorted, this.empty});

  Sort.fromJson(dynamic json) {
    sorted = json['sorted'];
    unsorted = json['unsorted'];
    empty = json['empty'];
  }

  bool? sorted;
  bool? unsorted;
  bool? empty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sorted'] = sorted;
    map['unsorted'] = unsorted;
    map['empty'] = empty;
    return map;
  }
}
