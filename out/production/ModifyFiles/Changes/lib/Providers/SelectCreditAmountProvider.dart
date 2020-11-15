import 'package:flutter/material.dart';

class SelectCreditAmountProvider extends ChangeNotifier{

  bool _isDataConfirmationInProgress = false;
  bool get getDataConfirmationInProgress => _isDataConfirmationInProgress;
  set setDataConfirmationInProgress(bool status){
    _isDataConfirmationInProgress = status;
    notifyListeners();
  }
}