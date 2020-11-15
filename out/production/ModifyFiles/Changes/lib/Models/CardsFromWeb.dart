// To parse this JSON data, do
//
//     final cardsFromWeb = cardsFromWebFromJson(jsonString);

import 'dart:convert';

CardsFromWeb cardsFromWebFromJson(String str) => CardsFromWeb.fromJson(json.decode(str));

String cardsFromWebToJson(CardsFromWeb data) => json.encode(data.toJson());

class CardsFromWeb {
  CardsFromWeb({
    this.cards,
    this.totalAmount,
    this.user,
    this.totalDownloadCount,
    this.success,
  });

  List<Card> cards;
  int totalAmount;
  User user;
  String totalDownloadCount;
  bool success;

  factory CardsFromWeb.fromJson(Map<String, dynamic> json) => CardsFromWeb(
    cards: List<Card>.from(json["cards"].map((x) => Card.fromJson(x))),
    totalAmount: json["total_amount"],
    user: User.fromJson(json["user"]),
    totalDownloadCount: json["total_download_count"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
    "total_amount": totalAmount,
    "user": user.toJson(),
    "total_download_count": totalDownloadCount,
    "success": success,
  };
}

class Card {
  Card({
    this.issuedDate,
    this.cardId,
    this.cardAmount,
    this.cardStatus,
    this.serialNumber,
    this.cardNumber,
  });

  DateTime issuedDate;
  String cardId;
  String cardAmount;
  String cardStatus;
  String serialNumber;
  String cardNumber;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
    issuedDate: DateTime.parse(json["issued_date"]),
    cardId: json["card_id"],
    cardAmount: json["card_amount"],
    cardStatus: json["card_status"],
    serialNumber: json["serial_number"],
    cardNumber: json["card_number"],
  );

  Map<String, dynamic> toJson() => {
    "issued_date": issuedDate.toIso8601String(),
    "card_id": cardId,
    "card_amount": cardAmount,
    "card_status": cardStatus,
    "serial_number": serialNumber,
    "card_number": cardNumber,
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
