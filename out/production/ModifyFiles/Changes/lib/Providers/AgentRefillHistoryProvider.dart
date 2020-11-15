
import 'package:evd_retailer/Models/AgentRefillHistoryResponse.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:flutter/foundation.dart';

class AgentRefillHistoryProvider extends ChangeNotifier{

  int _pageToBeRequested = -1;
  int get getPageToBeRequested => _pageToBeRequested;
  set setPageToBeRequested(int number){
    _pageToBeRequested = number;
  }

  List<Result> _agentRefillHistoryData = [];
  List<Result> get getAgentRefillHistoryData => _agentRefillHistoryData;
  set setAgentRefillHistoryForRefresh(List<Result> newData){
    _agentRefillHistoryData = newData;
  }
  set setAgentRefillHistoryData(List<Result> newData){
    if(newData.isEmpty){
      setPageToBeRequested = -2;
      return;
    }
    _agentRefillHistoryData.addAll(newData);

  }

  Future<List<Result>> getAgentRefillHistory(MasterProvider masterProvider, AgentRefillHistoryProvider agentRefillHistoryProvider) async{
    if(getPageToBeRequested != -2){
      setPageToBeRequested = getPageToBeRequested + 1;
      if(getPageToBeRequested != 0){
        setLoadingStatus = true;
      }
      setAgentRefillHistoryData = await HttpCalls.agentRefillHistory(masterProvider, getPageToBeRequested,agentRefillHistoryProvider);
      setLoadingStatus = false;

      return getAgentRefillHistoryData;
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