class NoSyncCard {

  NoSyncCard(String cardId, String cardAmount, String cardNumber, String serialNumber, DateTime cardDate){
    setCardId = cardId;
    setCardAmount = cardAmount;
    setCardNumber = cardNumber;
    setSerialNumber = serialNumber;
    setCardDate = cardDate;
  }


  String _cardId;

  String get getCardId => _cardId;

  set setCardId(String value) {
    _cardId = value;
  }

  String _cardAmount;
  String get getCardAmount => _cardAmount;

  set setCardAmount(String value) {
    _cardAmount = value;
  }

  String _cardNumber;
  String get getCardNumber => _cardNumber;

  set setCardNumber(String value) {
    _cardNumber = value;
  }

  String _serialNumber;
  String get getSerialNumber => _serialNumber;

  set setSerialNumber(String value) {
    _serialNumber = value;
  }

  DateTime _cardDate;
  DateTime get getCardDate => _cardDate;

  set setCardDate(DateTime value) {
    _cardDate = value;
  }
}
