class HistoryCards{

  HistoryCards(String cardSerialNumber, String cardNumber, String userCardStatus, String userCardDownloaded, String cardId, DateTime cardIssuedDate, String cardAmount, String userCardPhone, String userCardBatchNumber, String orderId, String userCardCount){
    _cardSerialNumber = cardSerialNumber;
    _cardNumber = cardNumber;
    _userCardStatus = userCardStatus;
    _userCardDownloaded = userCardDownloaded;
    _cardId = cardId;
    _cardIssuedDate = cardIssuedDate;
    _cardAmount = cardAmount;
    _userCardPhone = userCardPhone;
    _userCardBatchNumber = userCardBatchNumber;
    _orderId = orderId;
    _userCardCount = userCardCount;

  }

  String _cardSerialNumber;
  String get getCardSerialNumber => _cardSerialNumber;

  String _cardNumber;
  String get getCardNumber => _cardNumber;

  String _userCardStatus;
  String get getUserCardStatus => _userCardStatus;

  String _userCardDownloaded;
  String get getUserCardDownloaded => _userCardDownloaded;

  String _cardId;
  String get getCardId => _cardId;

  DateTime _cardIssuedDate;
  DateTime get getCardIssuedDate => _cardIssuedDate;

  String _cardAmount;
  String get getCardAmount => _cardAmount;

  String _userCardPhone;
  String get getUserCardPhone => _userCardPhone;

  String _userCardBatchNumber;
  String get getUserCardBatchNumber => _userCardBatchNumber;

  String _orderId;
  String get getOrderId => _orderId;

  String _userCardCount;
  String get getUserCardCount => _userCardCount;
}