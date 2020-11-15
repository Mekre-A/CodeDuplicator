import 'package:evd_retailer/Models/SyncCard.dart';
import 'package:flutter/material.dart';

class OrderRangeFromOnlineProvider extends ChangeNotifier{

  List<SyncCard> _orderRangeData = [];
  List<SyncCard> get getOrderRangeData => _orderRangeData;
  set setOrderRangeData(List<SyncCard> data ){
    _orderRangeData = data;
    notifyListeners();
  }
}