import 'package:evd_retailer/Models/PrintHistoryResponse.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:flutter/foundation.dart';

class PrintHistoryProvider extends ChangeNotifier{

  int _pageToBeRequested = -1;
  int get getPageToBeRequested => _pageToBeRequested;
  set setPageToBeRequested(int number){
    _pageToBeRequested = number;
  }

  List<Result> _printHistoryData = [];
  List<Result> get getPrintHistoryData => _printHistoryData;
  set setPrintHistoryForRefresh(List<Result> newData){
    _printHistoryData = newData;
  }
  set setPrintHistoryData(List<Result> newData){
    if(newData.isEmpty){
      setPageToBeRequested = -2;
      return;
    }
    _printHistoryData.addAll(newData);

  }

  Future<List<Result>> getPrintHistory(MasterProvider masterProvider, PrintHistoryProvider printHistoryProvider) async{
    if(getPageToBeRequested != -2){
      setPageToBeRequested = getPageToBeRequested + 1;
      if(getPageToBeRequested != 0){
        setLoadingStatus = true;
      }
      setPrintHistoryData = await HttpCalls.printHistory(masterProvider, getPageToBeRequested,printHistoryProvider);
      setLoadingStatus = false;
      return getPrintHistoryData;
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