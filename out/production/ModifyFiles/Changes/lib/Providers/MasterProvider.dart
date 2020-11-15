import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:evd_retailer/Models/LoginResponse.dart';
import 'package:evd_retailer/Models/StoredCard.dart';
import 'package:evd_retailer/Models/SyncCard.dart';
import 'package:flutter/material.dart';

class MasterProvider extends ChangeNotifier{


  bool _connectedToBluetooth = false;
  bool get getConnectedToBluetooth => _connectedToBluetooth;
  set setConnectedToBluetooth(bool status){
    _connectedToBluetooth = status;
    notifyListeners();
  }

  User _user;
  User get getUser => _user;
  set setUser(User loggedInUser){
    _user = loggedInUser;
    notifyListeners();
  }

  List<SyncCard> _listOfSyncCards = [];
  List<SyncCard> get getListOfSyncCards => _listOfSyncCards;
  set setListofSyncCards(List<SyncCard> cards){
    _listOfSyncCards = cards;
  }
  set addToListOfSyncCards(SyncCard card){
    _listOfSyncCards.add(card);
  }

  BluetoothDevice _selectedDevice;
  BluetoothDevice get getSelectedDevice => _selectedDevice;
  set setSelectedDevice(BluetoothDevice device){
    _selectedDevice = device;
    notifyListeners();
  }

  List<BluetoothDevice> _devices = [];
  List<BluetoothDevice> get getPairedDevices => _devices;
  set setPairedDevices(List<BluetoothDevice> devices){
    _devices = devices;
    notifyListeners();
  }

  bool _showOldBalance = false;
  bool get showOldBalance => _showOldBalance;
  set setShowOldBalance(bool status){
    _showOldBalance = status;
    notifyListeners();
  }



  Map<String, List<StoredCard>> _downloadedCards = {};

  Map<String, List<StoredCard>> get getDownloadedCards => _downloadedCards;

  set setDownloadCards(Map<String, List<StoredCard>> allCards){
    _downloadedCards = allCards;
    notifyListeners();
  }


  List<StoredCard> getDownloadedCardsByIdentifier(int amount){
    if(_downloadedCards.containsKey(amount.toString())){
      return _downloadedCards[amount.toString()];

    }
    else{
      return null;
    }
  }
  setDownloadedCardsByIdentifier(int amount, List<StoredCard> cards, bool replace){
    if(replace){
      _downloadedCards[amount.toString()] = cards;
    }
    else {
      List<StoredCard> oldCredit = _downloadedCards[amount.toString()];

      if (oldCredit == null) {
        _downloadedCards[amount.toString()] = cards;
      }
      else {
        cards.forEach((element) {
          oldCredit.add(element);
        });

        _downloadedCards[amount.toString()] = oldCredit;
      }
    }
    notifyListeners();

  }

  bool _downloadingCards = false;
  bool get isDownloadingCards => _downloadingCards;
  set setDownloadingCards(bool status){
    _downloadingCards = status;
    notifyListeners();
  }
  bool _refillingCards = false;
  bool get isReFillingCards => _refillingCards;
  set setReFillingCards(bool status){
    _refillingCards = status;
    notifyListeners();
  }
  bool _printingCards = false;
  bool get isPrintingCards => _printingCards;
  set setPrintingCards(bool status){
    _printingCards = status;
    notifyListeners();
  }

  bool _isLoggingIn = false;
  bool get isLoggingIn => _isLoggingIn;
  set setIsLoggingIn(bool status){
    _isLoggingIn = status;
    notifyListeners();
  }

  bool _isDownloadingOnLogin = false;
  bool get isDownloadingOnLogin => _isDownloadingOnLogin;
  set setDownloadingOnLogin(bool status){
    _isDownloadingOnLogin = status;
    notifyListeners();
  }

  String _passKey;
  String get getPassKey => _passKey;
  set setPassKey(String key){
    _passKey = key;
  }


  int get getStockBalance => _getTotalStockBalance();

  int _getTotalStockBalance(){
    int totalStockBalance = 0;
    getDownloadedCards.forEach((key, value) {
      totalStockBalance += int.parse(key) * value.length;
    });
    return totalStockBalance;
  }

  int get getStockCount => _getTotalStockCount();

  int _getTotalStockCount(){
    int totalStockCount = 0;
    getDownloadedCards.forEach((key, value) {
      totalStockCount += value.length;
    });
    return totalStockCount;
  }

  int _totalUnSyncedCards = 0;
  int get getTotalUnSyncedCards => _totalUnSyncedCards;
  set setTotalUnSyncedCards(int value){
    _totalUnSyncedCards = value;
    notifyListeners();
  }

  bool _isSyncing = false;
  bool get getIsSyncing => _isSyncing;
  set setIsSyncing(bool value){
    _isSyncing = value;
    notifyListeners();
  }
  bool _isAllSyncing = false;
  bool get getIsAllSyncing => _isAllSyncing;
  set setIsAllSyncing(bool value){
    _isAllSyncing = value;
    notifyListeners();
  }




  Future logOut()async{
    _user = null;
    _showOldBalance = false;
    _downloadedCards = {};
    _listOfSyncCards = [];
    return;

  }

}