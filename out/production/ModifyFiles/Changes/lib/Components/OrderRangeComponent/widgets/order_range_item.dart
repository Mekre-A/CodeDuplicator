import 'package:evd_retailer/Models/SyncCard.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/LocalCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class OrderRangeItem extends StatelessWidget{

  OrderRangeItem(this.syncCard);
  final SyncCard syncCard;
  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
    return InkWell(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("${getTranslated(context, "orderRange.orderId")} ",style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("${syncCard.getOrderId}",style: TextStyle(fontSize:16, fontWeight: FontWeight.bold),)
                ],
              ),
              Container(height: 3.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("${getTranslated(context, "orderRange.serialNumber")} "),
                  Text("${syncCard.getSerialNumber}",style: TextStyle(fontSize:16, fontWeight: FontWeight.bold))
                ],
              ),
            ],
          ),

        )
      ),
      onTap: (){
        if(masterProvider.getConnectedToBluetooth){
          LocalCalls.rePrintCard(syncCard, masterProvider);
        }
        else{
          Fluttertoast.showToast(
            msg: getTranslated(context, "orderRange.connectToBluetoothDeviceFirst"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.black,
          );
        }
      },
    );
  }
}