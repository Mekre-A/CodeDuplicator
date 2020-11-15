import 'package:evd_retailer/Models/TransactionHistoryResponse.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:flutter/foundation.dart';

class TransactionHistoryProvider extends ChangeNotifier{

  int _pageToBeRequested = -1;
  int get getPageToBeRequested => _pageToBeRequested;
  set setPageToBeRequested(int number){
    _pageToBeRequested = number;
  }

  List<Result> _transactionHistoryData = [];
  List<Result> get getTransactionHistoryData => _transactionHistoryData;
  set setTransactionHistoryForRefresh(List<Result> newData){
    _transactionHistoryData = newData;
  }
  set setTransactionHistoryData(List<Result> newData){
    if(newData.isEmpty){
      setPageToBeRequested = -2;
      return;
    }
    _transactionHistoryData.addAll(newData);

  }

  Future<List<Result>> getTransactionHistory(MasterProvider masterProvider, TransactionHistoryProvider transactionHistoryProvider) async{
    if(getPageToBeRequested != -2){
      setPageToBeRequested = getPageToBeRequested + 1;
      if(getPageToBeRequested != 0){
        setLoadingStatus = true;
      }
      setTransactionHistoryData = await HttpCalls.transactionHistory(masterProvider, getPageToBeRequested, transactionHistoryProvider);
      setLoadingStatus = false;

      return getTransactionHistoryData;
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