import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/BluetoothPrinterConnection.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class TestPrint extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context, listen: false);
    return ListTile(
      title: Text(getTranslated(context, "SettinScreen.testPrint")),
      onTap: (){
        if(!masterProvider.getConnectedToBluetooth){
          Fluttertoast.showToast(
              msg: getTranslated(context, "SettinScreen.connectToBluetoothFirst"),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        else{
          BluetoothPrinterConnection.testPrint();
        }

      },
    );
  }
}