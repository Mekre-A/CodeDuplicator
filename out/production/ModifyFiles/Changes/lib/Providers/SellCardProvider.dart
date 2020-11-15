
import 'package:flutter/material.dart';

class SellCardProvider extends ChangeNotifier{

  int _batchAmount = 1;
  int get getBatchAmount  => _batchAmount;
  set setBatchAmount(int amount){
    _batchAmount = amount;
    notifyListeners();
  }

  int _downloadAmount = 1;
  int get getDownloadAmount  => _downloadAmount;
  set setDownloadAmount(int amount){
    _downloadAmount = amount;
    notifyListeners();
  }



}