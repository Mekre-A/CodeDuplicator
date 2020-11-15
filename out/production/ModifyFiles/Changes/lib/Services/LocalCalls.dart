import 'package:evd_retailer/Models/AgentsResponse.dart';
import 'package:evd_retailer/Models/NoSyncCard.dart';
import 'package:evd_retailer/Models/PrintBySerialResponse.dart';
import 'package:evd_retailer/Models/SyncCard.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/BluetoothPrinterConnection.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SqlDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalCalls {
  static Permission phone = Permission.phone;

  static Future<bool> rePrintCard(
      SyncCard item, MasterProvider masterProvider) async {
    SqlDatabase sqlDatabase = SqlDatabase();

    bool dataStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
    if (!dataStatus) {
      return false;
    }
    await sqlDatabase.insertIntoSyncCards([item]);
    await BluetoothPrinterConnection.rePrintCards(
            item, masterProvider.getUser.userName, item.getOrderId, true)
        .then((value) {});

    return true;
  }

  static Future<List<SyncCard>> getAllPrintedCards(
      MasterProvider masterProvider) async {
    SqlDatabase sqlDatabase = SqlDatabase();

    bool dataStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);

    if (!dataStatus) {
      return [];
    }

    return await sqlDatabase.getAllPrintedSyncCards();
  }

  static Future<bool> rePrintWithRange(List<SyncCard> toBeSelected,
      int startingRange, int endingRange, MasterProvider masterProvider) async {
    SqlDatabase sqlDatabase = SqlDatabase();
    List<SyncCard> cards = [];

    int startingIndex = toBeSelected
        .indexWhere((element) => element.getOrderId == startingRange);
    int endingIndex =
        toBeSelected.indexWhere((element) => element.getOrderId == endingRange);
    cards = toBeSelected.sublist(startingIndex, endingIndex + 1);

    bool dataStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
    if (!dataStatus) {
      return false;
    }
    await sqlDatabase.insertIntoSyncCards(cards);

    for (SyncCard item in cards) {
      await BluetoothPrinterConnection.rePrintCards(
              item,
              masterProvider.getUser.userName,
              item.getOrderId,
              item == cards.last)
          .then((value) {});
    }

    return true;
  }

  static List<SyncCard> removeDuplicate(List<SyncCard> toBeSynced) {
    List<SyncCard> categorized = [];

    toBeSynced.sort((a, b) => a.getOrderId.compareTo(b.getOrderId));

    int count = 0;
    while (count < toBeSynced.length) {
      if (count == 0) {
        categorized.add(toBeSynced[count]);
      } else {
        if (categorized.last.getOrderId != toBeSynced[count].getOrderId) {
          categorized.add(toBeSynced[count]);
        }
      }
      count += 1;
    }

    return categorized;
  }

  static Future<void> reFillCredit(
      String cardNumber, String phoneNumber, BuildContext context) async {
    if (!(await phone.isGranted)) {
      await phone.request();
      if (!(await phone.isGranted)) {
        Fluttertoast.showToast(
            msg:
                getTranslated(context, "localCalls.allowPermissionToUseMethod"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
    //await FlutterPhoneDirectCaller.callNumber("*804#");
    await FlutterPhoneDirectCaller.callNumber("*805*$cardNumber*$phoneNumber#");
  }

  static Future<bool> saveLostCardsDuringPrinting(
      List<SyncCard> cards, MasterProvider masterProvider) async {
    SqlDatabase sqlDatabase = SqlDatabase();

    bool dataStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
    if (!dataStatus) {
      return false;
    }
    return await sqlDatabase.saveLostCards(cards).then((value) {
      if (value == 1) {
        return false;
      } else {
        return true;
      }
    });
  }

  static Future<int> resetOrderId(MasterProvider masterProvider) async {
    int syncResponse = await HttpCalls.syncCardsBehindTheScenes(masterProvider);
    if (syncResponse != 200 && syncResponse != 204) return syncResponse;

    int resetResponse = await HttpCalls.resetOrderIdAtServer(masterProvider);

    if (resetResponse != 200) return resetResponse;

    SqlDatabase sqlDatabase = SqlDatabase();

    bool dataStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
    if (!dataStatus) {
      return 1;
    }

    return await sqlDatabase.resetOrderIdManually().then((value) {
      if (value) {
        return 200;
      } else {
        return 1;
      }
    });
  }

  static List<NoSyncCard> convertPrintBySerialResponseToNoSyncCard(
      PrintBySerialResponse response) {
    List<NoSyncCard> noSyncCard = [];
    response.cards.forEach((element) {
      noSyncCard.add(NoSyncCard(element.cardId, element.cardAmount,
          element.cardNumber, element.serialNumber, element.cardDate));
    });
    return noSyncCard;
  }

  static printBySerial(
      MasterProvider masterProvider, List<NoSyncCard> cards) async {
    int orderId = 0;
    for (var element in cards) {
      orderId += 1;
      await BluetoothPrinterConnection.rePrintCardsWithSerial(element, orderId,
          masterProvider.getUser.userName, element == cards.last);
    }
  }

  static List<Agent> getAgentBySearchChars(List<Agent> agents, String char){
    if(int.tryParse(char) == null){
      return agents.where((element) => element.name.toLowerCase().startsWith(char.toLowerCase())).toList();
    }
    else{
      print(char);
      return agents.where((element) => element.phone.startsWith(char)).toList();
    }
  }

  static String getAgentNameFromPhone(List<Agent> agents, String phoneNumber){
    String agentName = "";

    for(var agent in agents){
      if(agent.phone == phoneNumber){
        return agent.name;
      }
      else{
        if(agents.last == agent){
          return "";
        }
      }
    }

    return agentName;

  }

}
