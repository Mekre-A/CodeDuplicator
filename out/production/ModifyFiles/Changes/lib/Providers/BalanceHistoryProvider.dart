
import 'package:evd_retailer/Models/BalanceHistoryResponse.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:flutter/foundation.dart';

class BalanceHistoryProvider extends ChangeNotifier{

  int _pageToBeRequested = -1;
  int get getPageToBeRequested => _pageToBeRequested;
  set setPageToBeRequested(int number){
    _pageToBeRequested = number;
  }

  List<Result> _balanceHistoryData = [];
  List<Result> get getBalanceHistoryData => _balanceHistoryData;
  set setBalanceHistoryForRefresh(List<Result> newData){
    _balanceHistoryData = newData;
  }
  set setBalanceHistoryData(List<Result> newData){
    if(newData.isEmpty){
      setPageToBeRequested = -2;
      return;
    }
    _balanceHistoryData.addAll(newData);

  }

  Future<List<Result>> getBalanceHistory(MasterProvider masterProvider, BalanceHistoryProvider balanceHistoryProvider) async{
    if(getPageToBeRequested != -2){
      setPageToBeRequested = getPageToBeRequested + 1;
      if(getPageToBeRequested != 0){
        setLoadingStatus = true;
      }
      setBalanceHistoryData = await HttpCalls.balanceHistory(masterProvider, getPageToBeRequested,balanceHistoryProvider);
      setLoadingStatus = false;

      return getBalanceHistoryData;
    }

    return [];
  }

  bool _isLoading = false;
  bool get getIsLoading => _isLoading;
  set setLoadingStatus(bool status){
    _isLoading = status;
    notifyListeners();
  }

  int _returnStatus = 200;
  int get getReturnStatus => _returnStatus;
  set setReturnStatus(int status){
    _returnStatus = status;
  }
}