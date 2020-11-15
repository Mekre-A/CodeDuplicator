

import 'package:evd_retailer/Models/OrderRangeFromOnlineResponse.dart';

class SyncCard {

  // we use groupId to identify which cards have been printed together , if the group id is -1 it means it has been refilled and doesn't belong to any group
  // we use printed to identify which cards have been printed , 0 means refilled, 1 means printed
  // we use orderId to synchronize with the server so that we know which cards have been printed at what order
  // we use confirmedFromServer to flag whether the server has accepted our sync items or not, 0 means server doesnt know, 1 means it does
  SyncCard(String serialNumber, String cardId, int cardStatus, String cardAmount, String cardNumber, String date, String phone, int orderId, int groupId, int printed, int confirmedFromServer, String confirmedDate, int source, int totalCardsInGroup, String range, {int rowId}){
    _serialNumber = serialNumber;
    _cardId = cardId;
    _cardStatus = cardStatus;
    _cardAmount = cardAmount;
    _cardDate = date;
    _phone = phone;
    _orderId = orderId;
    _groupId = groupId;
    _printed = printed;
    _confirmedFromServer = confirmedFromServer;
    _cardNumber = cardNumber;
    _confirmedDate = confirmedDate;
    _source = source;
    _totalCardsInGroup = totalCardsInGroup;
    _range = range;
    if(rowId!= null){
    _rowId = rowId;
    }

  }

  String _serialNumber;
  String get getSerialNumber => _serialNumber;

  String _cardId;
  String get getCardId => _cardId;

  int _cardStatus;
  int get getCardStatus => _cardStatus;

  String _cardAmount;
  String get getCardAmount => _cardAmount;

  String _cardNumber;
  String get getCardNumber =>_cardNumber;

  String _cardDate;
  String get getCardDate => _cardDate;

  String _phone;
  String get getPhone => _phone;

  int _orderId;
  int get getOrderId => _orderId;

  int _groupId;
  int get getGroupId => _groupId;

  int _printed;
  int get isPrinted => _printed;

  int _confirmedFromServer;
  int get getConfirmedFromServer => _confirmedFromServer;

  String _confirmedDate;
  String get getConfirmedDate =>_confirmedDate;

  int _source;
  int get getSource => _source;

  int _totalCardsInGroup;
  int get getTotalCardsInGroup => _totalCardsInGroup;

  String _range;
  String get getRange => _range;

  int _rowId;
  int get getRowId => _rowId;



  Map<String,dynamic> toJson(){
    return {
      "serial_number":getSerialNumber,
      "card_id":getCardId,
      "status":getCardStatus,
      "date":getCardDate,
      "phone":getPhone,
      "order_Id":getOrderId,
      "group_Id":getGroupId,
      "card_amount":getCardAmount,
      "source":getSource,
      "total_cards_in_group":getTotalCardsInGroup,
      "print_range":getRange
    };
  }

  factory SyncCard.fromRefillJson(Map<String,dynamic> syncCard, String phone, int orderId,int groupId,int printed, int confirmedFromServer,String confirmedDate, int source, int totalCardsInGroup){
    return SyncCard(syncCard['serial_number'],syncCard['card_id'], 4,syncCard['card_amount'],syncCard['card_number'],syncCard['card_date'],phone,orderId,groupId,printed,confirmedFromServer,confirmedDate,source,totalCardsInGroup,"");
  }

  factory SyncCard.fromDBJson(Map<String,dynamic> syncCard){
    return SyncCard(syncCard['serialNumber'],syncCard['cardId'], syncCard['cardStatus'],syncCard['cardAmount'],syncCard['cardNumber'],syncCard['cardDate'],syncCard['phone'],syncCard['orderId'],syncCard['groupId'],syncCard['printed'],syncCard['confirmedFromServer'],syncCard['confirmedDate'],syncCard['source'], syncCard['totalCardsInGroup'],syncCard['range'], rowId: syncCard['rowid']);
  }

  factory SyncCard.fromOnlineOrderRange(Datum syncCard){
    return SyncCard(syncCard.serialNumber,syncCard.cardId, 1,syncCard.cardAmount,syncCard.cardNumber,syncCard.printedCardCreatedDate.toString(),"",int.parse(syncCard.orderId),int.parse(syncCard.groupId),1,0,"",int.parse(syncCard.source), int.parse(syncCard.totalCardsInGroup),syncCard.printRange);
  }


}