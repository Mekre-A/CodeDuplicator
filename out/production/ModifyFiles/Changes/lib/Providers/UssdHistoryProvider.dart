import 'package:evd_retailer/Models/UssdHistoryResponse.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:flutter/foundation.dart';

class UssdHistoryProvider extends ChangeNotifier{

  int _pageToBeRequested = -1;
  int get getPageToBeRequested => _pageToBeRequested;
  set setPageToBeRequested(int number){
    _pageToBeRequested = number;
  }

  List<Result> _ussdHistoryData = [];
  List<Result> get getUssdHistoryData => _ussdHistoryData;
  set setUssdHistoryForRefresh(List<Result> newData){
    _ussdHistoryData = newData;
  }
  set setUssdHistoryData(List<Result> newData){
    if(newData.isEmpty){
      setPageToBeRequested = -2;
      return;
    }
    _ussdHistoryData.addAll(newData);

  }

  Future<List<Result>> getUssdHistory(MasterProvider masterProvider, UssdHistoryProvider ussdHistoryProvider) async{
    if(getPageToBeRequested != -2){
      setPageToBeRequested = getPageToBeRequested + 1;
      if(getPageToBeRequested != 0){
        setLoadingStatus = true;
      }
      setUssdHistoryData = await HttpCalls.ussdHistory(masterProvider, getPageToBeRequested,ussdHistoryProvider);
      setLoadingStatus = false;

      return getUssdHistoryData;
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