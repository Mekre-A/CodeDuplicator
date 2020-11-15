import 'package:evd_retailer/Models/StoredCard.dart';
import 'package:evd_retailer/Models/SyncCard.dart';
import 'package:sqflite/sqflite.dart';

class SqlDatabase {
  Database database;



  Future<bool> openDB(String userId) async {
    String path = await getPath(userId);
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE FiveBirr(cardDate Text, cardId TEXT , cardAmount TEXT, cardStatus Integer, serialNumber Text, cardNumber Text, confirmationStatus Integer)');
      await db.execute(
          'CREATE TABLE TenBirr(cardDate Text, cardId TEXT, cardAmount TEXT, cardStatus Integer, serialNumber Text, cardNumber Text, confirmationStatus Integer)');
      await db.execute(
          'CREATE TABLE FifteenBirr(cardDate Text, cardId TEXT, cardAmount TEXT, cardStatus Integer, serialNumber Text, cardNumber Text, confirmationStatus Integer)');
      await db.execute(
          'CREATE TABLE TwentyFiveBirr(cardDate Text, cardId TEXT, cardAmount TEXT, cardStatus Integer, serialNumber Text, cardNumber Text, confirmationStatus Integer)');
      await db.execute(
          'CREATE TABLE FiftyBirr(cardDate Text, cardId TEXT, cardAmount TEXT, cardStatus Integer, serialNumber Text, cardNumber Text, confirmationStatus Integer)');
      await db.execute(
          'CREATE TABLE OneHundredBirr(cardDate Text, cardId TEXT, cardAmount TEXT, cardStatus Integer, serialNumber Text, cardNumber Text, confirmationStatus Integer)');
      await db.execute(
          'CREATE TABLE TwoHundredFiftyBirr(cardDate Text, cardId TEXT, cardAmount TEXT, cardStatus Integer, serialNumber Text, cardNumber Text, confirmationStatus Integer)');
      await db.execute(
          'CREATE TABLE FiveHundredBirr(cardDate Text, cardId TEXT, cardAmount TEXT, cardStatus Integer, serialNumber Text, cardNumber Text, confirmationStatus Integer)');
      await db.execute(
          'CREATE TABLE OneThousandBirr(cardDate Text, cardId TEXT, cardAmount TEXT, cardStatus Integer, serialNumber Text, cardNumber Text, confirmationStatus Integer)');
      await db.execute(
          'CREATE TABLE SyncCard(serialNumber Text, cardDate Text, cardId TEXT, cardStatus Integer, cardAmount Text, cardNumber Text, phone Text, orderId Integer, groupId Integer, printed Integer, confirmedFromServer Integer, confirmedDate Text, source Integer,totalCardsInGroup Integer, range Text)');
      await db.execute('Create Table OrderId(orderId Integer )');
      await db.insert("orderId", {'orderId': 0});
      await db.execute('Create Table GroupId(groupId Integer )');
      await db.insert("groupId", {'groupId': 0});
      await db.execute("Create table deleteLog(date Text, count Integer )");
      await db.execute("Create table passKey(passKey Text)");
      await db.insert("passKey", {"passKey":"1234"});
    }).catchError((onError){
      print(onError);
      return false;
    });

    return database.isOpen;
  }

  Future<String> getPath(String userId) async {
    String path = await getDatabasesPath();
    return path + '${userId}mobileCard.db';
  }

  Future<bool> insertIntoCards(List<StoredCard> cards) async {

    Batch newBatch = database.batch();

    cards.forEach((card) {
      if(card.getCardAmount == "5"){
        newBatch.insert('FiveBirr', {
          'cardDate': card.getCardDate,
          'cardId': card.getCardId,
          'cardAmount': card.getCardAmount,
          'cardStatus': card.getCardStatus,
          'serialNumber': card.getSerialNumber,
          'cardNumber': card.getCardNumber,
          'confirmationStatus': card.getConfirmationStatus
        });
      }
      else if(card.getCardAmount == "10"){
        newBatch.insert('TenBirr', {
          'cardDate': card.getCardDate,
          'cardId': card.getCardId,
          'cardAmount': card.getCardAmount,
          'cardStatus': card.getCardStatus,
          'serialNumber': card.getSerialNumber,
          'cardNumber': card.getCardNumber,
          'confirmationStatus': card.getConfirmationStatus
        });
      }
      else if(card.getCardAmount == "15"){
        newBatch.insert('FifteenBirr', {
          'cardDate': card.getCardDate,
          'cardId': card.getCardId,
          'cardAmount': card.getCardAmount,
          'cardStatus': card.getCardStatus,
          'serialNumber': card.getSerialNumber,
          'cardNumber': card.getCardNumber,
          'confirmationStatus': card.getConfirmationStatus
        });
      }
      else if(card.getCardAmount == "25"){
        newBatch.insert('TwentyFiveBirr', {
          'cardDate': card.getCardDate,
          'cardId': card.getCardId,
          'cardAmount': card.getCardAmount,
          'cardStatus': card.getCardStatus,
          'serialNumber': card.getSerialNumber,
          'cardNumber': card.getCardNumber,
          'confirmationStatus': card.getConfirmationStatus
        });
      }
      else if(card.getCardAmount == "50"){
        newBatch.insert('FiftyBirr', {
          'cardDate': card.getCardDate,
          'cardId': card.getCardId,
          'cardAmount': card.getCardAmount,
          'cardStatus': card.getCardStatus,
          'serialNumber': card.getSerialNumber,
          'cardNumber': card.getCardNumber,
          'confirmationStatus': card.getConfirmationStatus
        });
      }
      else if(card.getCardAmount == "100"){
        newBatch.insert('OneHundredBirr', {
          'cardDate': card.getCardDate,
          'cardId': card.getCardId,
          'cardAmount': card.getCardAmount,
          'cardStatus': card.getCardStatus,
          'serialNumber': card.getSerialNumber,
          'cardNumber': card.getCardNumber,
          'confirmationStatus': card.getConfirmationStatus
        });
      }
      else if(card.getCardAmount == "250"){
        newBatch.insert('TwoHundredFiftyBirr', {
          'cardDate': card.getCardDate,
          'cardId': card.getCardId,
          'cardAmount': card.getCardAmount,
          'cardStatus': card.getCardStatus,
          'serialNumber': card.getSerialNumber,
          'cardNumber': card.getCardNumber,
          'confirmationStatus': card.getConfirmationStatus
        });
      }
      else if(card.getCardAmount == "500"){
        newBatch.insert('FiveHundredBirr', {
          'cardDate': card.getCardDate,
          'cardId': card.getCardId,
          'cardAmount': card.getCardAmount,
          'cardStatus': card.getCardStatus,
          'serialNumber': card.getSerialNumber,
          'cardNumber': card.getCardNumber,
          'confirmationStatus': card.getConfirmationStatus
        });
      }
      else if(card.getCardAmount == "1000"){
        newBatch.insert('OneThousandBirr', {
          'cardDate': card.getCardDate,
          'cardId': card.getCardId,
          'cardAmount': card.getCardAmount,
          'cardStatus': card.getCardStatus,
          'serialNumber': card.getSerialNumber,
          'cardNumber': card.getCardNumber,
          'confirmationStatus': card.getConfirmationStatus,
        });
      }
    });


    return await newBatch.commit(noResult: false).then((value) {
      return true;
    }).catchError((onError) {
      print(onError);
      return false;
    });
  }

  Future<bool> updateDb(int cardAmount, List<SyncCard> accessedCards, int groupId, int orderId, int firstRowId, int lastRowId) async {
    Batch newBatch = database.batch();
    // delete the cards from cards table and update them to sync cards as well as update the orderId and groupId

    newBatch.rawQuery("delete from ${getTableNameFromCard(cardAmount.toString())} where rowId between $firstRowId AND $lastRowId");

    accessedCards.forEach((card) => newBatch.insert('SyncCard', {
      'serialNumber': card.getSerialNumber,
      'cardDate': card.getCardDate,
      'cardNumber': card.getCardNumber,
      'cardAmount': card.getCardAmount,
      'cardId': card.getCardId,
      'cardStatus': card.getCardStatus,
      'phone': card.getPhone,
      'orderId': card.getOrderId,
      'groupId': card.getGroupId,
      'printed': card.isPrinted,
      'confirmedFromServer': card.getConfirmedFromServer,
      'confirmedDate':card.getConfirmedDate,
      'source':card.getSource,
      'totalCardsInGroup':card.getTotalCardsInGroup,
      "range":card.getRange
    }));
    if(groupId != -1){
    newBatch.update("groupId", {'groupId': groupId});
    }

    newBatch.update("orderId", {'orderId': orderId});

    return await newBatch
        .commit(noResult: false, continueOnError: false)
        .then((value) {

          print("Updated the db with this value");
        return true;
    }).catchError((onError) {
      print(onError);
      return false;
    });
  }

  Future<bool> updateDbFromOnline(int cardAmount, List<SyncCard> accessedCards, int groupId, int orderId) async {
    Batch newBatch = database.batch();

    accessedCards.forEach((card) => newBatch.insert('SyncCard', {
      'serialNumber': card.getSerialNumber,
      'cardDate': card.getCardDate,
      'cardNumber': card.getCardNumber,
      'cardAmount': card.getCardAmount,
      'cardId': card.getCardId,
      'cardStatus': card.getCardStatus,
      'phone': card.getPhone,
      'orderId': card.getOrderId,
      'groupId': card.getGroupId,
      'printed': card.isPrinted,
      'confirmedFromServer': card.getConfirmedFromServer,
      'confirmedDate':card.getConfirmedDate,
      'source':card.getSource,
      'totalCardsInGroup':card.getTotalCardsInGroup,
      "range":card.getRange
    }));
    if(groupId != -1){
      newBatch.update("groupId", {'groupId': groupId});
    }

    newBatch.update("orderId", {'orderId': orderId});

    return await newBatch
        .commit(noResult: false, continueOnError: false)
        .then((value) {

      print("Updated the db with this value");
      return true;
    }).catchError((onError) {
      print(onError);
      return false;
    });
  }

  Future<bool> clearStoredCards()async{
    Batch newBatch = database.batch();

    newBatch.delete(getTableNameFromCard("5"));
    newBatch.delete(getTableNameFromCard("10"));
    newBatch.delete(getTableNameFromCard("15"));
    newBatch.delete(getTableNameFromCard("25"));
    newBatch.delete(getTableNameFromCard("50"));
    newBatch.delete(getTableNameFromCard("100"));
    newBatch.delete(getTableNameFromCard("250"));
    newBatch.delete(getTableNameFromCard("500"));
    newBatch.delete(getTableNameFromCard("1000"));

    return await newBatch.commit(noResult: true,continueOnError: false).then((value){
      return true;
    }).catchError((onError){
      return false;
    });

  }

  Future<Map<String, List<StoredCard>>> getAllConfirmedData() async {
    Map<String, List<StoredCard>> listOfCards = {};

    await database.query("Fivebirr",
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [1]).then((value) {
      listOfCards["5"] = value.map((e) => StoredCard.fromJson(e)).toList();
    }).catchError((onError) {
      print(onError);
      print("Error with accessing fivebirr");
    });

    await database.query("TenBirr",
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [1]).then((value) {
      listOfCards["10"] = value.map((e) => StoredCard.fromJson(e)).toList();
    }).catchError((onError) {
      print(onError);
      print("Error with accessing tenbirr");
    });

    await database.query("fifteenbirr",
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [1]).then((value) {
      listOfCards["15"] = value.map((e) => StoredCard.fromJson(e)).toList();
    }).catchError((onError) {
      print(onError);
      print("Error with accessing fifteenbirr");
    });

    await database.query("twentyfivebirr",
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [1]).then((value) {
      listOfCards["25"] = value.map((e) => StoredCard.fromJson(e)).toList();
    }).catchError((onError) {
      print(onError);
      print("Error with accessing twentyfivebirr");
    });

    await database.query("fiftybirr",
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [1]).then((value) {
      listOfCards["50"] = value.map((e) => StoredCard.fromJson(e)).toList();
    }).catchError((onError) {
      print(onError);
      print("Error with accessing fiftybirr");
    });

    await database.query("onehundredbirr",
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [1]).then((value) {
      listOfCards["100"] = value.map((e) => StoredCard.fromJson(e)).toList();
    }).catchError((onError) {
      print(onError);
      print("Error with accessing onehundredbirr");
    });

    await database.query("twohundredfiftybirr",
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [1]).then((value) {
      listOfCards["250"] = value.map((e) => StoredCard.fromJson(e)).toList();
    }).catchError((onError) {
      print(onError);
      print("Error with accessing fivebirr");
    });

    await database.query("fivehundredbirr",
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [1]).then((value) {
      listOfCards["500"] = value.map((e) => StoredCard.fromJson(e)).toList();
    }).catchError((onError) {
      print(onError);
      print("Error with accessing fivehundredbirr");
    });

    await database.query("onethousandbirr",
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [1]).then((value) {
      listOfCards["1000"] = value.map((e) => StoredCard.fromJson(e)).toList();
    }).catchError((onError) {
      print(onError);
      print("Error with accessing onethousandbirr");
    });

    listOfCards.forEach((key, value) {
      value.forEach((element) {
        print(element.getConfirmationStatus);
      });
    });

    return listOfCards;
  }

  Future<bool> insertIntoSyncCards(List<SyncCard> cards) async {
    Batch newBatch = database.batch();
    cards.forEach((card) => newBatch.insert('SyncCard', {
          'serialNumber': card.getSerialNumber,
          'cardDate': card.getCardDate,
          'cardNumber': card.getCardNumber,
          'cardAmount': card.getCardAmount,
          'cardId': card.getCardId,
          'cardStatus': card.getCardStatus,
          'phone': card.getPhone,
          'orderId': card.getOrderId,
          'groupId': card.getGroupId,
          'printed': card.isPrinted,
          'confirmedFromServer': card.getConfirmedFromServer,
          'confirmedDate':card.getConfirmedDate,
          'source':card.getSource,
          'totalCardsInGroup':card.getTotalCardsInGroup,
          "range":card.getRange
        }));
    return await newBatch.commit().then((value) {
      print(value);
      print("Inserted into sync cards");
      return true;
    });
  }

  Future<List<SyncCard>> getUnconfirmedSyncCards(int count) async {
    List<SyncCard> syncCards = [];

    if(count == -1){
      return await database.query('synccard',
          where: 'confirmedFromServer like ?', whereArgs: [0])
          .then((value) {

        syncCards = value.map((e) => SyncCard.fromDBJson(e)).toList();
        return syncCards;
      });
    }
    else {
      return await database.query('synccard',
          columns: ["rowId", "*"],
          where: 'confirmedFromServer like ? limit $count', whereArgs: [0])
          .then((value) {
        syncCards = value.map((e) => SyncCard.fromDBJson(e)).toList();
        return syncCards;
      });
    }
  }

  Future<int> getTotalNumberOfUnSyncedCards()async{
    return (await database.rawQuery("select count(*) as count from synccard where confirmedFromServer = 0"))[0]['count'];
  }


  Future<List<SyncCard>> getAllPrintedSyncCards() async {
    List<SyncCard> syncCards = [];
    return await database.query('synccard',
        where: 'printed like ?', whereArgs: [1]).then((value) {
      syncCards = value.map((e) => SyncCard.fromDBJson(e)).toList();
      return syncCards;
    }).catchError((onError) {
      print(onError);
      return [];
    });
  }


  Future<Map<String,dynamic>> syncUnconfirmedData() async {
    List<StoredCard> unConfirmedCards = [];
    List<String> affectedTables = [];

    await database.query(getTableNameFromCard("5"),
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [0]).then((value) {
      value.map((e) => StoredCard.fromJson(e)).toList().forEach((element) {
        unConfirmedCards.add(element);
      });
      if(value.isNotEmpty){
        affectedTables.add("5");
      }
    }).catchError((onError) {
      print(onError);
      print("Error with accessing fivebirr");
    });
    await database.query(getTableNameFromCard("10"),
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [0]).then((value) {
      value.map((e) => StoredCard.fromJson(e)).toList().forEach((element) {
        unConfirmedCards.add(element);
      });
      if(value.isNotEmpty){
        affectedTables.add("10");
      }
    }).catchError((onError) {
      print(onError);
      print("Error with accessing fivebirr");
    });
    await database.query(getTableNameFromCard("15"),
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [0]).then((value) {
      value.map((e) => StoredCard.fromJson(e)).toList().forEach((element) {
        unConfirmedCards.add(element);
      });
      if(value.isNotEmpty){

        affectedTables.add("15");
      }
    }).catchError((onError) {
      print(onError);
      print("Error with accessing fivebirr");
    });

    await database.query(getTableNameFromCard("25"),
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [0]).then((value) {
      value.map((e) => StoredCard.fromJson(e)).toList().forEach((element) {
        unConfirmedCards.add(element);
      });
      if(value.isNotEmpty){

        affectedTables.add("25");
      }
    }).catchError((onError) {
      print(onError);
      print("Error with accessing fivebirr");
    });
    await database.query(getTableNameFromCard("50"),
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [0]).then((value) {
      value.map((e) => StoredCard.fromJson(e)).toList().forEach((element) {
        unConfirmedCards.add(element);
      });
      if(value.isNotEmpty){
        affectedTables.add("50");
      }
    }).catchError((onError) {
      print(onError);
      print("Error with accessing fivebirr");
    });
    await database.query(getTableNameFromCard("100"),
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [0]).then((value) {
      value.map((e) => StoredCard.fromJson(e)).toList().forEach((element) {
        unConfirmedCards.add(element);
      });
      if(value.isNotEmpty){
        affectedTables.add("100");
      }
    }).catchError((onError) {
      print(onError);
      print("Error with accessing fivebirr");
    });
    await database.query(getTableNameFromCard("250"),
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [0]).then((value) {
      value.map((e) => StoredCard.fromJson(e)).toList().forEach((element) {
        unConfirmedCards.add(element);
      });
      if(value.isNotEmpty){

        affectedTables.add("250");
      }
    }).catchError((onError) {
      print(onError);
      print("Error with accessing fivebirr");
    });
    await database.query(getTableNameFromCard("500"),
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [0]).then((value) {
      value.map((e) => StoredCard.fromJson(e)).toList().forEach((element) {
        unConfirmedCards.add(element);
      });
      if(value.isNotEmpty){
        affectedTables.add("500");
      }
    }).catchError((onError) {
      print(onError);
      print("Error with accessing fivebirr");
    });
    await database.query(getTableNameFromCard("1000"),
        columns: ["rowId", "*"],
        where: 'confirmationStatus like ?', whereArgs: [0]).then((value) {
      value.map((e) => StoredCard.fromJson(e)).toList().forEach((element) {
        unConfirmedCards.add(element);
      });
      if(value.isNotEmpty){
        affectedTables.add("1000");
      }
    }).catchError((onError) {
      print(onError);
      print("Error with accessing fivebirr");
    });

    return {
      "unConfirmed":unConfirmedCards,
      "affectedTables":affectedTables
    };
  }

  Future<bool> doesSyncTableHaveContent() async {
    if ((await database.rawQuery("select count(*) as count from synccard"))[0]
            ['count'] !=
        0) {
      return true;
    }
    return false;
  }

  String getTableNameFromCard(String cardAmount) {
    if (int.parse(cardAmount) == 5) {
      return "fivebirr";
    } else if (int.parse(cardAmount) == 10) {
      return "tenbirr";
    } else if (int.parse(cardAmount) == 15) {
      return "fifteenbirr";
    } else if (int.parse(cardAmount) == 25) {
      return "twentyfivebirr";
    } else if (int.parse(cardAmount) == 50) {
      return "fiftybirr";
    } else if (int.parse(cardAmount) == 100) {
      return "onehundredbirr";
    } else if (int.parse(cardAmount) == 250) {
      return "twohundredfiftybirr";
    } else if (int.parse(cardAmount) == 500) {
      return "fivehundredbirr";
    } else if (int.parse(cardAmount) == 1000) {
      return "onethousandbirr";
    } else {
      return "";
    }
  }


  Future<bool> updateConfirmationOfStoredItem(List<String> affectedTables) async {
    Batch newBatch = database.batch();

    print(affectedTables.length);
    affectedTables.forEach((element) {
      newBatch.update(getTableNameFromCard(element), {'confirmationStatus': 1},where: 'confirmationStatus = ?', whereArgs: [0]);
    });

    return await newBatch.commit(noResult: false,continueOnError: false).then((value){
      print("I have confirmed ${value.length}");
      return true;
    }).catchError((onError){
      print(onError);
      print("I have error");
      return false;
    });
  }

  Future<bool> updateConfirmationOfLimitedSyncItem(List<SyncCard> cards, String date, int count, int firstRowId, int lastRowId) async {
    Batch newBatch = database.batch();


    newBatch.rawQuery("update synccard set confirmedFromServer=1 where rowId between $firstRowId AND $lastRowId");

    newBatch.insert("deleteLog", {'date': date, 'count':count});

    return await newBatch.commit(continueOnError: false,noResult: true).then((value){
      return true;
    }).catchError((onError){
      return false;
    });
  }

  Future<bool> updateConfirmationOfSyncItem(List<SyncCard> cards, String date, int count) async {
    Batch newBatch = database.batch();

    newBatch.update('synccard', {'confirmedFromServer': 1, 'confirmedDate':date},
        where: 'confirmedFromServer = ?', whereArgs: [0]);
    newBatch.insert("deleteLog", {'date': date, 'count':count});

    return await newBatch.commit(continueOnError: false,noResult: true).then((value){
      return true;
    }).catchError((onError){
      return false;
    });
  }


  Future<int> getOrderId() async {
    int count =
        (await database.rawQuery("select * from orderId"))[0]['orderId'];
    return count;
  }

  Future<int> getGroupId() async {
    int count =
        (await database.rawQuery("select * from groupId"))[0]['groupId'];
    return count;
  }

  Future<bool> updateGroupAndOrderId(int groupId, int orderId )async{
    Batch newBatch = database.batch();

    newBatch.update("groupId", {'groupId': groupId});
    newBatch.update("orderId", {'orderId': orderId});

    return await newBatch.commit(continueOnError: false, noResult: true).then((value){
      return true;
    }).catchError((onError){
      return false;
    });
  }

  Future<List<Map>> getItemsFromDeleteLog() async {
    return await database
        .rawQuery("select * from deleteLog")
        .then((value) {
      return value;
    }).catchError((onError) {
      print(onError);
      return [];
    });
  }

  Future deleteItemsFromDeleteLogAndSyncTable(List<String> dates) async {
    Batch newBatch = database.batch();
    dates.forEach((date) {
      newBatch.rawQuery("delete from deleteLog where date = '$date'");
      newBatch.rawQuery("delete from synccard where confirmedFromServer = 1 and confirmedDate = '$date'");
    });
    return await newBatch.commit(noResult: false,continueOnError: false);

  }

  Future<bool> updatePassKey(String key) async {
    await database.update("passKey", {'passKey': key});
    return true;
  }

  Future<String> getPassKey() async {
    String count =(await database.rawQuery("select * from passKey"))[0]['passKey'];
    return count;
  }

  Future<int> saveLostCards(List<SyncCard> cards)async{

    Batch newBatch = database.batch();


    return await database.rawQuery("select count(*) as count from synccard where cardId = ${cards.first.getCardId}").then((value)async{
        if(value[0]['count'] > 0){
          //card already exists just sync
          return 0;
        }
          int orderId = await getOrderId();
          int orderIdForLoop = await getOrderId();
          int groupId = await getGroupId();
          groupId +=1;

          cards.forEach((card) {
            orderId +=1;
            newBatch.insert('SyncCard', {
              'serialNumber': card.getSerialNumber,
              'cardDate': card.getCardDate,
              'cardNumber': card.getCardNumber,
              'cardAmount': card.getCardAmount,
              'cardId': card.getCardId,
              'cardStatus': card.getCardStatus,
              'phone': card.getPhone,
              'orderId': orderId,
              'groupId': groupId,
              'printed': 1,
              'confirmedFromServer': 0,
              'confirmedDate':"",
              'source':card.getSource,
              'totalCardsInGroup':card.getTotalCardsInGroup,
              "range":"${orderIdForLoop +1} - ${orderIdForLoop + cards.length}"
            });
          });

          newBatch.update("groupId", {'groupId': groupId});

          newBatch.update("orderId", {'orderId': orderId});

          return await newBatch.commit(continueOnError: false,noResult: true).then((value){
            return 0;
          }).catchError((onError){
            return 1;
          });
      }).catchError((onError){
        return 1;
    });


  }

  Future<bool> resetOrderIdManually()async{

    Batch newBatch = database.batch();

    newBatch.delete("synccard");
    newBatch.delete("deleteLog");
    newBatch.update("orderId", {'orderId': 0});

    return await newBatch.commit().then((value){
      return true;
    }).catchError((onError){
      return false;
    });

  }

}
