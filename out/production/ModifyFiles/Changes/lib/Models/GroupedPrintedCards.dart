import 'package:evd_retailer/Models/SyncCard.dart';

class GroupedPrintedCards {



  GroupedPrintedCards(List<SyncCard> cards, String printedDate, String orderRange, String cardAmount){
    _cards = cards;
    _printedDate = printedDate;
    _orderRange = orderRange;
    _cardAmount = cardAmount;
  }

  List<SyncCard> _cards = [];
  List<SyncCard> get getCards => _cards;
  set addToCard(SyncCard card){
    _cards.add(card);
  }

  String _printedDate;
  String get getPrintedDate => _printedDate;

  String _orderRange;
  String get getOrderRange => _orderRange;

  String _cardAmount;
  String get getCardAmount => _cardAmount;

}