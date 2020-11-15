
import 'package:evd_retailer/Models/AgentRefillHistoryResponse.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgentRefillHistoryItem extends StatelessWidget{

  AgentRefillHistoryItem(this.result);

  final Result result;

  final formatCurrency = NumberFormat.simpleCurrency(decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Card(
            elevation: 0.0,
            margin: EdgeInsets.all(0.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0,vertical:10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${result.userName}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          Container(height: 5,),
                          Text(DateFormat("yyyy-MM-dd").add_jm().format(result.date),style: TextStyle(fontSize: 14,color: Colors.grey),),
                        ],
                      ),

                      Text("${formatCurrency.format(int.parse(result.balance)).substring(1)} ${getTranslated(context, "CardHistoryScreen.etb")}",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),)
                    ],
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.grey[200],)
        ],
      ),
    );
  }
}