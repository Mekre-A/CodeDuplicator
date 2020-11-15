import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:evd_retailer/Models/NoSyncCard.dart';
import 'package:evd_retailer/Models/PrintedCards.dart' as pt;
import 'package:evd_retailer/Models/StoredCard.dart';
import 'package:evd_retailer/Models/SyncCard.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothPrinterConnection {

  static BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  static Permission permission = Permission.location;

  static List<BluetoothDevice> pairedDevices = [];


  static String pathImage = "";
  static const String poweredBy = "Test";
  final formatCurrency = NumberFormat.simpleCurrency();
  static BluetoothDevice connectedDevice;

  static Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  static Future<bool> initPlatformState(MasterProvider masterProvider) async {
    final filename = 'etcompanies.png';
    var bytes = await rootBundle.load("assets/images/print.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes,'$dir/$filename');
    pathImage='$dir/$filename';

    if (!(await permission.isGranted)) {
      await permission.request();
      if (await permission.isDenied) {
        return false;
      }
    }

    bluetooth.onStateChanged().listen((state) {
      switch(state){
        case BlueThermalPrinter.CONNECTED:
          // connected
        masterProvider.setConnectedToBluetooth = true;
          break;
        case BlueThermalPrinter.DISCONNECTED:
          masterProvider.setConnectedToBluetooth = false;
          break;
      }
    });
    return true;
  }

  static Future<List<BluetoothDevice>> getListOfPairedDevices()async{
    if (!(await permission.isGranted)) {
      await permission.request();
      if (await permission.isDenied) {
        return [];
      }
    }

    if(! (await bluetooth.isOn)){

      return [];
    }

    try {
      pairedDevices = await bluetooth.getBondedDevices();
    } on PlatformException catch (e) {
      return [];
    }

    return pairedDevices;
  }

  static Future<bool> connectFromList(BluetoothDevice selectedDevice, MasterProvider masterProvider,BuildContext context) async {
    if (!(await bluetooth.isOn)) {
      Fluttertoast.showToast(
        msg: getTranslated(context, "bluetoothService.pleaseTurnOnBluetooth"),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.black,
      );

      return false;
    }
    else {
      return await bluetooth.isConnected.then((isConnected) async {
        if (!isConnected) {
          Fluttertoast.showToast(
            msg: getTranslated(context, "bluetoothService.pleaseWait"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.yellow[900],
            textColor: Colors.black,
          );

          bool deviceConnected = false;
              await bluetooth
                  .connect(selectedDevice)
                  .then((onValue) {
                deviceConnected = true;
                connectedDevice = selectedDevice;
              }).catchError((onError){
              });

          if (deviceConnected) {
            Fluttertoast.showToast(
                msg: getTranslated(context, "bluetoothService.connected"),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            masterProvider.setConnectedToBluetooth = true;
            return true;
          } else {
            Fluttertoast.showToast(
                msg:
                getTranslated(context, "bluetoothService.connectingFailed"),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.black,
                fontSize: 16.0);
            masterProvider.setConnectedToBluetooth = false;
            return false;
          }
        } else {
          // Printer has already been connected
          return true;
        }
      }).catchError((onError) {
        Fluttertoast.showToast(
            msg:
            getTranslated(context, "bluetoothService.connectingFailed"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.black,
            fontSize: 16.0);
        return false;
      });
    }
  }


  static void disconnect() {
    bluetooth.disconnect();
  }

  static Future<bool> printPurchasedTicketsFromOnline(pt.Card card, int cardAmount,String agentName,int orderId, bool shouldIPrintEmptyLines) async{

    return await bluetooth.isConnected.then((value)async{
      if(value){
        await bluetooth.printNewLine();
        await bluetooth.printCustom("$orderId", 1, 1);
        await bluetooth.printImage(pathImage);
        await bluetooth.printCustom("$cardAmount Birr", 2, 1);
        await bluetooth.printCustom("---------e-voucher Pin----------", 0, 1);
        await bluetooth.printCustom(card.cardNumber, 4, 1);
        await bluetooth.printCustom("--------------------------------", 0, 1);
        await bluetooth.printCustom("To Recharge *805*${card.cardNumber.replaceAll(" ", "")}#", 0, 1);
        await bluetooth.printCustom("SN: ${card.serialNumber}", 1, 1);
        await bluetooth.printCustom("Agent-$agentName", 0, 1);
        await bluetooth.printCustom("Powered by $poweredBy", 0, 1);
        await bluetooth.printCustom("=== Thank you for buying ===", 0, 1);
        await bluetooth.printCustom(
            "Date ${DateFormat("yyyy-MM-dd").add_jm().format(card.cardDate)}",
            0,
            1);
        await bluetooth.printCustom("--------------------------------", 0, 1);
        if (shouldIPrintEmptyLines) {
          await bluetooth.printNewLine();
          await bluetooth.printNewLine();
        }
        return true;
      }
      return false;
    }).catchError((onError){
      return false;
    });


  }

  static Future<bool> printPurchasedTicketsFromStock(StoredCard card, int cardAmount,String agentName, int orderId,bool shouldIPrintEmptyLines) async{

    return await bluetooth.isConnected.then((value)async{
      if(value){
        await bluetooth.printNewLine();
        await bluetooth.printCustom("$orderId", 1, 1);
        await bluetooth.printImage(pathImage);
        await bluetooth.printCustom("$cardAmount Birr", 2, 1);
        await bluetooth.printCustom("---------e-voucher Pin----------", 0, 1);
        await bluetooth.printCustom(card.getCardNumber, 4, 1);
        await bluetooth.printCustom("--------------------------------", 0, 1);
        await bluetooth.printCustom("To Recharge *805*${card.getCardNumber.replaceAll(" ", "")}#", 0, 1);
        await bluetooth.printCustom("SN: ${card.getSerialNumber}", 1, 1);
        await bluetooth.printCustom("Agent-$agentName", 0, 1);
        await bluetooth.printCustom("Powered by $poweredBy", 0, 1);
        await bluetooth.printCustom("=== Thank you for buying ===", 0, 1);
        await bluetooth.printCustom(
            "Date ${DateFormat("yyyy-MM-dd").add_jm().format(DateTime.parse(card.getCardDate))}",
            0,
            1);
        await bluetooth.printCustom("--------------------------------", 0, 1);
        if (shouldIPrintEmptyLines) {
          await bluetooth.printNewLine();
          await bluetooth.printNewLine();
        }
        return true;
      }
      else{
        return false;
      }
    }).catchError((onError){
      print(onError);
      return false;
    });


  }
  static Future<bool> rePrintCards(SyncCard card,String agentName,int orderId, bool shouldIPrintEmptyLines) async{
    return await bluetooth.isConnected.then((value)async{
      if(value){
        await bluetooth.printNewLine();
        await bluetooth.printCustom("$orderId", 1, 1);
        await bluetooth.printImage(pathImage);
        await bluetooth.printCustom("Reprinted", 1, 1);
        await bluetooth.printCustom("${card.getCardAmount} Birr", 2, 1);
        await bluetooth.printCustom("---------e-voucher Pin----------",0,1);
        await bluetooth.printCustom(card.getCardNumber,4, 1);
        await bluetooth.printCustom("--------------------------------",0,1);
        await bluetooth.printCustom("To Recharge *805*${card.getCardNumber.replaceAll(" ", "")}#", 0, 1);
        await bluetooth.printCustom("SN: ${card.getSerialNumber}", 1, 1);
        await bluetooth.printCustom("Agent-$agentName", 0, 1);
        await bluetooth.printCustom("Powered by $poweredBy", 0, 1);
        await bluetooth.printCustom("=== Thank you for buying ===", 0, 1);
        await bluetooth.printCustom("Date ${DateFormat("yyyy-MM-dd").add_jm().format(DateTime.parse(card.getCardDate))}", 0, 1);
        print("${DateFormat("yyyy-MM-dd").add_jm().format(DateTime.parse(card.getCardDate))}");
        await bluetooth.printCustom("--------------------------------",0,1);
        if(shouldIPrintEmptyLines){
          await bluetooth.printNewLine();
          await bluetooth.printNewLine();
        }
        return true;
      }
      else{
        return false;
      }

    }).catchError((onError){
      return false;
    });

  }

  static Future<bool> rePrintCardsWithSerial(NoSyncCard card,int orderId, String agentName, bool shouldIPrintEmptyLines) async{
    return await bluetooth.isConnected.then((value)async{
      if(value){
        await bluetooth.printNewLine();
        await bluetooth.printCustom("$orderId", 1, 1);
        await bluetooth.printImage(pathImage);
        await bluetooth.printCustom("Reprinted", 1, 1);
        await bluetooth.printCustom("${card.getCardAmount} Birr", 2, 1);
        await bluetooth.printCustom("---------e-voucher Pin----------",0,1);
        await bluetooth.printCustom(card.getCardNumber,4, 1);
        await bluetooth.printCustom("--------------------------------",0,1);
        await bluetooth.printCustom("To Recharge *805*${card.getCardNumber.replaceAll(" ", "")}#", 0, 1);
        await bluetooth.printCustom("SN: ${card.getSerialNumber}", 1, 1);
        await bluetooth.printCustom("Agent-$agentName", 0, 1);
        await bluetooth.printCustom("Powered by $poweredBy", 0, 1);
        await bluetooth.printCustom("=== Thank you for buying ===", 0, 1);
        await bluetooth.printCustom("Date ${DateFormat("yyyy-MM-dd").add_jm().format(card.getCardDate)}", 0, 1);
        print("${DateFormat("yyyy-MM-dd").add_jm().format(card.getCardDate)}");
        await bluetooth.printCustom("--------------------------------",0,1);
        if(shouldIPrintEmptyLines){
          await bluetooth.printNewLine();
          await bluetooth.printNewLine();
        }
        return true;
      }
      else{
        return false;
      }

    }).catchError((onError){
      return false;
    });

  }

  static Future<bool> testPrint() async{
    return await bluetooth.isConnected.then((value)async{
      if(value){
        await bluetooth.printCustom("--100--", 1, 1);
        await bluetooth.printImage(pathImage);
        await bluetooth.printCustom("Test Print", 2, 1);
        await bluetooth.printCustom("Printer Information", 1, 1);
        await bluetooth.printCustom("Name: ${connectedDevice.name}", 1, 1);
        await bluetooth.printCustom("Address: ${connectedDevice.address}",1, 1);
        await bluetooth.printCustom("Powered by $poweredBy", 0, 1);
        await bluetooth.printCustom("", 0, 1);
        await bluetooth.printCustom("--------------------------------",0,1);
        await bluetooth.printNewLine();
        return true;
      }
      else{
        return false;
      }

    }).catchError((onError){
      return false;
    });

  }


}
