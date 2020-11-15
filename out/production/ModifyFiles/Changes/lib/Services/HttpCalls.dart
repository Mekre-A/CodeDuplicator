import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:evd_retailer/Models/AgentRefillHistoryResponse.dart' as agh;
import 'package:evd_retailer/Models/AgentsResponse.dart';
import 'package:evd_retailer/Models/BalanceHistoryResponse.dart' as blh;
import 'package:evd_retailer/Models/CardsFromWeb.dart' as cw;
import 'package:evd_retailer/Models/DownloadHistoryResponse.dart' as dwh;
import 'package:evd_retailer/Models/DownloadedCards.dart' as dc;
import 'package:evd_retailer/Models/GroupedPrintedCards.dart';
import 'package:evd_retailer/Models/LoginResponse.dart' as lg;
import 'package:evd_retailer/Models/OrderRangeFromOnlineResponse.dart';
import 'package:evd_retailer/Models/PrintBySerialResponse.dart';
import 'package:evd_retailer/Models/PrintHistoryResponse.dart' as pth;
import 'package:evd_retailer/Models/PrintedCards.dart';
import 'package:evd_retailer/Models/ReportResponse.dart';
import 'package:evd_retailer/Models/StoredCard.dart';
import 'package:evd_retailer/Models/SyncCard.dart';
import 'package:evd_retailer/Models/TransactionHistoryResponse.dart' as tsh;
import 'package:evd_retailer/Models/UssdHistoryResponse.dart' as ush;
import 'package:evd_retailer/Providers/AgentRefillHistoryProvider.dart';
import 'package:evd_retailer/Providers/AgentsProvider.dart';
import 'package:evd_retailer/Providers/BalanceHistoryProvider.dart';
import 'package:evd_retailer/Providers/DownloadHistoryProvider.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/OrderRangeFromOnlineProvider.dart';
import 'package:evd_retailer/Providers/PrintHistoryProvider.dart';
import 'package:evd_retailer/Providers/ReportProvider.dart';
import 'package:evd_retailer/Providers/ReprintWithSerialProvider.dart';
import 'package:evd_retailer/Providers/TransactionHistoryProvider.dart';
import 'package:evd_retailer/Providers/UssdHistoryProvider.dart';
import 'package:evd_retailer/Services/BluetoothPrinterConnection.dart';
import 'package:evd_retailer/Services/LocalCalls.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:evd_retailer/Services/SqlDatabase.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class HttpCalls {
  static const Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };
  static Permission phone = Permission.phone;

  static Map<String, String> constants = {
    "baseUrl": "",
    "key": "",
    "downloaded_cards": "downloaded_cards",
    "downloaded_stock": "downloaded_stock",
    "login_url": '/login',
    "get_balance_url": '/get_balance',
    "buy_card_url": '/buy_card',
    "batch_cards_url": '/print_cards',
    "card_print_confirmed_url": '/card_print_confirmed',
    "confirm_batch_print_url": '/confirm_batch_print',
    "card_with_sms_url": '/buy_card_with_sms',
    "refill_card_url": '/refill_card',
    "get_card_detail_url": '/get_card_detail',
    "sync_download_cards_url": '/sync_download_cards',
    "download_cards_url": '/download_cards',
    "get_downloaded_cards_url": '/get_downloaded_cards',
    "history_url": '/card_sales_history',
    "report_card_url": '/report_card',
    "send_sms_again_url": '/resend_card_sms',
    "change_password_url": '/change_password',
    "get_otp_url": '/get_otp',
    "confirm_db_entry": '/download_confirmation',
    "print_history": "/print_history",
    "download_history": "/download_history",
    "transaction_history": "/transaction_history",
    "balance_history": "/balance_refill_history",
    "ussd_history": "/ussd_history",
    "print_card_detail": "/print_card_detail",
    "sold_cards_report": "/sold_cards_report",
    "print_card_by_serial": "/print_card_by_serial",
    "get_agents":"/get_agents",
    "activate_agent":"/activate_agent",
    "register_agent":"/register_agent",
    "refill_balance":"/refill_balance",
    "agent_refill_history":"/refill_history",
    "agent_resend_otp":"/resend_otp",
    "version": "3.6.2"
  };

  static Future<int> getBaseUrlAndKey(MasterProvider masterProvider) async {
    return await http
        .post("http://196.189.90.89/api_list/Api_list_v01/get_api_endpoint",
            headers: requestHeaders,
            body: jsonEncode({
              "key":
                  "a434db7b06eb10b8adf1009d0396b334db7b06eb10b8b06edd13a4ad334d334dbdb7b06eb10b",
              "api_reference": "test_003"
            }))
        .then((value) async {

      if (value.statusCode == 200) {
        Map<String, String> urlAndKey = {
          "baseUrl": jsonDecode(value.body)["endpoint"],
          "apiKey": jsonDecode(value.body)["api_key"]
        };

        await SharedPref.saveBaseUrlAndApiKey(jsonEncode(urlAndKey));
        constants["baseUrl"] = urlAndKey["baseUrl"];
        constants["key"] = urlAndKey["apiKey"];
      } else {
        masterProvider.setIsLoggingIn = false;
      }
      return value.statusCode;
    }).catchError((onError) {
      print(onError);
      masterProvider.setIsLoggingIn = false;
      return -1;
    });
  }

  static Future<int> login(
      String phone, String password, MasterProvider masterProvider) async {
    return await http
        .post(constants["baseUrl"] + constants["login_url"],
            headers: requestHeaders,
            body: jsonEncode({
              "key": constants["key"],
              "phone": phone,
              "password": password,
              "app_version": constants["version"]
            }))
        .then((value) async {

      if (value.statusCode == 200) {
        lg.LoginResponse response = lg.loginResponseFromJson(value.body);
        masterProvider.setUser = response.user;
        SqlDatabase sqlDatabase = SqlDatabase();

        bool dbStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
        if (!dbStatus) {
          return 1;
        }
        await sqlDatabase.updatePassKey("$password");
        masterProvider.setPassKey = await sqlDatabase.getPassKey();
        masterProvider.setDownloadingOnLogin = true;

        if (await sqlDatabase.doesSyncTableHaveContent()) {
          int status = await syncCardsBeforeLogin(masterProvider, masterProvider.getUser.maxConfirmCount);
          if (status != 200 && status != 204) {
            return status;
          }
          masterProvider.getUser.orderId =
              (await sqlDatabase.getOrderId()).toString();
          masterProvider.getUser.groupId =
              (await sqlDatabase.getGroupId()).toString();
        } else {
          bool updateStatus = await sqlDatabase.updateGroupAndOrderId(
              int.parse(masterProvider.getUser.groupId),
              int.parse(masterProvider.getUser.orderId));
          if (!updateStatus) return 1;
        }

        masterProvider.setDownloadCards = await sqlDatabase.getAllConfirmedData();
        await SharedPref.storeUserObject(jsonEncode(response.user.toJson()));
      }
      return value.statusCode;
    }).catchError((onError) {
      print(onError);
      return -1;
    });
  }

  static Future<int> getOtp(String phoneNumber) async {
    return await http
        .post(constants["baseUrl"] + constants["get_otp_url"],
            headers: requestHeaders,
            body: jsonEncode({"key": constants["key"], "phone": phoneNumber}))
        .then((value) {
      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

  static Future<int> changePassword(
      String otp, String phoneNumber, String newPassword) async {
    return await http
        .post(
      constants["baseUrl"] + constants["change_password_url"],
      headers: requestHeaders,
      body: jsonEncode({
        "key": constants["key"],
        "phone": phoneNumber,
        "password": newPassword,
        "otp": otp
      }),
    )
        .then((value) {
      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

  static Future<int> updateBalance(MasterProvider masterProvider) async {
    return await http
        .post(constants["baseUrl"] + constants["get_balance_url"],
            headers: requestHeaders,
            body: jsonEncode({
              "key": constants["key"],
              "user_token": masterProvider.getUser.userToken
            }))
        .then((value) async {
      if (value.statusCode == 200) {
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));
      }
      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

  static Future<int> downloadCards(
      int count, int cardAmount, MasterProvider masterProvider) async {
    SqlDatabase sqlDatabase = SqlDatabase();
    bool dbStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
    if (!dbStatus) return 1;

    DateTime requestTime = DateTime.now();
    print("Request time for new cards $requestTime");

    return await http
        .post(constants["baseUrl"] + constants["download_cards_url"],
            headers: requestHeaders,
            body: jsonEncode({
              "key": constants["key"],
              "user_token": masterProvider.getUser.userToken,
              "card_amount": cardAmount.toString(),
              "count": count,
              "gps": null
            }))
        .then((value) async {
      DateTime receivedTime = DateTime.now();
      print("Received time for new cards $receivedTime");
      print("Difference when request ${receivedTime.difference(requestTime)}");
      if (value.statusCode == 200) {
        dc.DownloadedCards cards = dc.downloadedCardsFromJson(value.body);

        List<StoredCard> newCards = cards.cards.map((e) {
          return dcCardToStoredCardConverter(e);
        }).toList();

        DateTime startTime = DateTime.now();
        print("Inserting new cards into db start time $startTime");
        await sqlDatabase.insertIntoCards(newCards);
        DateTime endTime = DateTime.now();
        print("Finishing inserting new cards db end time $endTime");
        print("Difference ${endTime.difference(startTime)}");

        return await confirmAnyFound(masterProvider);
      }

      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

  static Future<int> refillWithNumber(
      String phoneNumber, MasterProvider masterProvider, int cardAmount) async {
    SqlDatabase sqlDatabase = SqlDatabase();

    bool dataStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
    if (!dataStatus) {
      return 1;
    }

    if (!(await phone.isGranted)) {
      await phone.request();
      if (!(await phone.isGranted)) {
        return 3;
      }
    }

    if (masterProvider.getDownloadedCardsByIdentifier(cardAmount) != null) {
      if (masterProvider.getDownloadedCardsByIdentifier(cardAmount).isNotEmpty) {
        String cardNumber = masterProvider.getDownloadedCardsByIdentifier(cardAmount)[0].getCardNumber;

        //prepare a new list of cards for the cardamount
        List<StoredCard> newList = [];
        masterProvider
            .getDownloadedCardsByIdentifier(cardAmount)
            .forEach((element) {
          newList.add(element);
        });

        StoredCard toBeSynced = newList[0];
        int orderId = await sqlDatabase.getOrderId();
        if (orderId > masterProvider.getUser.maxOrderId) {
          orderId = 0;
        }
        orderId += 1;

        masterProvider.addToListOfSyncCards = cardToSyncCardConverter(
            toBeSynced, phoneNumber, 4, orderId, -1, 0, 0, 1, "");

        bool valueStatus = await updateDb(
            cardAmount,
            masterProvider.getUser.userId,
            masterProvider.getListOfSyncCards,
            -1,
            orderId,
            masterProvider,
            false,
          toBeSynced.getRowId,
          toBeSynced.getRowId
        );
        masterProvider.setListofSyncCards = [];
        if (!valueStatus) {
          return 1;
        }
        newList.removeAt(0);
        //add the map back to masterprovider
        masterProvider.setDownloadedCardsByIdentifier(
            cardAmount, newList, true);

        //await FlutterPhoneDirectCaller.callNumber("*804#");
        await FlutterPhoneDirectCaller.callNumber(
            "*805*$cardNumber*$phoneNumber#");

        return 200;
      }
    }
    //  Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return await http
        .post(constants["baseUrl"] + constants["refill_card_url"],
            headers: requestHeaders,
            body: jsonEncode({
              "key": constants["key"],
              "user_token": masterProvider.getUser.userToken,
              "card_amount": cardAmount.toString(),
              "to_number": phoneNumber,
              "gps": null
            }))
        .then((value) async {
      if (value.statusCode == 200) {
        int orderId = await sqlDatabase.getOrderId();
        if (orderId > masterProvider.getUser.maxOrderId) {
          orderId = 0;
        }
        orderId += 1;
        SyncCard card = SyncCard.fromRefillJson(jsonDecode(value.body)["card"],
            phoneNumber, orderId, -1, 0, 0, "", 1, 1);

        masterProvider.addToListOfSyncCards = card;

        bool valueStatus = await updateDb(
            cardAmount,
            masterProvider.getUser.userId,
            masterProvider.getListOfSyncCards,
            -1,
            orderId,
            masterProvider,
          true,
          null,
          null
        );
        masterProvider.setListofSyncCards = [];
        if (!valueStatus) {
          return 1;
        }
        await FlutterPhoneDirectCaller.callNumber(
            "*805*${card.getCardNumber}*$phoneNumber#");

        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));
      }
      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

  static Future<bool> updateDb(
      int cardAmount,
      String userId,
      List<SyncCard> accessedCards,
      int groupId,
      int orderId,
      MasterProvider masterProvider,
      bool fromOnline,
      int firstRowId,
      int lastRowId
      ) async {
    SqlDatabase sqlDatabase = SqlDatabase();
    bool dataStatus = await sqlDatabase.openDB(userId);
    if (!dataStatus) {
      return false;
    }
    if(!fromOnline){
      return await sqlDatabase
          .updateDb(cardAmount, accessedCards, groupId, orderId, firstRowId, lastRowId)
          .then((value) async {
        if (value) {
          masterProvider.setTotalUnSyncedCards =
          await sqlDatabase.getTotalNumberOfUnSyncedCards();
        }
        return value;
      }).catchError((onError) {
        print(onError);
        return false;
      });
    }
    else{
      return await sqlDatabase
          .updateDbFromOnline(cardAmount, accessedCards, groupId, orderId)
          .then((value) async {
        if (value) {
          masterProvider.setTotalUnSyncedCards =
          await sqlDatabase.getTotalNumberOfUnSyncedCards();
        }
        return value;
      }).catchError((onError) {
        print(onError);
        return false;
      });
    }

  }

  static Future<int> getBatchDownloads(
      int cardAmount, MasterProvider masterProvider, int count) async {
    SqlDatabase sqlDatabase = SqlDatabase();
    bool dataStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
    if (!dataStatus) {
      return 1;
    }

    if (masterProvider.getDownloadedCardsByIdentifier(cardAmount) != null) {
      if (masterProvider
          .getDownloadedCardsByIdentifier(cardAmount)
          .isNotEmpty) {
        if (masterProvider.getDownloadedCardsByIdentifier(cardAmount).length >=
            count) {
          List<StoredCard> toBeExtracted =
              masterProvider.getDownloadedCardsByIdentifier(cardAmount);
          List<StoredCard> toBePrinted = [];
          int x = 0;
          while (x < count) {
            toBePrinted.add(toBeExtracted[x]);
            x += 1;
          }


          int orderId = await sqlDatabase.getOrderId();
          if (orderId > masterProvider.getUser.maxOrderId) {
            orderId = 0;
          }
          int orderIdForSyncLoop = await sqlDatabase.getOrderId();
          if (orderIdForSyncLoop > masterProvider.getUser.maxOrderId) {
            orderIdForSyncLoop = 0;
          }
          int groupId = await sqlDatabase.getGroupId();
          if (groupId > masterProvider.getUser.maxGroupId) {
            groupId = 0;
          }
          groupId += 1;
          String date = DateTime.now().toString();
          for (var element in toBePrinted) {
            orderIdForSyncLoop += 1;
            masterProvider.addToListOfSyncCards = SyncCard(
                element.getSerialNumber,
                element.getCardId,
                1,
                element.getCardAmount,
                element.getCardNumber,
                date,
                "",
                orderIdForSyncLoop,
                groupId,
                1,
                0,
                "",
                0,
                toBePrinted.length,
                "${orderId + 1} - ${orderId + toBePrinted.length}");
          }
          DateTime startDateTime = DateTime.now();
          print("Inserting into DB $startDateTime");
          
          bool valueStatus = await updateDb(
              cardAmount,
              masterProvider.getUser.userId,
              masterProvider.getListOfSyncCards,
              groupId,
              orderId + toBePrinted.length,
              masterProvider,
            false,
            toBePrinted.first.getRowId,
            toBePrinted.last.getRowId
          );
          DateTime endDateTime = DateTime.now();
          print("Finishing insertion into DB $endDateTime");
          print("The difference between insertion and deletion is ${endDateTime.difference(startDateTime)}");
          masterProvider.setListofSyncCards = [];
          if (!valueStatus) {
            return 1;
          }
          x = 0;
          while (x < count) {
            toBeExtracted.removeAt(0);
            x += 1;
          }
          masterProvider.setDownloadedCardsByIdentifier(
              cardAmount, toBeExtracted, true);

          for (var element in toBePrinted) {
            orderId += 1;
            await BluetoothPrinterConnection.printPurchasedTicketsFromStock(
                    element,
                    cardAmount,
                    masterProvider.getUser.userName,
                    orderId,
                    element == toBePrinted.last)
                .then((value) {});
          }
          await syncCards(masterProvider);

          return 200;
        }
      }
    }

    DateTime requestingServerTime = DateTime.now();
    print("Requesting from server $requestingServerTime");
    return await http
        .post(constants["baseUrl"] + constants["batch_cards_url"],
            headers: requestHeaders,
            body: jsonEncode({
              "key": constants["key"],
              "card_amount": cardAmount,
              "count": count,
              "user_token": masterProvider.getUser.userToken,
              "gps": null
            }))
        .then((value) async {
      DateTime receivedServerTime = DateTime.now();
      print("Received from server $receivedServerTime");
      print("This is the difference from requesting and receiving ${receivedServerTime.difference(requestingServerTime)}");

      if (value.statusCode == 200) {
        PrintedCards cards = printedCardsFromJson(value.body);
        int orderId = await sqlDatabase.getOrderId();
        if (orderId > masterProvider.getUser.maxOrderId) {
          orderId = 0;
        }
        int orderIdForSyncLoop = await sqlDatabase.getOrderId();
        if (orderIdForSyncLoop > masterProvider.getUser.maxOrderId) {
          orderIdForSyncLoop = 0;
        }
        int groupId = await sqlDatabase.getGroupId();
        if (groupId > masterProvider.getUser.maxGroupId) {
          groupId = 0;
        }
        groupId += 1;
        String date = DateTime.now().toString();

        for (var element in cards.cards) {
          orderIdForSyncLoop += 1;
          masterProvider.addToListOfSyncCards = SyncCard(
              element.serialNumber,
              element.cardId,
              1,
              element.cardAmount,
              element.cardNumber,
              date,
              "",
              orderIdForSyncLoop,
              groupId,
              1,
              0,
              "",
              1,
              cards.cards.length,
              "${orderId + 1} - ${orderId + cards.cards.length}");
        }


        DateTime dbInsertTime = DateTime.now();
        print("Starting inserting into db time $dbInsertTime");
        bool valueStatus = await updateDb(
            cardAmount,
            masterProvider.getUser.userId,
            masterProvider.getListOfSyncCards,
            groupId,
            orderId + cards.cards.length,
            masterProvider,
          true,
          null,
          null
        );
        masterProvider.setListofSyncCards = [];
        DateTime dbFinishedInsertTime = DateTime.now();
        print("This is the difference between start time and end time when entering in DB  ${dbFinishedInsertTime.difference(dbInsertTime)}");
        print("Finishing inserting into db time $dbFinishedInsertTime");
        if (!valueStatus) {
          return 1; // couldn't save the operation to db, print cards from the Print History
        }
        for (var element in cards.cards) {
          orderId += 1;
          await BluetoothPrinterConnection.printPurchasedTicketsFromOnline(
                  element,
                  cardAmount,
                  masterProvider.getUser.userName,
                  orderId,
                  element == cards.cards.last)
              .then((value) {});
        }

        await syncCards(masterProvider);

        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));
      }
      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

  static Future<void> syncCards(MasterProvider masterProvider,
      {Position tempPosition}) async {
    if (ConnectivityResult.none == await Connectivity().checkConnectivity()) {
      return;
    }
    List<SyncCard> cardsToBeSynced = [];
    SqlDatabase sqlDatabase = SqlDatabase();

    await sqlDatabase.openDB(masterProvider.getUser.userId).then((value) async {
      if (value) {
        await sqlDatabase
            .getUnconfirmedSyncCards(masterProvider.getUser.maxConfirmCount)
            .then((value) {
          cardsToBeSynced = value;
        }).catchError((onError) {
          print(onError);
          print("trying to add into the db");
          return;
        });
        if (cardsToBeSynced.isEmpty) return;
      } else {
        return;
      }
    }).catchError((onError) {
      print("tring to open db");
      return;
    });


    if (cardsToBeSynced.isNotEmpty) {
      int orderId = await sqlDatabase.getOrderId();
      int groupId = await sqlDatabase.getGroupId();
      DateTime dateTime = DateTime.now();
      print("Requesting from server during mini sync $dateTime");
      return await http
          .post(
        constants["baseUrl"] + constants["sync_download_cards_url"],
        headers: requestHeaders,
        body: jsonEncode({
          "user_token": masterProvider.getUser.userToken,
          "key": constants["key"],
          "cards": cardsToBeSynced.map((e) => e.toJson()).toList(),
          "gps": null,
          "order_Id": orderId,
          "group_Id": groupId
        }),
      )
          .then((value) async {
        DateTime responsedateTime = DateTime.now();
        print("Response from server during mini sync $responsedateTime");
        print("Difference from received and request time from server, ${responsedateTime.difference(dateTime)}");
        print(value.body);
        print(value.statusCode);
        if (value.statusCode == 200) {
          String date = DateTime.now().toString();
          DateTime startingUpdateSyncTime = DateTime.now();
          print("Update sync item starting time $startingUpdateSyncTime");
          await sqlDatabase.updateConfirmationOfLimitedSyncItem(
              cardsToBeSynced, date, cardsToBeSynced.length, cardsToBeSynced.first.getRowId,cardsToBeSynced.last.getRowId);
          DateTime endingUpdateSyncTime = DateTime.now();
          print("Update sync item ending time $endingUpdateSyncTime");
          print("Difference from received and request time from server, ${endingUpdateSyncTime.difference(startingUpdateSyncTime)}");

          masterProvider.setTotalUnSyncedCards =
              await sqlDatabase.getTotalNumberOfUnSyncedCards();
        }
      }).catchError((onError) {
        print(onError);
        print("error Happened here");
        return;
      });
    }
  }

  static Future<int> syncCardsBeforeLogin(
      MasterProvider masterProvider, int count) async {
    if (ConnectivityResult.none == await Connectivity().checkConnectivity()) {
      return -1;
    }
    SqlDatabase sqlDatabase = SqlDatabase();

    bool dataStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
    if (!dataStatus) {
      return 1;
    }
    List<SyncCard> dataToSync;
    await sqlDatabase.getUnconfirmedSyncCards(count).then((value) {
      dataToSync = value;
    }).catchError((onError) {
      return 1;
    });
    if (dataToSync.isEmpty) return 204;

    // Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    int orderId = await sqlDatabase.getOrderId();
    int groupId = await sqlDatabase.getGroupId();

    print(jsonEncode({
      "user_token": masterProvider.getUser.userToken,
      "key": constants["key"],
      "cards": dataToSync.map((e) => e.toJson()).toList(),
      "gps": null,
      "order_Id": orderId,
      "group_Id": groupId
    }));
    return await http
        .post(
      constants["baseUrl"] + constants["sync_download_cards_url"],
      headers: requestHeaders,
      body: jsonEncode({
        "user_token": masterProvider.getUser.userToken,
        "key": constants["key"],
        "cards": dataToSync.map((e) => e.toJson()).toList(),
        "gps": null,
        "order_Id": orderId,
        "group_Id": groupId
      }),
    )
        .then((value) async {
          print(value.body);
          print(value.statusCode);
      if (value.statusCode == 200) {
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)['user']);
        String date = DateTime.now().toString();
        await sqlDatabase.updateConfirmationOfSyncItem(
            dataToSync, date, dataToSync.length);
      }
      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

  static Future<int> syncCardsBehindTheScenes(
      MasterProvider masterProvider) async {
    if (ConnectivityResult.none == await Connectivity().checkConnectivity()) {
      return -1;
    }

    SqlDatabase sqlDatabase = SqlDatabase();

    bool dataStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
    if (!dataStatus) {
      return 1;
    }
    List<SyncCard> dataToSync;
    await sqlDatabase.getUnconfirmedSyncCards(-1).then((value) {
      dataToSync = value;
    }).catchError((onError) {
      return 1;
    });

    if (dataToSync.isEmpty) return 204;

    int orderId = await sqlDatabase.getOrderId();
    int groupId = await sqlDatabase.getGroupId();

    print("Sending unSynced cards");

    DateTime sendingUnSync  = DateTime.now();
    print("$sendingUnSync Request time");



    // Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return await http
        .post(
      constants["baseUrl"] + constants["sync_download_cards_url"],
      headers: requestHeaders,
      body: jsonEncode({
        "user_token": masterProvider.getUser.userToken,
        "key": constants["key"],
        "cards": dataToSync.map((e) => e.toJson()).toList(),
        "gps": null,
        "order_Id": orderId,
        "group_Id": groupId
      }),
    )
        .then((value) async {
          print("Got a response");
          DateTime receivedFromServer  = DateTime.now();
          print("The difference when request and receiving from the server is ${receivedFromServer.difference(sendingUnSync)}");

          print("$receivedFromServer Received time");
          print(value.body);
          print(value.statusCode);
      if (value.statusCode == 200) {
        String date = DateTime.now().toString();
        print("Entering new data to SQL");
        DateTime dbInsertStartTime  = DateTime.now();
        print("$dbInsertStartTime This is the time when update of sync item is started in db");
        await sqlDatabase.updateConfirmationOfSyncItem(
            dataToSync, date, dataToSync.length);
        print("Finished entering data to SQL");
        DateTime dbInsertFinishTime  = DateTime.now();
        print("$dbInsertFinishTime This is the time when update of sync item is complete in db");
        print("The difference of updating sync items is ${dbInsertFinishTime.difference(dbInsertStartTime)}");
        masterProvider.setTotalUnSyncedCards =
            await sqlDatabase.getTotalNumberOfUnSyncedCards();
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)['user']);
      }
      return value.statusCode;
    }).catchError((onError) {
      print("Error while syncing all");
      return -1;
    });
  }

  static Future<int> resetOrderIdAtServer(MasterProvider masterProvider) async {
    if (ConnectivityResult.none == await Connectivity().checkConnectivity()) {
      return -1;
    }

    SqlDatabase sqlDatabase = SqlDatabase();

    bool dataStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
    if (!dataStatus) {
      return 1;
    }

    int groupId = await sqlDatabase.getGroupId();

    // Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return await http
        .post(
      constants["baseUrl"] + constants["sync_download_cards_url"],
      headers: requestHeaders,
      body: jsonEncode({
        "user_token": masterProvider.getUser.userToken,
        "key": constants["key"],
        "cards": [],
        "gps": null,
        "order_Id": 0,
        "group_Id": groupId
      }),
    )
        .then((value) async {
      if (value.statusCode == 200) {
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)['user']);
      }
      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

  static SyncCard cardToSyncCardConverter(
      StoredCard card,
      String phoneNumber,
      int status,
      int orderId,
      int groupId,
      int printed,
      int source,
      int totalCardsInGroup,
      String range) {
    return SyncCard(
        card.getSerialNumber,
        card.getCardId,
        status,
        card.getCardAmount,
        card.getCardNumber,
        DateTime.now().toString(),
        phoneNumber,
        orderId,
        groupId,
        printed,
        0,
        "",
        source,
        totalCardsInGroup,
        range);
  }

  static StoredCard dcCardToStoredCardConverter(dc.Card card) {
    return StoredCard(
        cardAmount: card.cardAmount,
        cardDate: card.issuedDate.toString(),
        cardId: card.cardId,
        cardNumber: card.cardNumber,
        cardStatus: card.cardStatus,
        serialNumber: card.serialNumber,
        confirmationStatus: 0,
        rowId: null
    );
  }

  static Future<int> getDownloadedCardsFromWeb(
      MasterProvider masterProvider, int status) async {
    // status 0 means get all the cards from web
    // status 1 means get only the unconfirmed cards from web
    // status 2 means get only the confirmed cards but no use case has appeared till now

    SqlDatabase sqlDatabase = SqlDatabase();
    bool dbStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
    if (!dbStatus) return 1;

    DateTime startTime = DateTime.now();

    print("getting cards from server $startTime");
    return await http
        .post(constants["baseUrl"] + constants['get_downloaded_cards_url'],
            headers: requestHeaders,
            body: jsonEncode({
              'status': status,
              'user_token': masterProvider.getUser.userToken,
              'key': constants["key"],
              'gps': null
            }))
        .then((value) async {
      DateTime endTime = DateTime.now();

      print("Received cards from server $endTime");
      print("The difference is ${endTime.difference(startTime)}");
      if (value.statusCode == 200) {
        cw.CardsFromWeb cardFromWeb = cw.cardsFromWebFromJson(value.body);
        List<StoredCard> toBeCategorized = cardFromWeb.cards
            .map((e) => cardsFromWebToStoredCardConverter(e))
            .toList();

        if (status == 0) {
          bool deleteStatus = await sqlDatabase.clearStoredCards();
          if (!deleteStatus) return 1;
        }
        else{
          int confirmStatus = await confirmAnyFound(masterProvider);
          if(confirmStatus != 200 && confirmStatus != 204){
            return confirmStatus;
          }
        }

        DateTime insertTime = DateTime.now();

        print("Inserting cards $insertTime");

        await sqlDatabase.insertIntoCards(toBeCategorized);

        DateTime insertEndTime = DateTime.now();

        print("Done inserting time $insertEndTime");
        print("The difference is ${insertEndTime.difference(insertTime)}");

        return await confirmAnyFound(masterProvider);
      }
      else if(value.statusCode == 204){
        if (status == 0) {
          bool deleteStatus = await sqlDatabase.clearStoredCards();
          if (!deleteStatus) return 1;
        }
        return await confirmAnyFound(masterProvider);
      }
      return value.statusCode;
    }).catchError((onError) {
      print(onError);
      return -1;
    });
  }

  static Future<int> confirmData(List<String> data,
      MasterProvider masterProvider,List<String> affectedTables) async {
    SqlDatabase sqlDatabase = SqlDatabase();
    bool dataStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
    if (!dataStatus) {
      return 1;
    }

    int orderId = await sqlDatabase.getOrderId();
    int groupId = await sqlDatabase.getGroupId();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    String deviceInformation =
        androidInfo.manufacturer + " " + androidInfo.product;
    // Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    DateTime requestTime = DateTime.now();
    print("Request time for confirming cards $requestTime");

    return await http
        .post(constants["baseUrl"] + constants['confirm_db_entry'],
            headers: requestHeaders,
            body: jsonEncode({
              'cards': data,
              'device_info': deviceInformation,
              'user_token': masterProvider.getUser.userToken,
              'key': constants["key"],
              'gps': null,
              'order_Id': orderId,
              "group_Id": groupId
            }))
        .then((value) async {
      DateTime responseTime = DateTime.now();
      print("Response time for confirming cards $responseTime");
      print("Difference when request ${responseTime.difference(requestTime)}");
      if (value.statusCode == 200) {
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));
        DateTime startTime = DateTime.now();
        print("Start time for updating confirmed cards $startTime");
        await sqlDatabase.updateConfirmationOfStoredItem(affectedTables);

        DateTime endTime = DateTime.now();
        print("end time for updating confirmed cards $endTime");
        print("Difference when updating confirmed cards in DB ${endTime.difference(startTime)}");
        masterProvider.setDownloadCards =
            await sqlDatabase.getAllConfirmedData();
      }
      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

  static Future<int> confirmAnyFound(MasterProvider masterProvider) async {
    SqlDatabase sqlDatabase = SqlDatabase();

    bool dataStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
    if (!dataStatus) {
      return 1;
    }

    Map<String,dynamic> unConfirmedStructure = await sqlDatabase.syncUnconfirmedData();

    List<StoredCard> unConfirmedData = unConfirmedStructure["unConfirmed"];
    List<String> affectedTables = unConfirmedStructure["affectedTables"];

    if (unConfirmedData.isNotEmpty) {
      return await confirmData(unConfirmedData.map((e) => e.getCardId).toList(),
          masterProvider,affectedTables);
    }
    else{
      masterProvider.setDownloadCards = await sqlDatabase.getAllConfirmedData();
    }
    return 200;
  }

  static StoredCard cardsFromWebToStoredCardConverter(cw.Card card) {
    return StoredCard(
        cardAmount: card.cardAmount,
        cardDate: card.issuedDate.toString(),
        cardId: card.cardId,
        cardNumber: card.cardNumber,
        cardStatus: int.parse(card.cardStatus),
        serialNumber: card.serialNumber,
        confirmationStatus: 0,
        rowId: null);
  }

  static Future<List<GroupedPrintedCards>> getGroupedPrintedCards(
      MasterProvider masterProvider) async {
    SqlDatabase sqlDatabase = SqlDatabase();
    bool dataStatus = await sqlDatabase.openDB(masterProvider.getUser.userId);
    if (!dataStatus) {
      return [];
    }

    List<SyncCard> toBeSynced = await sqlDatabase.getAllPrintedSyncCards();

    return categorizeToBeSyncedCards(toBeSynced).reversed.toList();
  }

  static List<GroupedPrintedCards> categorizeToBeSyncedCards(
      List<SyncCard> toBeSynced) {
    List<GroupedPrintedCards> categorized = [];

    toBeSynced.sort((a, b) => a.getOrderId.compareTo(b.getOrderId));
    int count = 0;
    List<SyncCard> syncCards = [];
    while (count < toBeSynced.length) {
      if (count == 0) {
        syncCards.add(toBeSynced[count]);
        if (toBeSynced.length == 1) {
          categorized.add(GroupedPrintedCards(
              syncCards,
              syncCards.first.getCardDate,
              "${syncCards.first.getOrderId} - ${syncCards.last.getOrderId}",
              syncCards.first.getCardAmount));
        }
      } else {
        if (syncCards.first.getGroupId != toBeSynced[count].getGroupId) {
          categorized.add(GroupedPrintedCards(
              syncCards,
              syncCards.first.getCardDate,
              "${syncCards.first.getOrderId} - ${syncCards.last.getOrderId}",
              syncCards.first.getCardAmount));
          syncCards = [];
          syncCards.add(toBeSynced[count]);
        } else {
          // By doing this we remove any duplicates which might happen when items are printed again, as they are added to the db
          if (syncCards.last.getOrderId != toBeSynced[count].getOrderId) {
            syncCards.add(toBeSynced[count]);
          }
        }
        if (count + 1 == toBeSynced.length) {
          categorized.add(GroupedPrintedCards(
              syncCards,
              syncCards.first.getCardDate,
              "${syncCards.first.getOrderId} - ${syncCards.last.getOrderId}",
              syncCards.first.getCardAmount));
        }
      }
      count += 1;
    }

    return categorized;
  }

  static Future<List<pth.Result>> printHistory(
      MasterProvider masterProvider, int pageNumber, PrintHistoryProvider printHistoryProvider) async {
    if(!masterProvider.getIsSyncing && !masterProvider.getIsAllSyncing){
      masterProvider.setIsAllSyncing = true;
      await syncCardsBehindTheScenes(masterProvider);
      masterProvider.setIsAllSyncing = false;
    }
    return await http
        .post(constants["baseUrl"] + constants['print_history'],
            headers: requestHeaders,
            body: jsonEncode({
              "key": constants['key'],
              "user_token": masterProvider.getUser.userToken,
              "page": pageNumber
            }))
        .then((value) async {
          printHistoryProvider.setReturnStatus = value.statusCode;
      if (value.statusCode == 200) {
        pth.PrintHistoryResponse printHistoryResponse =
            pth.printHistoryResponseFromJson(value.body);
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));

        return printHistoryResponse.data.results;
      } else {
        return [];
      }
    }).catchError((onError) {
      return [];
    });
  }

  static Future<int> getOrderRangeFromOnline(
      MasterProvider masterProvider,
      int groupId,
      OrderRangeFromOnlineProvider orderRangeFromOnlineProvider) async {
    print("group id $groupId");
    return await http
        .post(constants['baseUrl'] + constants['print_card_detail'],
            headers: requestHeaders,
            body: jsonEncode({
              "key": constants["key"],
              "user_token": masterProvider.getUser.userToken,
              "group_id": groupId
            }))
        .then((value) async {
      if (value.statusCode == 200) {
        OrderRangeFromOnlineResponse or =
            orderRangeFromOnlineResponseFromJson(value.body);
        orderRangeFromOnlineProvider.setOrderRangeData =
            or.data.map((e) => SyncCard.fromOnlineOrderRange(e)).toList();
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));
      }
      return value.statusCode;
    }).catchError((onError) {
      print(onError);
      return -1;
    });
  }

  static Future<List<dwh.Result>> downloadHistory(
      MasterProvider masterProvider, int pageNumber, DownloadHistoryProvider downloadHistoryProvider) async {

    return await http
        .post(constants["baseUrl"] + constants['download_history'],
            headers: requestHeaders,
            body: jsonEncode({
              "key": constants['key'],
              "user_token": masterProvider.getUser.userToken,
              "page": pageNumber
            }))
        .then((value) async {
          downloadHistoryProvider.setReturnStatus = value.statusCode;
      if (value.statusCode == 200) {
        dwh.DownloadHistoryResponse downloadHistoryResponse =
            dwh.downloadHistoryResponseFromJson(value.body);
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));
        return downloadHistoryResponse.data.results;
      } else {
        return [];
      }
    }).catchError((onError) {
      return [];
    });
  }

  static Future<List<tsh.Result>> transactionHistory(
      MasterProvider masterProvider, int pageNumber, TransactionHistoryProvider transactionHistoryProvider) async {

    return await http
        .post(constants["baseUrl"] + constants['transaction_history'],
            headers: requestHeaders,
            body: jsonEncode({
              "key": constants['key'],
              "user_token": masterProvider.getUser.userToken,
              "page": pageNumber
            }))
        .then((value) async {
          transactionHistoryProvider.setReturnStatus = value.statusCode;
      if (value.statusCode == 200) {
        tsh.TransactionHistoryResponse transactionHistoryResponse =
            tsh.transactionHistoryResponseFromJson(value.body);
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));

        return transactionHistoryResponse.data.results;
      } else {
        return [];
      }
    }).catchError((onError) {
      return [];
    });
  }

  static Future<List<ush.Result>> ussdHistory(
      MasterProvider masterProvider, int pageNumber, UssdHistoryProvider ussdHistoryProvider) async {

    return await http
        .post(constants["baseUrl"] + constants['ussd_history'],
            headers: requestHeaders,
            body: jsonEncode({
              "key": constants['key'],
              "user_token": masterProvider.getUser.userToken,
              "page": pageNumber
            }))
        .then((value) async {
          ussdHistoryProvider.setReturnStatus = value.statusCode;
      if (value.statusCode == 200) {
        ush.UssdHistoryResponse ussdHistoryResponse =
            ush.ussdHistoryResponseFromJson(value.body);
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));
        return ussdHistoryResponse.data.results;
      } else {
        return [];
      }
    }).catchError((onError) {
      return [];
    });
  }

  static Future<List<blh.Result>> balanceHistory(
      MasterProvider masterProvider, int pageNumber, BalanceHistoryProvider balanceHistoryProvider) async {

    return await http
        .post(constants["baseUrl"] + constants['balance_history'],
            headers: requestHeaders,
            body: jsonEncode({
              "key": constants['key'],
              "user_token": masterProvider.getUser.userToken,
              "page": pageNumber
            }))
        .then((value) async {
          balanceHistoryProvider.setReturnStatus = value.statusCode;
      if (value.statusCode == 200) {
        blh.BalanceHistoryResponse balanceHistoryResponse =
            blh.balanceHistoryResponseFromJson(value.body);
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));
        return balanceHistoryResponse.data.results;
      }
      return [];
    }).catchError((onError) {
      return [];
    });
  }


  static Future<int> getReport(ReportProvider reportProvider,
      MasterProvider masterProvider, String startDate, String endDate) async {
    return await http
        .post(constants["baseUrl"] + constants['sold_cards_report'],
            headers: requestHeaders,
            body: jsonEncode({
              "key": constants['key'],
              "user_token": masterProvider.getUser.userToken,
              "from": startDate,
              "to": endDate
            }))
        .then((value) async {
      if (value.statusCode == 200) {
        ReportResponse response = reportResponseFromJson(value.body);
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));
        reportProvider.setResponse = response.data;
        reportProvider.addTotalRow(response.data);
      }
      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

  static Future<int> getCardsBySerial(
      MasterProvider masterProvider,ReprintWithSerialProvider provider, String starting, String ending) async {
    return await http
        .post(constants["baseUrl"] + constants['print_card_by_serial'],
            headers: requestHeaders,
            body: jsonEncode({
              "key": constants['key'],
              "user_token": masterProvider.getUser.userToken,
              "from_serial": starting,
              "to_serial": ending
            }))
        .then((value) async{
          if(value.statusCode == 200){
          PrintBySerialResponse printBySerialResponse = printBySerialResponseFromJson(value.body);
          provider.setNoSyncCards = LocalCalls.convertPrintBySerialResponseToNoSyncCard(printBySerialResponse);
          masterProvider.setUser =
              lg.User.fromJson(jsonDecode(value.body)["user"]);
          await SharedPref.storeUserObject(
              jsonEncode(masterProvider.getUser.toJson()));
          }
      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

  static Future<int> getAgents(
      MasterProvider masterProvider, AgentsProvider agentsProvider) async {
    return await http
        .post(constants["baseUrl"] + constants['get_agents'],
        headers: requestHeaders,
        body: jsonEncode({
          "key": constants['key'],
          "user_token": masterProvider.getUser.userToken,
        }))
        .then((value) async{

      if(value.statusCode == 200){
        AgentsResponse agentsResponse = agentsResponseFromJson(value.body);
        agentsProvider.setAgents = agentsResponse.agents;
        agentsProvider.setSearchableAgents = agentsResponse.agents;
        masterProvider.setUser = lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(jsonEncode(masterProvider.getUser.toJson()));
      }
      return value.statusCode;
    }).catchError((onError) {

      return -1;
    });
  }

  static Future<int> activateAgent(MasterProvider masterProvider, String otp, String phoneNumber) async {
    return await http
        .post(constants["baseUrl"] + constants['activate_agent'],
        headers: requestHeaders,
        body: jsonEncode({
          "key": constants['key'],
          "user_token": masterProvider.getUser.userToken,
          "otp":otp,
          "phone":phoneNumber
        }))
        .then((value) async{
      if(value.statusCode == 200){
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));
      }
      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

  static Future<int> registerAgent(
      MasterProvider masterProvider,AgentsProvider agentsProvider, String name, String phoneNumber) async {
    return await http
        .post(constants["baseUrl"] + constants['register_agent'],
        headers: requestHeaders,
        body: jsonEncode({
          "key": constants['key'],
          "user_token": masterProvider.getUser.userToken,
          "name":name,
          "phone":phoneNumber
        }))
        .then((value) async{
      if(value.statusCode == 200){
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));
      }
      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

  static Future<int> refillAgentBalance(MasterProvider masterProvider, String balance,String phoneNumber, String remark) async {
    return await http
        .post(constants["baseUrl"] + constants['refill_balance'],
        headers: requestHeaders,
        body: jsonEncode({
          "key": constants['key'],
          "user_token": masterProvider.getUser.userToken,
          "amount":balance,
          "phone":phoneNumber,
          "remark":remark
        }))
        .then((value) async{
      print(value.body);
      print(value.statusCode);
      if(value.statusCode == 200){
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));
      }
      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

  static Future<List<agh.Result>> agentRefillHistory(
      MasterProvider masterProvider, int pageNumber, AgentRefillHistoryProvider agentRefillHistoryProvider) async {

    return await http
        .post(constants["baseUrl"] + constants['agent_refill_history'],
        headers: requestHeaders,
        body: jsonEncode({
          "key": constants['key'],
          "user_token": masterProvider.getUser.userToken,
          "page": pageNumber
        }))
        .then((value) async {
      agentRefillHistoryProvider.setReturnStatus = value.statusCode;
      if (value.statusCode == 200) {
        agh.AgentsRefillHistoryResponse agentsRefillHistoryResponse =
        agh.agentsRefillHistoryResponseFromJson(value.body);
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));
        return agentsRefillHistoryResponse.data.results;
      }
      return [];
    }).catchError((onError) {
      print(onError);
      return [];
    });
  }

  static Future<int> resendOTP(
      MasterProvider masterProvider, String phoneNumber) async {
    return await http
        .post(constants["baseUrl"] + constants['agent_resend_otp'],
        headers: requestHeaders,
        body: jsonEncode({
          "key": constants['key'],
          "user_token": masterProvider.getUser.userToken,
          "phone":phoneNumber
        }))
        .then((value) async{
      if(value.statusCode == 200){
        masterProvider.setUser =
            lg.User.fromJson(jsonDecode(value.body)["user"]);
        await SharedPref.storeUserObject(
            jsonEncode(masterProvider.getUser.toJson()));
      }
      return value.statusCode;
    }).catchError((onError) {
      return -1;
    });
  }

}
