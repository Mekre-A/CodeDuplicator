// To parse this JSON data, do
//
//     final agentsResponse = agentsResponseFromJson(jsonString);

import 'dart:convert';

AgentsResponse agentsResponseFromJson(String str) => AgentsResponse.fromJson(json.decode(str));

String agentsResponseToJson(AgentsResponse data) => json.encode(data.toJson());

class AgentsResponse {
  AgentsResponse({
    this.success,
    this.agents,
    this.user,
  });

  bool success;
  List<Agent> agents;
  User user;

  factory AgentsResponse.fromJson(Map<String, dynamic> json) => AgentsResponse(
    success: json["success"],
    agents: List<Agent>.from(json["agents"].map((x) => Agent.fromJson(x))),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "agents": List<dynamic>.from(agents.map((x) => x.toJson())),
    "user": user.toJson(),
  };
}

class Agent {
  Agent({
    this.name,
    this.date,
    this.status,
    this.phone,
    this.currentBalance,
  });

  String name;
  DateTime date;
  String status;
  String phone;
  String currentBalance;

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
    name: json["name"],
    date: DateTime.parse(json["date"]),
    status: json["status"],
    phone: json["phone"],
    currentBalance: json["current_balance"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "date": date.toIso8601String(),
    "status": status,
    "phone": phone,
    "current_balance": currentBalance,
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
    this.maxOrderId,
    this.maxGroupId,
    this.syncWarningLimit,
    this.syncMaxLimit,
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
  int maxOrderId;
  int maxGroupId;
  int syncWarningLimit;
  int syncMaxLimit;
  int reprintLimit;
  int offlineLimitBirr;
  int offlineLimitCount;
  int maxPrintCount;
  int maxConfirmCount;
  List<dynamic> printerList;

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
    maxOrderId: json["max_order_id"],
    maxGroupId: json["max_group_id"],
    syncWarningLimit: json["sync_warning_limit"],
    syncMaxLimit: json["sync_max_limit"],
    reprintLimit: json["reprint_limit"],
    offlineLimitBirr: json["offline_limit_birr"],
    offlineLimitCount: json["offline_limit_count"],
    maxPrintCount: json["max_print_count"],
    maxConfirmCount: json["max_confirm_count"],
    printerList: List<dynamic>.from(json["printer_list"].map((x) => x)),
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
    "max_order_id": maxOrderId,
    "max_group_id": maxGroupId,
    "sync_warning_limit": syncWarningLimit,
    "sync_max_limit": syncMaxLimit,
    "reprint_limit": reprintLimit,
    "offline_limit_birr": offlineLimitBirr,
    "offline_limit_count": offlineLimitCount,
    "max_print_count": maxPrintCount,
    "max_confirm_count": maxConfirmCount,
    "printer_list": List<dynamic>.from(printerList.map((x) => x)),
  };
}
