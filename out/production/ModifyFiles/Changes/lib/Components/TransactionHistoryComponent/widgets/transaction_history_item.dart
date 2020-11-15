

import 'package:evd_retailer/Models/TransactionHistoryResponse.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionHistoryItem extends StatelessWidget{

  TransactionHistoryItem(this.result);
  final formatCurrency = NumberFormat.simpleCurrency();

  final Result result;
  @override
  Widget build(BuildContext context) {
    return Card(
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
                Text(result.ttNumber,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                Text(formatCurrency.format(int.parse(result.balanceAmount)).substring(1) + " ${getTranslated(context, "CardHistoryScreen.etb")}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
              ],
            ),
            Container(height: 3,),
            Text("${getTranslated(context,"transactionHistory.startingBalance")}: ${formatCurrency.format(int.parse(result.beginningBalance)).substring(1)} ETB",style: TextStyle(color: Colors.grey[600]),),
            Container(height: 3,),
            Text("${getTranslated(context, "transactionHistory.closingBalance")}: ${formatCurrency.format(int.parse(result.closingBalance)).substring(1)} ETB",style: TextStyle(color: Colors.grey[600]),),
            Container(height: 3,),
            Text("${getTranslated(context, "transactionHistory.reason")}: ${result.reason}",style: TextStyle(color: Colors.grey[600]),),
            Container(height: 3,),
            Text("${getTranslated(context,"transactionHistory.transactionDate")}: ${DateFormat("yyyy-MM-dd").add_jm().format(result.transactionDate)}",style: TextStyle(color: Colors.grey[600]),),
            Divider(color: Colors.grey,)
          ],
        ),
      ),
    );
  }
}