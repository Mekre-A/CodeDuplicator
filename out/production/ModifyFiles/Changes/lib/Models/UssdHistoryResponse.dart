// To parse this JSON data, do
//
//     final ussdHistoryResponse = ussdHistoryResponseFromJson(jsonString);

import 'dart:convert';

UssdHistoryResponse ussdHistoryResponseFromJson(String str) => UssdHistoryResponse.fromJson(json.decode(str));

String ussdHistoryResponseToJson(UssdHistoryResponse data) => json.encode(data.toJson());

class UssdHistoryResponse {
  UssdHistoryResponse({
    this.success,
    this.data,
    this.page,
    this.user,
  });

  bool success;
  Data data;
  int page;
  User user;

  factory UssdHistoryResponse.fromJson(Map<String, dynamic> json) => UssdHistoryResponse(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    page: json["page"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "page": page,
    "user": user.toJson(),
  };
}

class Data {
  Data({
    this.results,
    this.config,
  });

  List<Result> results;
  Config config;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    config: Config.fromJson(json["config"]),
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "config": config.toJson(),
  };
}

class Config {
  Config({
    this.baseUrl,
    this.totalRows,
    this.currentPage,
    this.perPage,
    this.lastPage,
  });

  String baseUrl;
  int totalRows;
  int currentPage;
  int perPage;
  int lastPage;

  factory Config.fromJson(Map<String, dynamic> json) => Config(
    baseUrl: json["base_url"],
    totalRows: json["total_rows"],
    currentPage: json["current_page"],
    perPage: json["per_page"],
    lastPage: json["last_page"],
  );

  Map<String, dynamic> toJson() => {
    "base_url": baseUrl,
    "total_rows": totalRows,
    "current_page": currentPage,
    "per_page": perPage,
    "last_page": lastPage,
  };
}

class Result {
  Result({
    this.cardId,
    this.phone,
    this.date,
    this.cardNumber,
    this.serialNumber,
    this.cardAmount
  });

  String cardId;
  String phone;
  DateTime date;
  String cardNumber;
  String serialNumber;
  String cardAmount;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    cardId: json["card_id"],
    phone: json["phone"] == null ? null : json["phone"],
    date: DateTime.parse(json["date"]),
    cardNumber: json["card_number"],
    serialNumber: json["serial_number"],
    cardAmount: json["card_amount"]
  );

  Map<String, dynamic> toJson() => {
    "card_id": cardId,
    "phone": phone == null ? null : phone,
    "date": date.toIso8601String(),
    "card_number": cardNumber,
    "serial_number": serialNumber,
    "card_amount":cardAmount
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
