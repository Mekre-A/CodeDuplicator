import 'package:flutter/material.dart';

class StoredCard{

  StoredCard({
    @required String cardDate,
    @required String cardId,
    @required String cardAmount,
    @required int cardStatus,
    @required String serialNumber,
    @required String cardNumber,
    @required int confirmationStatus,
    @required int rowId
  }): _cardDate = cardDate,
      _cardId = cardId,
      _cardAmount = cardAmount,
      _cardStatus = cardStatus,
      _serialNumber = serialNumber,
      _cardNumber = cardNumber,
      _confirmationStatus = confirmationStatus,
      _rowId = rowId;

  String _cardDate;
  String get getCardDate => _cardDate;

  String _cardId;
  String get getCardId => _cardId;

  String _cardAmount;
  String get getCardAmount => _cardAmount;

  int _cardStatus;
  int get getCardStatus => _cardStatus;

  String _serialNumber;
  String get getSerialNumber => _serialNumber;

  String _cardNumber;
  String get getCardNumber => _cardNumber;

  int _confirmationStatus;
  int get getConfirmationStatus => _confirmationStatus;

  int _rowId;
  int get getRowId => _rowId;

  factory StoredCard.fromJson(Map<String,dynamic> cardsMap){
    return StoredCard(cardDate: cardsMap['cardDate'],cardId: cardsMap['cardId'],cardAmount: cardsMap['cardAmount'], cardStatus: cardsMap['cardStatus'],serialNumber: cardsMap['serialNumber'],cardNumber: cardsMap['cardNumber'], confirmationStatus: cardsMap['confirmationStatus'], rowId: cardsMap['rowid']);
  }
}