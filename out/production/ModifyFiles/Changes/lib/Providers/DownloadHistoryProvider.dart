import 'package:evd_retailer/Models/DownloadHistoryResponse.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:flutter/foundation.dart';

class DownloadHistoryProvider extends ChangeNotifier{

  int _pageToBeRequested = -1;
  int get getPageToBeRequested => _pageToBeRequested;
  set setPageToBeRequested(int number){
    _pageToBeRequested = number;
  }

  List<Result> _downloadHistoryData = [];
  List<Result> get getDownloadHistoryData => _downloadHistoryData;
  set setDownloadHistoryForRefresh(List<Result> newData){
    _downloadHistoryData = newData;
  }
  set setDownloadHistoryData(List<Result> newData){
    if(newData.isEmpty){
      setPageToBeRequested = -2;
      return;
    }
    _downloadHistoryData.addAll(newData);

  }

  Future<List<Result>> getDownloadHistory(MasterProvider masterProvider, DownloadHistoryProvider downloadHistoryProvider) async{
    if(getPageToBeRequested != -2){
      setPageToBeRequested = getPageToBeRequested + 1;
      if(getPageToBeRequested != 0){
        setLoadingStatus = true;
      }
      setDownloadHistoryData = await HttpCalls.downloadHistory(masterProvider, getPageToBeRequested,downloadHistoryProvider);
      setLoadingStatus = false;

      return getDownloadHistoryData;
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