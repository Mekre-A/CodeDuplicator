// To parse this JSON data, do
//
//     final orderRangeFromOnlineResponse = orderRangeFromOnlineResponseFromJson(jsonString);

import 'dart:convert';

OrderRangeFromOnlineResponse orderRangeFromOnlineResponseFromJson(String str) => OrderRangeFromOnlineResponse.fromJson(json.decode(str));

String orderRangeFromOnlineResponseToJson(OrderRangeFromOnlineResponse data) => json.encode(data.toJson());

class OrderRangeFromOnlineResponse {
  OrderRangeFromOnlineResponse({
    this.success,
    this.data,
    this.user,
  });

  bool success;
  List<Datum> data;
  User user;

  factory OrderRangeFromOnlineResponse.fromJson(Map<String, dynamic> json) => OrderRangeFromOnlineResponse(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "user": user.toJson(),
  };
}

class Datum {
  Datum({
    this.serialNumber,
    this.cardNumber,
    this.cardId,
    this.issuedDate,
    this.cardAmount,
    this.printId,
    this.orderNumber,
    this.printedCardCreatedDate,
    this.orderId,
    this.groupId,
    this.source,
    this.totalCardsInGroup,
    this.printRange,
  });

  String serialNumber;
  String cardNumber;
  String cardId;
  String issuedDate;
  String cardAmount;
  String printId;
  String orderNumber;
  String printedCardCreatedDate;
  String orderId;
  String groupId;
  String source;
  String totalCardsInGroup;
  String printRange;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    serialNumber: json["serial_number"],
    cardNumber: json["card_number"],
    cardId: json["card_id"],
    issuedDate: json["issued_date"],
    cardAmount: json["card_amount"],
    printId: json["print_id"],
    orderNumber: json["order_number"],
    printedCardCreatedDate: json["printed_card_created_date"],
    orderId: json["order_id"],
    groupId: json["group_id"],
    source: json["source"],
    totalCardsInGroup: json["total_cards_in_group"],
    printRange: json["print_range"],
  );

  Map<String, dynamic> toJson() => {
    "serial_number": serialNumber,
    "card_number": cardNumber,
    "card_id": cardId,
    "issued_date": issuedDate,
    "card_amount": cardAmount,
    "print_id": printId,
    "order_number": orderNumber,
    "printed_card_created_date": printedCardCreatedDate,
    "order_id": orderId,
    "group_id": groupId,
    "source": source,
    "total_cards_in_group": totalCardsInGroup,
    "print_range": printRange,
  };
}

class User {
  User({
    this.userName,
    this.maxCardAmount,
    this.currentBalance,
    this.userToken,
    this.userId,
    this.orderId,
    this.groupId,
    this.historyMaxDays,
    this.historyMaxCount,
    this.syncWarningLimit,
    this.syncMaxLimit,
    this.maxOrderId,
    this.maxGroupId,
    this.reprintLimit,
    this.offlineLimitBirr,
    this.offlineLimitCount,
    this.maxPrintCount,
    this.maxConfirmCount,
    this.printerList,
  });

  String userName;
  String maxCardAmount;
  String currentBalance;
  String userToken;
  String userId;
  String orderId;
  String groupId;
  int historyMaxDays;
  int historyMaxCount;
  int syncWarningLimit;
  int syncMaxLimit;
  int maxOrderId;
  int maxGroupId;
  int reprintLimit;
  int offlineLimitBirr;
  int offlineLimitCount;
  int maxPrintCount;
  int maxConfirmCount;
  List<String> printerList;

  factory User.fromJson(Map<String, dynamic> json) => User(
    userName: json["user_name"],
    maxCardAmount: json["max_card_amount"],
    currentBalance: json["current_balance"],
    userToken: json["user_token"],
    userId: json["user_id"],
    orderId: json["order_id"],
    groupId: json["group_id"],
    historyMaxDays: json["history_max_days"],
    historyMaxCount: json["history_max_count"],
    syncWarningLimit: json["sync_warning_limit"],
    syncMaxLimit: json["sync_max_limit"],
    maxOrderId: json["max_order_id"],
    maxGroupId: json["max_group_id"],
    reprintLimit: json["reprint_limit"],
    offlineLimitBirr: json["offline_limit_birr"],
    offlineLimitCount: json["offline_limit_count"],
    maxPrintCount: json["max_print_count"],
    maxConfirmCount: json["max_confirm_count"],
    printerList: List<String>.from(json["printer_list"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "user_name": userName,
    "max_card_amount": maxCardAmount,
    "current_balance": currentBalance,
    "user_token": userToken,
    "user_id": userId,
    "order_id": orderId,
    "group_id": groupId,
    "history_max_days": historyMaxDays,
    "history_max_count": historyMaxCount,
    "sync_warning_limit":syncWarningLimit,
    "sync_max_limit":syncMaxLimit,
    "max_order_id": maxOrderId,
    "max_group_id": maxGroupId,
    "reprint_limit": reprintLimit,
    "offline_limit_birr": offlineLimitBirr,
    "offline_limit_count": offlineLimitCount,
    "max_print_count": maxPrintCount,
    "max_confirm_count": maxConfirmCount,
    "printer_list": List<dynamic>.from(printerList.map((x) => x)),
  };
}
