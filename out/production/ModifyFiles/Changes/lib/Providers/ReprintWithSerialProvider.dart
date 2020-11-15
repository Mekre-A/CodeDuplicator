import 'package:evd_retailer/Models/NoSyncCard.dart';
import 'package:flutter/material.dart';

class ReprintWithSerialProvider extends ChangeNotifier{

  List<NoSyncCard> _noSyncCards = [];
  List<NoSyncCard> get getNoSyncCards => _noSyncCards;
  set setNoSyncCards(List<NoSyncCard> cards){
    _noSyncCards = cards;
    notifyListeners();
  }

  bool _isFetchingOrPrinting = false;
  bool get getIsFetchingOrPrinting => _isFetchingOrPrinting;
  set setIsFetchingOrPrinting(bool value){
    _isFetchingOrPrinting = value;
    notifyListeners();
  }
}