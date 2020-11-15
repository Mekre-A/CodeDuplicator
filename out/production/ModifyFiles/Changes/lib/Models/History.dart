// To parse this JSON data, do
//
//     final history = historyFromJson(jsonString);

import 'dart:convert';

History historyFromJson(String str) => History.fromJson(json.decode(str));

String historyToJson(History data) => json.encode(data.toJson());

class History {
  History({
    this.success,
    this.data,
    this.page,
    this.card,
    this.user,
  });

  bool success;
  Data data;
  int page;
  Card card;
  User user;

  factory History.fromJson(Map<String, dynamic> json) => History(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    page: json["page"],
    card: Card.fromJson(json["card"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "page": page,
    "card": card.toJson(),
    "user": user.toJson(),
  };
}

class Card {
  Card({
    this.info,
    this.weekHistory,
    this.todayHistory,
  });

  List<Info> info;
  WeekHistory weekHistory;
  TodayHistory todayHistory;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
    info: List<Info>.from(json["info"].map((x) => Info.fromJson(x))),
    weekHistory: WeekHistory.fromJson(json["week_history"]),
    todayHistory: TodayHistory.fromJson(json["today_history"]),
  );

  Map<String, dynamic> toJson() => {
    "info": List<dynamic>.from(info.map((x) => x.toJson())),
    "week_history": weekHistory.toJson(),
    "today_history": todayHistory.toJson(),
  };
}

class Info {
  Info({
    this.birrWeek,
    this.totalWeek,
    this.amountWeek,
    this.birrToday,
    this.totalToday,
    this.cardAmount,
  });

  String birrWeek;
  String totalWeek;
  String amountWeek;
  String birrToday;
  String totalToday;
  String cardAmount;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    birrWeek: json["birr_week"],
    totalWeek: json["total_week"],
    amountWeek: json["amount_week"],
    birrToday: json["birr_today"],
    totalToday: json["total_today"],
    cardAmount: json["card_amount"],
  );

  Map<String, dynamic> toJson() => {
    "birr_week": birrWeek,
    "total_week": totalWeek,
    "amount_week": amountWeek,
    "birr_today": birrToday,
    "total_today": totalToday,
    "card_amount": cardAmount,
  };
}

class TodayHistory {
  TodayHistory({
    this.birrToday,
  });

  String birrToday;

  factory TodayHistory.fromJson(Map<String, dynamic> json) => TodayHistory(
    birrToday: json["birr_today"],
  );

  Map<String, dynamic> toJson() => {
    "birr_today": birrToday,
  };
}

class WeekHistory {
  WeekHistory({
    this.birrWeek,
  });

  String birrWeek;

  factory WeekHistory.fromJson(Map<String, dynamic> json) => WeekHistory(
    birrWeek: json["birr_week"],
  );

  Map<String, dynamic> toJson() => {
    "birr_week": birrWeek,
  };
}

class Data {
  Data({
    this.results,
    this.notPrinted,
    this.refilled,
    this.config,
  });

  List<Refilled> results;
  List<Refilled> notPrinted;
  List<Refilled> refilled;
  Config config;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    results: List<Refilled>.from(json["results"].map((x) => Refilled.fromJson(x))),
    notPrinted: List<Refilled>.from(json["not_printed"].map((x) => Refilled.fromJson(x))),
    refilled: List<Refilled>.from(json["refilled"].map((x) => Refilled.fromJson(x))),
    config: Config.fromJson(json["config"]),
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "not_printed": List<dynamic>.from(notPrinted.map((x) => x.toJson())),
    "refilled": List<dynamic>.from(refilled.map((x) => x.toJson())),
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

class Refilled {
  Refilled({
    this.cardSerialNumber,
    this.cardCardNumber,
    this.userCardStatus,
    this.userCardDownloaded,
    this.cardId,
    this.cardIssuedDate,
    this.cardAmount,
    this.userCardPhone,
    this.userCardBatchNumber,
    this.orderId,
    this.userCardCount,
  });

  String cardSerialNumber;
  String cardCardNumber;
  String userCardStatus;
  String userCardDownloaded;
  String cardId;
  DateTime cardIssuedDate;
  String cardAmount;
  String userCardPhone;
  String userCardBatchNumber;
  String orderId;
  String userCardCount;

  factory Refilled.fromJson(Map<String, dynamic> json) => Refilled(
    cardSerialNumber: json["card_serial_number"],
    cardCardNumber: json['card_card_number'],
    userCardStatus: json["user_card_status"],
    userCardDownloaded: json["user_card_downloaded"],
    cardId: json["card_id"],
    cardIssuedDate: DateTime.parse(json["card_issued_date"]),
    cardAmount: json["card_amount"],
    userCardPhone: json["user_card_phone"] == null ? null : json["user_card_phone"],
    userCardBatchNumber: json["user_card_batch_number"],
    orderId: json["order_id"] == null ? null : json["order_id"],
    userCardCount: json["user_card_count"],
  );

  Map<String, dynamic> toJson() => {
    "card_serial_number": cardSerialNumber,
    "card_card_number":cardCardNumber,
    "user_card_status": userCardStatus,
    "user_card_downloaded": userCardDownloaded,
    "card_id": cardId,
    "card_issued_date": cardIssuedDate.toIso8601String(),
    "card_amount": cardAmount,
    "user_card_phone": userCardPhone == null ? null : userCardPhone,
    "user_card_batch_number": userCardBatchNumber,
    "order_id": orderId == null ? null : orderId,
    "user_card_count": userCardCount,
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
