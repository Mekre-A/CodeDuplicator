import 'package:evd_retailer/Models/AgentsResponse.dart';
import 'package:flutter/material.dart';

class AgentsProvider extends ChangeNotifier{

  bool _isAddingAgent = false;
  bool get getIsAddingAgent => _isAddingAgent;
  set setIsAddingAgent(bool value){
    _isAddingAgent = value;
    notifyListeners();
  }

  bool _isFillingOTP = false;
  bool get getIsFillingOTP => _isFillingOTP;
  set setIsFillingOTP(bool value){
    _isFillingOTP = value;
    notifyListeners();
  }

  bool _isRefillingBalance = false;
  bool get getIsRefillingBalance => _isRefillingBalance;
  set setIsRefillingBalance(bool value){
    _isRefillingBalance = value;
    notifyListeners();
  }

  List<Agent> _agents = [];
  List<Agent> get getAgents => _agents;
  set setAgents(List<Agent> agents){
    _agents = agents;
    notifyListeners();
  }

  List<Agent> _searchableAgents = [];
  List<Agent> get getSearchableAgents => _searchableAgents;
  set setSearchableAgents(List<Agent> agents){
    _searchableAgents = agents;
    notifyListeners();
  }

  bool _isSearching = false;
  bool get getIsSearching => _isSearching;
  set setIsSearching(bool status){
    _isSearching = status;
    notifyListeners();
  }

  String _toBeRefilledAgentName = "";
  String get getToBeRefilledAgentName => _toBeRefilledAgentName;
  set setToBeRefilledAgentName(String name){
    _toBeRefilledAgentName = name;
    notifyListeners();
  }

  int _currentPage = 0;
  int get getCurrentPage => _currentPage;
  set setCurrentPage(int currentPage){
    _currentPage = currentPage;
    notifyListeners();
  }

  bool _isManuallyRequestingActivation = false;
  bool get getIsManuallyRequestingActivation => _isManuallyRequestingActivation;
  set setManuallyRequestingActivation(bool value){
    _isManuallyRequestingActivation = value;
    notifyListeners();
  }

}