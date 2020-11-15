import 'package:evd_retailer/Models/UssdHistoryResponse.dart';
import 'package:evd_retailer/Services/LocalCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UssdHistoryItem extends StatelessWidget{

  UssdHistoryItem(this.result);

  final formatCurrency = NumberFormat.simpleCurrency();

  final Result result;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.all(0.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(getTranslated(context, "ussdHistory.serialNumber"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  Text(result.serialNumber,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                ],
              ),
              Container(height: 3.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(getTranslated(context, "ussdHistory.cardAmount"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  Text("${result.cardAmount} ${getTranslated(context, "CardHistoryScreen.etb")}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                ],
              ),
              Container(height: 3.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("${getTranslated(context, "ussdHistory.refilledTo")}:",style: TextStyle(color: Colors.grey[600])),
                  Text("${result.phone}",style: TextStyle(color: Colors.grey[600]),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("${getTranslated(context, "ussdHistory.refilledDate")}:",style: TextStyle(color: Colors.grey[600])),
                  Text("${DateFormat("yyyy-MM-dd").add_jm().format(result.date)}",style: TextStyle(color: Colors.grey[600]),),
                ],
              ),
              Container(height: 3.0,),
              Divider(color: Colors.grey,)
            ],
          ),
        ),
      ),
      onTap: ()async{
       await LocalCalls.reFillCredit(result.cardNumber, result.phone,context);
      },
    );
  }
}